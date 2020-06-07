with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Unchecked_Conversion;
with Interfaces;
with System; use type System.Bit_Order;


package tcp_client is

   type uint8 is new Interfaces.Unsigned_8;
   type uint16 is new Interfaces.Unsigned_16;
   type uint32 is new Interfaces.Unsigned_32;
   type uint64 is new Interfaces.Unsigned_64;
   type Octets_4 is array (0 .. 3) of uint8;
   type Octets_8 is array (0 .. 7) of uint8;
   type Command is array (1..8) of uint8;
   type Payload is array (1..8) of uint64;

   function To_Unsigned_32 (X : Octets_4) return uint32;
   pragma Inline (To_Unsigned_32);

   function To_Unsigned_64 (X : Octets_8) return uint64;
   pragma Inline (To_Unsigned_64);


   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access; --builds the connection and then return the socket
   procedure send_bytes( server_stream : Stream_Access; cmd : Command); --sends a bytes over stream, established connection needed

   -- not finished
   task listen_task is -- listens for incoming data
      entry Start( server_stream : Stream_Access; stream_buffer : out Stream_Element_Array; stream_offset : in out Stream_Element_Count );
   end listen_task;

end tcp_client;
