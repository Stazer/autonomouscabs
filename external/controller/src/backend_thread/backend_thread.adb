package body backend_thread is

   name  : Unbounded_String := To_Unbounded_String("backend");

   procedure backend_main is

      --backend_elem : Communication_Packet;

   begin

      Backend_Channel := build_connection ( Backend_Client, 2000, Backend_Address);

      -- test send function
      Backend_Cmd :=(1,1,1,1,1,1,1,1);

      send_bytes(Backend_Channel, Backend_Cmd);

      listen_task.Start(Backend_Channel, Backend_Package_Buffer, Backend_Offset);
      -- listen not finished
      -- listen_task.Start(Backend_Channel, Backend_Header, Backend_Offset);

   end backend_main;


end backend_thread;
