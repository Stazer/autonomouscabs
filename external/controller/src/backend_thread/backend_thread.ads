with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with tcp_client; use tcp_client;
with Ada.Text_IO;
with byte_buffer;
with types;


package backend_thread is

   -- Backend thread variables
   Backend_Client: Socket_Type; -- stores the socket for the backend
   Backend_Channel : Stream_Access; -- socket I/O interface
   Backend_Address : Sock_Addr_Type; -- stores the server address
   Backend_Cmd : types.Communication_Packet; -- command to send over socket
   Backend_Vector_Buffer : byte_buffer.Buffer;
   Backend_Mailbox : types.Mailbox(Size => 5); -- queue that holds at max 5 items

   procedure backend_main;

end backend_thread;
