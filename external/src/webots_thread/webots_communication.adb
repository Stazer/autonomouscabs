with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with tcp_client; use tcp_client;

package body webots_communication is

   procedure webots_main is
   begin

      Webots_Channel := build_connection ( Webots_Client, 2000, Webots_Address);

      for I in Integer range 1 .. 10 loop
          Put_Line("Webots");
          Put_Line(Integer'Image(I));
          delay 1.0;
      end loop;


   end webots_main;


end webots_communication;
