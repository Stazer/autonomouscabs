package body Webots_Thread is

   procedure Main is

   begin

      Webots_Address.Addr := Inet_Addr ("127.0.0.1");
      Webots_Address.Port := 9999;
      Webots_Stream := Tcp_Client.Connect (Webots_Socket, Webots_Address);

      loop
         Tcp_Client.Read_Packet (Webots_Stream, Webots_Buffer, Webots_Mailbox);
      end loop;

   end Main;

end Webots_Thread;
