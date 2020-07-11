with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

with Byte_Buffer;
with Types; use Types;
with Mailbox; use Mailbox;
with Messages;

package Tcp_Client is

   --defines the length of protocol header (package_length + package_ID)
   protocol_package_length : Types.Uint32 := 4;
   protocol_ID_length : Types.Uint32 := 1;
   protocol_join_ID : Types.Uint8 := 6;

   function Connect (client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access; --builds the connection and then returns stream access

   procedure Read_Packet (server_stream : Stream_Access; dynamic_buffer : in out Byte_Buffer.Buffer; local_mailbox : in out Mailbox.Mailbox );

end Tcp_Client;
