with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with tcp_client; use tcp_client;
with Ada.Text_IO;
with types;
with byte_buffer;

package webots_thread is

   -- Webots thread variables
   Webots_Client  : Socket_Type; -- stores the socket for the webots controller
   Webots_Channel : Stream_Access; -- socket I/O interface
   Webots_Address : Sock_Addr_Type; -- stores the server address
   Webots_Cmd : Command; -- command to send over socket
   Webots_Vector_Buffer : byte_buffer.Buffer;
   Webots_Mailbox : types.Mailbox;

   procedure webots_main;

end webots_thread;
