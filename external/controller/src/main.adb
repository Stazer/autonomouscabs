with Ada.Text_IO; use Ada.Text_IO;
with tcp_client; use tcp_client;
with backend_thread; use backend_thread;
with webots_thread; use webots_thread;
with pathfollowing; use pathfollowing;
with types; use types;

with mailbox;


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
   send_packet : types.Communication_Packet;
begin

   -- threads have started here

   while true loop

      -- clear out both mailboxes
      Backend_Mailbox.Clear;
      Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      mailbox.check_mailbox(Backend_Mailbox,Webots_Mailbox,current_packet,alternator);
      mailbox.update_alternator(alternator);

      -- do calculations with current packet
      Ada.Text_IO.Put_Line(Integer'Image(Integer(current_packet.package_ID)));
      if(current_packet.package_ID = 67) then
         send_packet := pathfollowing.path_following(current_packet);
         send_bytes(Webots_Channel, send_packet);
      end if;

   end loop;

end Main;
