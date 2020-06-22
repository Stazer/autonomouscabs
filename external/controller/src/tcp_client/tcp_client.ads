with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;
with byte_buffer;
with types;
with Ada.Real_Time; use Ada.Real_Time;
with mailbox; use mailbox;

package tcp_client is

   --defines the length of protocol header (package_length + package_ID)
   protocol_package_length : types.uint32 := 4;
   protocol_ID_length : types.uint32 := 1;
   protocol_join_ID : types.uint8 := 6;

   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access; --builds the connection and then return the socket

   procedure send_bytes( server_stream : Stream_Access; outgoing_packet : types.Communication_Packet); --sends a bytes over stream, established connection needed

   function recv_bytes( server_stream : Stream_Access; bytes_wanted : in types.uint32; dynamic_buffer : in out byte_buffer.Buffer ) return types.uint32;

   procedure listen( server_stream : Stream_Access; dynamic_buffer : in out byte_buffer.Buffer; local_mailbox : in out mailbox.Mailbox );

   procedure read_payload(dynamic_buffer : in out byte_buffer.Buffer; payload_length : types.uint32; package_ID : types.uint8; local_mailbox : in out mailbox.Mailbox);

end tcp_client;
