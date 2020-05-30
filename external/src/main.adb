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

   -- start threads
   Backend_Queue.Enqueue(New_Item => (Priority => 1,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
   Backend_Queue.Enqueue(New_Item => (Priority => 2,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
   Backend_Queue.Enqueue(New_Item => (Priority => 3,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
   Backend_Queue.Enqueue(New_Item => (Priority => 4,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
   Backend_Queue.Enqueue(New_Item => (Priority => 5,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
   Backend_Queue.Enqueue(New_Item => (Priority => 6,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
   Backend_Queue.Enqueue(New_Item => (Priority => 7,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));

end Main;
