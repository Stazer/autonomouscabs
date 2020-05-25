with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with tcp_client; use tcp_client;

package body backend_communication is

   procedure backend_main is

   begin

      Backend_Channel := build_connection ( Backend_Client, 2000, Backend_Address);

      -- simple loop to test, if tasks are working
      for I in Integer range 1 .. 10 loop
           Put_Line("Backend");
           Put_Line(Integer'Image(I));
           delay 1.0;
      end loop;

   end backend_main;


end backend_communication;
