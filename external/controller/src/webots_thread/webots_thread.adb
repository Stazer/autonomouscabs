package body webots_thread is

   procedure webots_main is

   begin

      Webots_Channel := build_connection (Webots_Client, 10000, Webots_Address);

      Webots_Cmd.package_ID := protocol_join_ID;
      Webots_Cmd.payload_length := 0;
      --Backend_Cmd.local_payload := new types.payload(0..1);
      send_bytes(Webots_Channel, Webots_Cmd);

      while true loop
         listen( Webots_Channel, Webots_Vector_Buffer, Webots_Mailbox );
      end loop;

   end webots_main;

end webots_thread;
