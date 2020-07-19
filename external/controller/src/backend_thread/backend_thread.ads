with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;

with Tcp_Client;
with Byte_Buffer;
with Types;
with Mailbox;
with Messages;

package Backend_Thread is
   Backend_Socket : Socket_Type;
   Backend_Stream : Stream_Access;
   Backend_Address : Sock_Addr_Type;

   Backend_Mailbox : Mailbox.Mailbox (Size => 5);

   Backend_Buffer : Byte_buffer.Buffer;

   Backend_Stop : Boolean := False;

   procedure Handle_Join_Challenge;
   procedure Handle_Join;

   procedure Main (Backend_Port : Integer);
   procedure Join;

   type Handle_Buffer_Type is access procedure;
   Handle_Buffer : Handle_Buffer_Type;
end Backend_Thread;
