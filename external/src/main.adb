with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with tcp_client; use tcp_client;
with backend_thread; use backend_thread;
with webots_thread; use webots_thread;

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




begin

   -- start threads

   null;

end Main;
