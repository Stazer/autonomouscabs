package body webots_thread is

   name  : Unbounded_String := To_Unbounded_String("webots");

   procedure webots_main is

      --webots_elem : Communication_Packet;

   begin

      Webots_Channel := build_connection (Webots_Client, 2000, Webots_Address);

      Webots_Cmd :=(1,1,1,1,1,1,1,1);

      send_bytes(Webots_Channel, Webots_Cmd);


   end webots_main;


end webots_thread;
