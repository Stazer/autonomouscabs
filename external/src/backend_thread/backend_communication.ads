with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;

package backend_communication is

   type Byte is range 0 .. 255;
   type Command is array (1..8) of Byte;

   -- Backend thread variables
   Backend_Client: Socket_Type; -- stores the socket for the backend
   Backend_Channel : Stream_Access; -- socket I/O interface
   Backend_Header : Stream_Element_Array(1..1); --header to check protocol
   Backend_Offset : Stream_Element_Count;
   Backend_Address : Sock_Addr_Type; -- stores the server address
   Backend_Cmd : Command;
   Backend_Port : Port_Type;

   procedure backend_main;

end backend_communication;
