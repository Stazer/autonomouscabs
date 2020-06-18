package body backend_thread is

   procedure backend_main is

   begin

      Backend_Channel := build_connection ( Backend_Client, 2000, Backend_Address);

      -- test send function
      Backend_Cmd.package_ID := protocol_join_ID;
      Backend_Cmd.payload_length := 0;
      --Backend_Cmd.local_payload := new types.payload(0..1);
      send_bytes(Backend_Channel, Backend_Cmd);

      while true loop
         listen( Backend_Channel, Backend_Vector_Buffer, Backend_Mailbox );
      end loop;


   end backend_main;

end backend_thread;
