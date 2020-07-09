with Ada.Text_IO; use Ada.Text_IO;

with Tcp_Client;
with Backend_Thread;
with Webots_Thread;
with Types;
with Mailbox;
with Messages;
with Byte_Buffer;


procedure Main is

   task webots_task;
   task backend_task;

   task body webots_task is
   begin
      Webots_Thread.Main;
   end webots_task;

   task body backend_task is
   begin
      Backend_Thread.Main;
   end backend_task;

   Current_Mail : Mailbox.Mail;
   alternator : Types.Uint8 := 1;

   V : Messages.Velocity_Message;
   Out_Buffer : Byte_Buffer.Buffer;

begin

   -- threads have started here

   while true loop

      -- clear out both mailboxes
      Backend_Thread.Backend_Mailbox.Clear;
      Webots_Thread.Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      Mailbox.check_mailbox (Backend_Thread.Backend_Mailbox, Webots_Thread.Webots_Mailbox, Current_Mail, alternator);
      Mailbox.update_alternator (alternator);

      -- do calculations with current packet
      Put_Line (Current_Mail.Message.Id'Image);

      V := Messages.Velocity_Message_Create (5.1, 2.4);

      Out_Buffer.Write_Message (V);
      Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Channel, Out_Buffer);
      Out_Buffer.Delete_Bytes (V.Size);


   end loop;

end Main;
