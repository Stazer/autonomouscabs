with Ada.Containers.Synchronized_Queue_Interfaces;
with Ada.Containers.Unbounded_Priority_Queues;
with tcp_client; use tcp_client;
with Ada.Real_Time; use Ada.Real_Time;

package communication_queues is

   type Communication_Packet is record
      Identifier : Byte;
      Header : Command;
      Priority : Natural;
      Packet_Payload : Payload;
      TTL : Time;
   end record;

   function Get_Priority (Element : Communication_Packet) return Natural;

   function Before (Left, Right : Natural) return Boolean;

   package Communication_Packet_Queue_Interfaces is
     new Ada.Containers.Synchronized_Queue_Interfaces
       (Element_Type => Communication_Packet);

   package Communication_Packet_Queues is
     new Ada.Containers.Unbounded_Priority_Queues
        (Queue_Interfaces => Communication_Packet_Queue_Interfaces,
         Queue_Priority => Natural);

   Backend_Queue : Communication_Packet_Queues.Queue;
   Webots_Queue : Communication_Packet_Queues.Queue;
   Steering_Queue : Communication_Packet_Queues.Queue;
   Velocity_Queue : Communication_Packet_Queues.Queue;
   Object_Detection_Queue : Communication_Packet_Queues.Queue;
   Object_Avoidance_Queue : Communication_Packet_Queues.Queue;


end communication_queues;
