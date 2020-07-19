package body Webots_Thread is

   procedure Main (Webots_Port : Integer) is

   begin

      Webots_Address.Addr := Inet_Addr ("127.0.0.1");
      Webots_Address.Port := Port_Type(Webots_Port);
      Webots_Stream := Tcp_Client.Connect (Webots_Socket, Webots_Address);

      loop
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
      end loop;

   end Main;

end Webots_Thread;
