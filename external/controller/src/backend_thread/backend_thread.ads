with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;

with Tcp_Client;
with Byte_Buffer;
with Types;
with Mailbox;


package Backend_Thread is

   -- Backend thread variables
   Backend_Client: Socket_Type; -- stores the socket for the backend
   Backend_Channel : Stream_Access; -- socket I/O interface
   Backend_Address : Sock_Addr_Type; -- stores the server address
   Backend_Cmd : Types.Communication_Packet; -- command to send over socket
   Backend_Vector_Buffer : Byte_Buffer.Buffer;
   Backend_Mailbox : Mailbox.Mailbox (Size => 5); -- queue that holds at max 5 items

   procedure Main;

end Backend_Thread;
