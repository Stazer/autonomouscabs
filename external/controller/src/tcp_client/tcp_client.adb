package body Tcp_Client is


   function Connect (client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access is
   begin

      GNAT.Sockets.Initialize;  -- initialize a new packet

      Create_Socket (client); -- create a socket + store it as variable Client

      -- Set the server address:
      address.Addr := Inet_Addr("127.0.0.1"); -- localhost

      address.Port := port;

      Connect_Socket (client, Address); -- bind the address to the socket + connect

      return Stream(client);

   end Connect;


   procedure Send_Bytes (server_stream : Stream_Access; outgoing_packet : Types.Communication_Packet) is

      uint8_payload_length : Types.Octets_4;

   begin

      -- send payload_length
      uint8_payload_length := Types.Uint32_To_Octets(outgoing_packet.payload_length);
      for I in uint8_payload_length'Range loop
         Types.Uint8'Write(server_stream, uint8_payload_length(I));
      end loop;

      -- send package_ID
      Types.Uint8'Write(server_stream, outgoing_packet.package_ID);

      --  write full payload to stream
      if outgoing_packet.payload_length > 0 then
         for I in outgoing_packet.local_payload'Range loop
            Types.Uint8'Write(server_stream, outgoing_packet.local_payload(I));
         end loop;
      end if;

   end Send_Bytes;


   function Receive_Bytes (server_stream : Stream_Access; bytes_wanted : in Types.Uint32; dynamic_buffer : in out Byte_Buffer.Buffer) return Types.Uint32 is

      bytes_received : Types.Uint32 := 0;
      new_byte : Types.Uint8;

   begin

      while bytes_received < bytes_wanted loop
         Types.Uint8'Read(server_stream, new_byte);
         dynamic_buffer.Write_Uint8(new_byte);
         bytes_received := bytes_received + 1;
      end loop;

      return bytes_received;

   end Receive_Bytes;

   procedure Read_Packet (server_stream : Stream_Access; dynamic_buffer : in out Byte_Buffer.Buffer; local_mailbox : in out Mailbox.Mailbox) is --  not finished

      bytes_received : Types.Uint32 := 0;
      conv_package_ID : Types.Uint8;
      conv_package_value_length : Types.Uint32;

   begin

      --  read package_length
      bytes_received := Receive_Bytes(server_stream, protocol_package_length, dynamic_buffer);
      dynamic_buffer.Read_Uint32(conv_package_value_length);

      --  read package_ID
      bytes_received := Receive_Bytes(server_stream, protocol_ID_length, dynamic_buffer);
      dynamic_buffer.Read_Uint8(conv_package_ID);

      conv_package_value_length := conv_package_value_length - 5;

      --  read payload
      bytes_received := Receive_Bytes(server_stream, conv_package_value_length, dynamic_buffer);
      read_payload(dynamic_buffer, conv_package_value_length, conv_package_ID, local_mailbox);

   end Read_Packet;

   procedure read_payload(dynamic_buffer : in out Byte_Buffer.Buffer; payload_length : Types.Uint32; package_ID : Types.Uint8; local_mailbox : in out Mailbox.Mailbox) is

   begin

      declare new_packet : Communication_Packet;
      begin
         new_packet.Package_ID := package_ID;
         new_packet.Payload_length := payload_length;
         new_packet.Local_Payload := new Payload(0..(payload_length - 1));
         new_packet.TTL := Ada.Real_Time.Clock;

         --  for I in new_packet.Local_Payload'Range loop
         --     dynamic_buffer.read_uint8(new_packet.Local_Payload(I));
         --  end loop;

         dynamic_buffer.Read_Payload (new_packet.Local_Payload);

         local_mailbox.Clear;
         local_mailbox.Deposit(new_packet);

      end;

   end read_payload;

end Tcp_Client;
