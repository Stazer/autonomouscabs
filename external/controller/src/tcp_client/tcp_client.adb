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

   procedure Read_Packet (server_stream : Stream_Access;
                          dynamic_buffer : in out Byte_Buffer.Buffer;
                          local_mailbox : in out Mailbox.Mailbox) is
   begin
      --  read message
      Byte_Buffer.Buffer'Read (server_stream, dynamic_buffer);

      declare
         M : Mailbox.Mail;
      begin
         dynamic_buffer.Read_Message (M.Message);
         M.TTL := Ada.Real_Time.Clock;
         local_mailbox.Clear;
         local_mailbox.Deposit (M);
      end;
   end Read_Packet;

end Tcp_Client;
