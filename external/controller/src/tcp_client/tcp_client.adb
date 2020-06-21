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


   procedure send_bytes( server_stream : Stream_Access; outgoing_packet : types.Communication_Packet) is

      uint8_payload_length : types.Octets_4;

   begin

      -- send payload_length
      uint8_payload_length := uint32_to_octets(hton32(outgoing_packet.payload_length));
      for I in uint8_payload_length'Range loop
         types.uint8'Write(server_stream, uint8_payload_length(I));
      end loop;

      -- send package_ID
      types.uint8'Write(server_stream, outgoing_packet.package_ID);

      --  write full payload to stream
      if outgoing_packet.payload_length > 0 then
         for I in outgoing_packet.local_payload'Range loop
            types.uint8'Write(server_stream, outgoing_packet.local_payload(I));
         end loop;
      end if;

   end send_bytes;


   function recv_bytes(server_stream : Stream_Access; bytes_wanted : in types.uint32; dynamic_buffer : in out byte_buffer.Buffer ) return types.uint32 is

      bytes_received : types.uint32 := 0;
      new_byte : types.uint8;

   begin

      while bytes_received < bytes_wanted loop
         types.uint8'Read(server_stream, new_byte);
         dynamic_buffer.write_uint8(new_byte);
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

   procedure read_payload(dynamic_buffer : in out byte_buffer.Buffer; payload_length : types.uint32; package_ID : types.uint8; mailbox : in out types.Mailbox) is

   begin

      declare new_packet : Communication_Packet;
      begin
         new_packet.package_ID := package_ID;
         new_packet.payload_length := payload_length;
         new_packet.local_payload := new payload(0..(payload_length - 1));
         new_packet.TTL := Ada.Real_Time.Clock;

         for I in new_packet.local_payload'Range loop
            dynamic_buffer.read_uint8(new_packet.local_payload(I));
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

   procedure check_mailbox ( first : in out types.Mailbox; second : in out types.Mailbox; new_packet : out types.Communication_Packet; alternator: types.uint8 ) is
   begin
      if alternator = 1 then
         select
            first.Collect(new_packet);
         else
            delay(0.05);
            check_mailbox(second,first,new_packet,alternator);
         end select;
      else
         select
            second.Collect(new_packet);
         else
            delay(0.05);
            check_mailbox(second,first,new_packet,alternator);
         end select;
      end if;
   end check_mailbox;

   procedure update_alternator (alternator: in out types.uint8) is
   begin
      if alternator = 1 then
         alternator := 2;
      else
         alternator := 1;
      end if;
   end update_alternator;

   function check_time_to_live(Time_In_Question: in Ada.Real_Time.Time) return Boolean is
   begin
      if (Ada.Real_Time.Clock - Time_In_Question) >= Ada.Real_Time.Milliseconds(6000) then
         return True;
      else
         return False;
      end if;
   end check_time_to_live;

end tcp_client;
