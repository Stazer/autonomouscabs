with Ada.Text_IO; use Ada.Text_IO;
with tcp_client; use tcp_client;
with backend_thread; use backend_thread;
with webots_thread; use webots_thread;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Containers.Synchronized_Queue_Interfaces;
with Ada.Containers.Unbounded_Priority_Queues;
with communication_queues; use communication_queues;


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

   -- threads have started here
   null;

end Main;
