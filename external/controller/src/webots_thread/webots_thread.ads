with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;

with Tcp_Client;
with Types;
with Byte_buffer;
with Mailbox;
with Messages;

package Webots_Thread is

   -- Webots thread variables
   Webots_Socket  : Socket_Type; -- stores the socket for the webots controller
   Webots_Stream : Stream_Access; -- socket I/O interface
   Webots_Address : Sock_Addr_Type; -- stores the server address
   Webots_Buffer : Byte_buffer.Buffer;
   Webots_Mailbox : Mailbox.Mailbox (Size => 5);

   procedure Main;

end Webots_Thread;
