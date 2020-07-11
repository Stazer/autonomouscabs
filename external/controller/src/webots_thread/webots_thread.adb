package body Webots_Thread is

   procedure Main is

   begin

      Webots_Channel := Tcp_Client.Connect (Webots_Client, 5555, Webots_Address);
      Webots_Channel2 := Tcp_Client.Connect (Webots_Client, 6666, Webots_Address);

      while true loop
         Tcp_Client.Read_Packet (Webots_Channel, Webots_Vector_Buffer, Webots_Mailbox);
         Tcp_Client.Read_Packet (Webots_Channel2, Webots_Vector_Buffer2, Webots_Mailbox2);
      end loop;

   end Main;

end Webots_Thread;
