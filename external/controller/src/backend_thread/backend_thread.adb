package body Backend_Thread is
   procedure Main is
      New_Byte : types.uint8;
   begin
      Handle_Buffer := Handle_Join_Challenge'Access;

      Address.Addr := Inet_Addr("10.0.0.2");
      Address.Port := 9875;
      Stream := Connect(Socket, Address);
      Ada.Text_IO.Put_Line("Connection to backend (10.0.0.2:9875) established");

      Handle_Buffer.all;

      loop
         Ada.Streams.Read(Stream.all, Receive_Buffer_Data, Receive_Buffer_Size);

         exit when Receive_Buffer_Size = 0;

         for I in 1 .. Receive_Buffer_Size loop
            types.uint8'Read(Receive_Buffer_Data(I), New_Byte);
         end loop;

         Handle_Buffer.all;
      end loop;
   end Main;

   procedure Handle_Join_Challenge
   is
      Command : Types.Communication_Packet;
   begin
      Command.package_ID := 193;
      send_bytes(Stream, Command);

      Handle_Buffer := Handle_Join'Access;
   end Handle_Join_Challenge;

   procedure Handle_Join is
   begin
      Ada.Text_IO.Put_Line("Hello");
   end Handle_Join;
end Backend_Thread;
