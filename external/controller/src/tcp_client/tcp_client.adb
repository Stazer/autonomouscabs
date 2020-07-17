package body Tcp_Client is

   function Connect(Client : in out Socket_Type; Address : in out Sock_Addr_Type) return Stream_Access is
   begin
      GNAT.Sockets.Initialize;
      Create_Socket(Client);
      Connect_Socket(Client, Address);

      return Stream(Client);
   end Connect;

   function build_connection (client : in out Socket_Type; port : Port_Type; address : in out Sock_Addr_Type) return Stream_Access is
   begin
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

      declare Message : Messages.Message_Ptr;
      begin
         dynamic_buffer.Read_Message (Message);
         local_mailbox.Clear;
         local_mailbox.Deposit (Message);
      end;
   end Read_Packet;

end Tcp_Client;
