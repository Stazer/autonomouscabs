package body tcp_client is

   task body listen_task is
   begin
      accept Start( server_stream : Stream_Access; stream_buffer : out Stream_Element_Array; stream_offset : out Stream_Element_Count ) do -- Waiting for somebody to call the entry
         --TODO: implement check selector to monitor for incoming data before reading
         loop
            Read(server_stream.All, stream_buffer, stream_offset);
            exit when stream_offset = 0;
            for I in 1 .. stream_offset loop
               -- process incoming data --> so far just printing the incoming data as char
               -- next step would be to unmarsh + check action
               -- recv payload
               -- write payload to protected obj or type
               -- continue listening
               -- problem: how to constantly listen for incoming data and also send data at same time? --> user check_selector
               Ada.Text_IO.Put (Character'Val (stream_buffer (I)));
            end loop;
         end loop;
      end Start;
   end listen_task;

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

      -- write full command to stream
      for I in cmd'Range loop
         Character'Write(server_stream, Character'Val(cmd(I)));
      end loop;

   end send_bytes;

end tcp_client;
