package body webots_thread is

   procedure webots_main is

   begin

      Webots_Channel := build_connection (Webots_Client, 2000, Webots_Address);

      --Webots_Cmd :=(1,1,1,1,1,1,1,1);

     -- send_bytes(Webots_Channel, Webots_Cmd);

      while true loop
         listen( Webots_Channel, Webots_Vector_Buffer, Webots_Mailbox );
      end loop;

   end webots_main;

end webots_thread;
