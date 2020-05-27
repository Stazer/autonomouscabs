package body backend_thread is

   procedure backend_main is

   begin

      Backend_Channel := build_connection ( Backend_Client, 2000, Backend_Address);

      -- test send function
      Backend_Cmd :=(1,1,1,1,1,1,1,1);

      send_bytes(Backend_Channel, Backend_Cmd);

      -- listen not finished and as is will block the socket
      -- listen_task.Start(Backend_Channel, Backend_Header, Backend_Offset);

      -- test send function
      Backend_Cmd :=(2,2,2,2,2,2,2,2);

      send_bytes(Backend_Channel, Backend_Cmd);

   end backend_main;


end backend_thread;
