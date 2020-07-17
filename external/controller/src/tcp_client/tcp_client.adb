package body Tcp_Client is

   function Connect (Client : in out Socket_Type; Address : in out Sock_Addr_Type) return Stream_Access is
   begin
      GNAT.Sockets.Initialize;
      Create_Socket (Client);
      Connect_Socket (Client, Address);

      return Stream (Client);
   end Connect;

   procedure Read_Packet (Stream : Stream_Access;
                          Buffer : in out Byte_Buffer.Buffer;
                          Local_Mailbox : in out Mailbox.Mailbox) is
   begin
      --  read message
      Byte_Buffer.Buffer'Read (Stream, Buffer);

      declare Message : Messages.Message_Ptr;
      begin
         Buffer.Read_Message (Message);
         Local_Mailbox.Clear;
         Local_Mailbox.Deposit (Message);
      end;
   end Read_Packet;

end Tcp_Client;
