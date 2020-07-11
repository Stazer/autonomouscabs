with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;

with Tcp_Client;
with Types;
with Byte_buffer;
with Mailbox;

package Webots_Thread is

   -- Webots thread variables
   Webots_Client  : Socket_Type; -- stores the socket for the webots controller
   Webots_Channel : Stream_Access; -- socket I/O interface
   Webots_Channel2 : Stream_Access; -- socket I/O interface
   Webots_Address : Sock_Addr_Type; -- stores the server address
   Webots_Cmd : Types.Communication_Packet; -- command to send over socket
   Webots_Vector_Buffer : Byte_buffer.Buffer;
   Webots_Mailbox : Mailbox.Mailbox (Size => 5);
   Webots_Vector_Buffer2 : Byte_buffer.Buffer;
   Webots_Mailbox2 : Mailbox.Mailbox (Size => 5);


   procedure Main;

end Webots_Thread;
