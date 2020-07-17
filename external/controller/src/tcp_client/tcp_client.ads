with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

with Byte_Buffer;
with Types; use Types;
with Mailbox;
with Messages;

package Tcp_Client is

   --defines the length of protocol header (package_length + package_ID)
   protocol_package_length : Types.Uint32 := 4;
   protocol_ID_length : Types.Uint32 := 1;
   protocol_join_ID : Types.Uint8 := 6;

   function Connect(Client : in out Socket_Type; Address : in out Sock_Addr_Type) return Stream_Access;

   procedure Read_Packet (Stream : Stream_Access; Buffer : in out Byte_Buffer.Buffer; Local_Mailbox : in out Mailbox.Mailbox );

end Tcp_Client;
