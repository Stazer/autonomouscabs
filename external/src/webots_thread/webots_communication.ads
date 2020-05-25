with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;

package webots_communication is

   type Byte is range 0 .. 255;
   type Command is array (1..8) of Byte;

   -- Webots thread variables
   Webots_Client  : Socket_Type; -- stores the socket for the webots controller
   Webots_Channel : Stream_Access; -- socket I/O interface
   Webots_Header : Stream_Element_Array(1..1); --header to check protocol
   Webots_Offset : Stream_Element_Count;
   Webots_Address : Sock_Addr_Type; -- stores the server address
   Webots_Cmd : Command;
   Webots_Port : Integer;

   procedure webots_main;

end webots_communication;
