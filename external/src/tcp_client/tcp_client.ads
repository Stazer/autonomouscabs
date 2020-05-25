with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;

package tcp_client is

   type Byte is range 0 .. 255;
   type Command is array (1..8) of Byte;

   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access; --builds the connection and then return the socket
   function send_join( server_stream : Stream_Access; cmd : Command; stream_buffer : in out Stream_Element_Array; stream_offset : in out Stream_Element_Count ) return Boolean; --sends a join, established connection needed
   -- procedure recv_incoming ( server_stream : Stream_Access );
   -- procedure kill_connection ( server_fd : Socket_Type );

end tcp_client;
