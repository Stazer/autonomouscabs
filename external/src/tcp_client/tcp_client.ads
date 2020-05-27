with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;

package tcp_client is

   type Byte is mod 256;
   type Command is array (1..8) of Byte;

   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access; --builds the connection and then return the socket
   procedure send_bytes( server_stream : Stream_Access; cmd : Command); --sends a bytes over stream, established connection needed

   task listen_task is -- starts new thread that listens for incoming data
      entry Start( server_stream : Stream_Access; stream_buffer : out Stream_Element_Array; stream_offset : out Stream_Element_Count );
   end listen_task;

end tcp_client;
