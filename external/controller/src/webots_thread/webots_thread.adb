package body webots_thread is

   procedure webots_main is
      test : Float64 := 4.0;
      test_uint64 : uint64;
      test_to_send : Octets_8;
   begin

      Webots_Channel := build_connection (Webots_Client, 9999, Webots_Address);

      test_uint64 :=float64_to_uint64(test);
      test_to_send := uint64_to_octets(test_uint64);
      Webots_Cmd.package_ID := 129;
      Webots_Cmd.payload_length := 5;
      Webots_Cmd.local_payload := new types.payload(0..15);
      --Backend_Cmd.local_payload := new types.payload(0..1);
      send_bytes(Webots_Channel, Webots_Cmd);

      --while true loop
         --listen( Webots_Channel, Webots_Vector_Buffer, Webots_Mailbox );
         --end loop;
      for I in Webots_Cmd.local_payload'Range loop
         Webots_Cmd.local_payload(I) := test_to_send(I mod 8);
      end loop;

   end webots_main;

end webots_thread;
