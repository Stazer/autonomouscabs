package body Tcp_Client is

   function Connect (Client : in out Socket_Type; Address : in out Sock_Addr_Type) return Stream_Access is
      Connected : Boolean;
   begin
      GNAT.Sockets.Initialize;
      Create_Socket (Client);
      loop
         Connected := True;
         begin
            Connect_Socket (Client, Address);
         exception
            when E : Socket_Error =>
               Connected := False;
         end;
         exit when Connected = True;
      end loop;

      return Stream (Client);
   end Connect;

   procedure Read_Packet (Stream : Stream_Access;
                          Buffer : in out Byte_Buffer.Buffer;
                          Local_Mailbox : in out Mailbox.Mailbox) is
   begin
      --  read message
      begin
         Byte_Buffer.Buffer'Read (Stream, Buffer);
      exception
         when E : Byte_Buffer.Connection_Closed =>
            raise;
      end;

      declare Mail : Mailbox.Mail;
      begin
         Buffer.Read_Message (Mail.Message);
         Mail.TTL := Ada.Real_Time.Clock;
         Local_Mailbox.Clear;
         Local_Mailbox.Deposit (Mail);
      end;
   end Read_Packet;

end Tcp_Client;
