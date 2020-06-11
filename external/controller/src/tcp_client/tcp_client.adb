with types;

package body tcp_client is


   function build_connection ( client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access is


   begin


      GNAT.Sockets.Initialize;  -- initialize a new packet
      Create_Socket (client); -- create a socket + store it as variable Client

      -- Set the server address:
      address.Addr := Inet_Addr("127.0.0.1"); -- localhost
      address.Port := port;

      Connect_Socket (client, Address); -- bind the address to the socket + connect

      return Stream(client);

   end build_connection;



   procedure send_bytes( server_stream : Stream_Access; cmd : Command) is

   begin

      --  write full command to stream
      for I in cmd'Range loop
         Character'Write(server_stream, Character'Val(cmd(I)));
      end loop;

   end send_bytes;


   task body listen_task is --  not finished

      raw_package_ID : types.Octets_4;
      conv_package_ID : types.uint32;
      raw_package_Value_Length : types.Octets_4;
      conv_package_Value_Length : types.uint32;
   begin
      accept Start( server_stream : Stream_Access; stream_buffer : out Stream_Element_Array; stream_offset : in out Stream_Element_Count ) do -- Waiting for somebody to call the entry
         --  should ada maybe be listening on a port??
         --  TODO:implement check selector to monitor for incoming data before reading
         --  1. implement check selector to monitor for incoming data before reading
         --  2. need more out Stream_Element_array for: package_value_length and actual values
         --  3. read package id and package length
         --  4. read payload


         --  read package_ID
         Read(server_stream.All, stream_buffer, stream_offset);
         for I in 0 .. stream_offset loop
            raw_package_ID(Integer(I)) := types.uint8(stream_buffer (I));
            Ada.Text_IO.Put_Line(Integer'Image(Integer(raw_package_ID(Integer(I)))));
         end loop;
         conv_package_ID := Net_To_Host_32(raw_package_ID);
         Ada.Text_IO.Put_Line(Integer'Image(Integer(conv_package_ID)));



         --  read package_length
         Read(server_stream.All, stream_buffer, stream_offset);
         for I in 0 .. stream_offset loop
            raw_package_Value_Length(Integer(I)) := types.uint8(stream_buffer (I));
         end loop;
         conv_package_Value_Length := Net_To_Host_32(raw_package_Value_Length);
         Ada.Text_IO.Put_Line (Integer'Image(Integer(conv_package_Value_Length)));


         --  what would be a safe way to recv these?
         --  extra stream buffer of max picture size needed
         stream_offset := Stream_Element_Offset(conv_package_Value_Length);
         Read(server_stream.All, stream_buffer, stream_offset);

      end Start;
   end listen_task;

   function Net_To_Host_32 (X : types.Octets_4) return types.uint32 is
   begin
      --wrong way around?
      if System.Default_Bit_Order = System.High_Order_First then
         return types.octets_to_uint32 ((X (3), X (2), X (1), X (0)));
      else
         return types.octets_to_uint32 ((X (0), X (1), X (2), X (3)));
      end if;
   end Net_To_Host_32;

   function Net_To_Host_64 (X : types.Octets_8) return types.uint64 is
   begin
      if System.Default_Bit_Order = System.High_Order_First then
         return types.octets_to_uint64 (X);
      else
         return types.octets_to_uint64 ((X (7), X (6), X (5), X (4), X (3),
                                          X (2), X (1), X (0)));
      end if;
   end Net_To_Host_64;

end tcp_client;
