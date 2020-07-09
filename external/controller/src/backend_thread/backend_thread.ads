with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;

with Tcp_Client;
with Byte_Buffer;
with Types;
with Mailbox;

package Backend_Thread is
   Socket: Socket_Type;
   Stream: Stream_Access;
   Address: Sock_Addr_Type;

   Backend_Mailbox: Mailbox(Size => 5);

   Buffer: Byte_buffer;
   Receive_Buffer_Size : Ada.Streams.Stream_Element_Count;
   Receive_Buffer_Data : Ada.Streams.Stream_Element_Array(1 .. 256);

   procedure Handle_Join_Challenge;
   procedure Handle_Join;

   procedure Main;

   type Handle_Buffer_Type is access procedure;
   Handle_Buffer : Handle_Buffer_Type;
end Backend_Thread;
