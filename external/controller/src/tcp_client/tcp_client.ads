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

   function Connect(Client : in out Socket_Type; Address : in out Sock_Addr_Type) return Stream_Access;

   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access; --builds the connection and then return the socket

   --procedure Send_Bytes (server_stream : Stream_Access; outgoing_packet : Types.Communication_Packet); --sends a bytes over stream, established connection needed

   --function Receive_Bytes (server_stream : Stream_Access; bytes_wanted : in Types.Uint32; dynamic_buffer : in out Byte_Buffer.Buffer) return Types.uint32;

   procedure Read_Packet (server_stream : Stream_Access; dynamic_buffer : in out Byte_Buffer.Buffer; local_mailbox : in out Mailbox.Mailbox );

   --procedure read_payload (dynamic_buffer : in out Byte_Buffer.Buffer; payload_length : Types.Uint32; package_ID : Types.Uint8; local_mailbox : in out Mailbox.Mailbox);

end Tcp_Client;
