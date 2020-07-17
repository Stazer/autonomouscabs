with Ada.Text_IO; use Ada.Text_IO;

package body Backend_Thread is
   procedure Main is
   begin
      Handle_Buffer := Handle_Join_Challenge'Access;

      Backend_Address.Addr := Inet_Addr ("127.0.0.1");
      Backend_Address.Port := 9876;

      Backend_Stream := Tcp_Client.Connect (Backend_Socket, Backend_Address);
      Put_Line ("Connection to backend (127.0.0.1:9875) established");

      Join;

      loop
         Tcp_Client.Read_Packet (Backend_Stream, Backend_Buffer, Backend_Mailbox);
      end loop;
   end Main;

   procedure Join
   is
      Join : Messages.Join_Challenge_Message := Messages.Join_Challenge_Message_Create;
      Out_Buffer : Byte_Buffer.Buffer;
   begin
      Out_Buffer.Write_Message (Join);
      Byte_Buffer.Buffer'Write (Backend_Stream, Out_Buffer);

      Handle_Buffer := Handle_Join'Access;
   end Join;

   procedure Handle_Join_Challenge
   is
      Join : Messages.Join_Challenge_Message := Messages.Join_Challenge_Message_Create;
      Out_Buffer : Byte_Buffer.Buffer;
   begin
      Out_Buffer.Write_Message (Join);
      Byte_Buffer.Buffer'Write (Backend_Stream, Out_Buffer);

      Handle_Buffer := Handle_Join'Access;
   end Handle_Join_Challenge;

   procedure Handle_Join is
   begin
      Ada.Text_IO.Put_Line("Hello");
   end Handle_Join;
end Backend_Thread;
