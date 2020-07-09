with Ada.Text_IO; use Ada.Text_IO;

with Tcp_Client;
with Backend_Thread;
with Webots_Thread;
with Types;
with Mailbox;


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

   current_packet : Types.Communication_Packet;
   alternator : Types.Uint8 := 1;

begin

   -- threads have started here

   while true loop

      -- clear out both mailboxes
      Backend_Thread.Backend_Mailbox.Clear;
      Webots_Thread.Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      Mailbox.check_mailbox (Backend_Thread.Backend_Mailbox, Webots_Thread.Webots_Mailbox, current_packet, alternator);
      Mailbox.update_alternator (alternator);

      -- do calculations with current packet
      Put_Line (current_packet.Package_ID'Image);

   end loop;

end Main;
