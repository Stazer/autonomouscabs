with Ada.Text_IO; use Ada.Text_IO;
with tcp_client; use tcp_client;
with backend_thread; use backend_thread;
with webots_thread; use webots_thread;
with types; use types;


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

begin

   -- threads have started here

   while true loop

      -- clear out both mailboxes
      Backend_Mailbox.Clear;
      Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      check_mailbox(Backend_Mailbox,Webots_Mailbox,current_packet,alternator);
      update_alternator(alternator);

      -- do calculations with current packet

   end loop;

end Main;
