with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with tcp_client; use tcp_client;

package body backend_thread is

   procedure backend_main is

   begin

      Backend_Channel := build_connection ( Backend_Client, 2000, Backend_Address);

      -- arbitrary command to test send function
      Backend_Cmd :=(1,1,1,1,1,1,1,1);

      -- should send join here
      send_bytes(Backend_Channel, Backend_Cmd);

      -- listen not finished and as is will block the socket --> commented out
      listen_task.Start(Backend_Channel, Backend_Header, Backend_Offset);

      -- arbitrary command to test send function
      Backend_Cmd :=(2,2,2,2,2,2,2,2);

      send_bytes(Backend_Channel, Backend_Cmd);

   end backend_main;


end backend_thread;
