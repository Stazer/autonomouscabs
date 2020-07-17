with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Command_line; use Ada.Command_Line;

with Tcp_Client;
with Types;
with Byte_buffer;
with Mailbox;

package Webots_Thread is

   type Thread_Number is range 0 .. 4;
   type Channel_Type is array (Thread_Number) of Stream_Access;
   -- Webots thread variables
   Webots_Client  : Socket_Type; -- stores the socket for the webots controller
   Webots_Channel : Channel_Type; -- socket I/O interface
   Webots_Address : Sock_Addr_Type; -- stores the server address
   Webots_Cmd : Types.Communication_Packet; -- command to send over socket
   Webots_Vector_Buffer : Byte_buffer.Buffer;
   Webots_Mailbox : Mailbox.Mailbox (Size => 5);

   procedure Main;

end Webots_Thread;
