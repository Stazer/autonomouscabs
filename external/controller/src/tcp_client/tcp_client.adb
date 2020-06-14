with types; use types;

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


   function recv_bytes(server_stream : Stream_Access; bytes_wanted : in types.uint32; dynamic_buffer : in out byte_buffer.Buffer ) return types.uint32 is

      bytes_received : types.uint32 := 0;
      new_byte : types.uint8;

   begin

      while bytes_received < bytes_wanted loop
         types.uint8'Read(server_stream, new_byte);
         byte_buffer.write_uint8(dynamic_buffer,new_byte);
         bytes_received := bytes_received + 1;
      end loop;

      return bytes_received;

   end recv_bytes;



   procedure listen( server_stream : Stream_Access; dynamic_buffer : in out byte_buffer.Buffer; mailbox : in out types.Mailbox ) is --  not finished

      bytes_received : types.uint32 := 0;
      conv_package_ID : types.uint8;
      conv_package_value_length : types.uint32;

   begin

      --  read package_length
      bytes_received := recv_bytes(server_stream, protocol_package_length, dynamic_buffer);
      byte_buffer.read_uint32(dynamic_buffer, conv_package_value_length);

      --  read package_ID
      bytes_received := recv_bytes(server_stream, protocol_ID_length, dynamic_buffer);
      byte_buffer.read_uint8(dynamic_buffer, conv_package_ID);

      --  read payload
      bytes_received := recv_bytes(server_stream, conv_package_value_length, dynamic_buffer);
      read_payload(dynamic_buffer, conv_package_value_length, conv_package_ID,mailbox);

   end listen;

   function Net_To_Host_32 (X : types.Octets_4) return types.uint32 is
   begin
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

   procedure read_payload(dynamic_buffer : in out byte_buffer.Buffer; payload_length : types.uint32; package_ID : types.uint8; mailbox : in out types.Mailbox) is

      uint64_count : uint32 := payload_length/8;

   begin

      declare new_packet : Communication_Packet;
      begin
         new_packet.package_ID := package_ID;
         new_packet.payload_length := payload_length;
         new_packet.local_payload := new payload(0..(uint64_count - 1));

         for I in new_packet.local_payload'Range loop
            byte_buffer.read_uint64(dynamic_buffer, new_packet.local_payload(I));
         end loop;

         select
            mailbox.Deposit(new_packet);
         else
            delay(0.05);
            mailbox.Clear;
            mailbox.Deposit(new_packet);
         end select;

      end;

   end read_payload;

   procedure check_mailbox ( first : in out types.Mailbox; second : in out types.Mailbox; new_packet : out types.Communication_Packet ) is
   begin
      select
         first.Collect(new_packet);
      else
         delay(0.05);
         check_mailbox(second,first,new_packet);
      end select;
   end check_mailbox;

end tcp_client;
