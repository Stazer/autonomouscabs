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
