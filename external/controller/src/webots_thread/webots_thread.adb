with Ada.Text_IO; use Ada.Text_IO;

package body Webots_Thread is

   procedure Main is

   begin

      Webots_Address.Addr := Inet_Addr ("127.0.0.1");
      Webots_Address.Port := 9999;
      loop
         Webots_Stream := Tcp_Client.Connect (Webots_Socket, Webots_Address);
         exit when Webots_Stream /= null or Webots_Stop;
      end loop;

      if not Webots_Stop then
         Put_Line ("Connection to webots (127.0.0.1:" & Webots_Address.Port'Image & ") established.");
      end if;

      while not Webots_Stop loop
         begin
            Tcp_Client.Read_Packet (Webots_Stream, Webots_Buffer, Webots_Mailbox);
         exception
            when E : Byte_Buffer.Connection_Closed =>
               declare
                  Mail : Mailbox.Mail;
               begin
                  Mail.Message := new Messages.Message;
                  Mail.Message.Id := Messages.ERROR_WEBOTS_DISCONNECTED;
                  Webots_Mailbox.Deposit (Mail);
               end;
               exit;
         end;
         exit when Webots_Stop;
      end loop;

   end Main;

end Webots_Thread;
