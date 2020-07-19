with Ada.Text_IO; use Ada.Text_IO;

package body Webots_Thread is

   procedure Main (Webots_Addr : String; Webots_Port : Integer) is

   begin
      Webots_Address.Addr := Inet_Addr (Webots_Addr);
      Webots_Address.Port := Port_Type(Webots_Port);

      loop
         Webots_Stream := Tcp_Client.Connect (Webots_Socket, Webots_Address);
         exit when Webots_Stream /= null or Webots_Stop;
      end loop;

      if not Webots_Stop then
         Put_Line ("Connection to webots (" & Webots_Addr &
                     ":" & Webots_Address.Port'Image & ") established.");
      end if;

      while not Webots_Stop loop
         begin
            Tcp_Client.Read_Packet (Webots_Stream, Webots_Buffer, Webots_Mailbox);
         exception
            when E : Byte_Buffer.Connection_Closed =>
               declare
                  Message : Messages.Message_Ptr :=
                    new Messages.Message'(0, Messages.ERROR_WEBOTS_DISCONNECTED);
                  Mail : Mailbox.Mail := Mailbox.Create_Mail (Message);
               begin
                  Webots_Mailbox.Deposit (Mail);
               end;
               exit;
         end;
         exit when Webots_Stop;
      end loop;

   end Main;

end Webots_Thread;
