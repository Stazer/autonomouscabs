with Ada.Text_IO; use Ada.Text_IO;

package body Backend_Thread is
   procedure Main (Backend_Addr : String; Backend_Port : Integer) is
   begin
      Backend_Address.Addr := Inet_Addr (Backend_Addr);
      Backend_Address.Port := Port_Type (Backend_Port);

      loop
         Backend_Stream := Tcp_Client.Connect (Backend_Socket, Backend_Address);
         exit when Backend_Stream /= null or Backend_Stop;
      end loop;

      if not Backend_Stop then
         Put_Line ("Connection to backend (" & Backend_Addr &
                     ":" & Backend_Port'Image & ") established.");
      end if;

      Join;

      while not Backend_Stop loop
         begin
            Tcp_Client.Read_Packet (Backend_Stream, Backend_Buffer, Backend_Mailbox);
         exception
            when E : Byte_Buffer.Connection_Closed =>
               declare
                  Message : Messages.Message_Ptr :=
                    new Messages.Message'(0, Messages.ERROR_BACKEND_DISCONNECTED);
                  Mail : Mailbox.Mail := Mailbox.Create_Mail (Message);
               begin
                  Backend_Mailbox.Deposit (Mail);
               end;
               exit;
         end;
      end loop;

   end Main;

   procedure Join
   is
      Join : Messages.Join_Challenge_Message := Messages.Join_Challenge_Message_Create;
      Out_Buffer : Byte_Buffer.Buffer;
   begin
      Out_Buffer.Write_Message (Join);
      Byte_Buffer.Buffer'Write (Backend_Stream, Out_Buffer);
   end Join;

end Backend_Thread;
