with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;

package body tcp_client is

   --protected obj
--     protected Channel is
--        function Get return Stream_Access;
--     private
--        Channel_Local : Stream_Access;
--     end Channel;
--
--     protected body Channel is
--        procedure Set (inc_channel : Stream_Access) is
--        begin
--           Channel_Local := inc_channel;
--        end Set;
--
--        function Get return Stream_Access is
--        begin
--           return Channel_Local;
--        end Get;
--     end Channel;
--     -- probably not necessary

   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access is


   begin
      GNAT.Sockets.Initialize;  -- initialize a new packet
      Create_Socket (client); -- create a socket + store it as variable Client

      -- Set the server address:
      address.Addr := Inet_Addr("127.0.0.1"); -- localhost
      address.Port := port;

      Connect_Socket (client, Address); -- bind the address to the socket + connect

      --Channel := Stream (client); -- create a stream to access the socket

      return Stream(client);

   end build_connection;



   function send_join( server_stream : Stream_Access; cmd : Command; stream_buffer : in out Stream_Element_Array; stream_offset : in out Stream_Element_Count ) return Boolean is

   begin


      -- write full command to stream
      for I in cmd'Range loop
         Character'Write(server_stream, Character'Val(cmd(I)));
      end loop;

      --wait for the join_ack by the server
      Read(server_stream.All, stream_buffer, stream_offset);

      return True;

      --TODO: check the received buffer to see if the join was successful

      --print_int := Integer(Header(Header'First));

      --Ada.Text_IO.Put(Integer'Image(print_int));


   end send_join;

end tcp_client;
