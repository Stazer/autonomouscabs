with Ada.Text_IO; use Ada.Text_IO;
with tcp_client; use tcp_client;
with backend_thread; use backend_thread;
with webots_thread; use webots_thread;
with types; use types;
with mailbox;
with pathfollowing;


procedure Main is

   task webots_thread;
   task backend_thread;

   task body webots_thread is
   begin
      webots_main;
   end webots_thread;

   task body backend_thread is
   begin
      backend_main;
   end backend_thread;

   current_packet : types.Communication_Packet;
   alternator : types.uint8 := 1;
   wheehvelocity : types.Octets_2 := (other => 0); --wheelvelocity
begin

   -- threads have started here

   while true loop

      -- clear out both mailboxes
      Backend_Mailbox.Clear;
      Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      mailbox.check_mailbox(Backend_Mailbox,Webots_Mailbox,current_packet,alternator);
      mailbox.update_alternator(alternator);
      --path following
      wheelvelocity := path_following(current_packet);
      -- do calculations with current packet
      Ada.Text_IO.Put_Line(Integer'Image(Integer(current_packet.package_ID)));

   end loop;

end Main;
