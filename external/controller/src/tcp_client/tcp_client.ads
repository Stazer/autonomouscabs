with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Unchecked_Conversion;
with Interfaces;
with System; use type System.Bit_Order;

with types;

package tcp_client is

   type Command is array (1..8) of types.uint8;
   type Payload is array (1..8) of types.uint64;

   function Net_To_Host_32 (X : types.Octets_4) return types.uint32;
   pragma Inline (Net_To_Host_32);

   function Net_To_Host_64 (X : types.Octets_8) return types.uint64;
   pragma Inline (Net_To_Host_64);


   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access; --builds the connection and then return the socket
   procedure send_bytes( server_stream : Stream_Access; cmd : Command); --sends a bytes over stream, established connection needed

   -- not finished
   task listen_task is -- listens for incoming data
      entry Start( server_stream : Stream_Access; stream_buffer : out Stream_Element_Array; stream_offset : in out Stream_Element_Count );
   end listen_task;

end tcp_client;
