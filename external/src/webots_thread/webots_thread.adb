package body webots_thread is

   name  : Unbounded_String := To_Unbounded_String("webots");

   procedure webots_main is

      webots_elem : Communication_Packet;

   begin

      Backend_Queue.Enqueue(New_Item => (Priority => 13,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
      Backend_Queue.Enqueue(New_Item => (Priority => 14,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
      Backend_Queue.Enqueue(New_Item => (Priority => 15,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
      Backend_Queue.Enqueue(New_Item => (Priority => 16,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));

      Webots_Channel := build_connection (Webots_Client, 2000, Webots_Address);

      Webots_Cmd :=(1,1,1,1,1,1,1,1);

      send_bytes(Webots_Channel, Webots_Cmd);

      --test thread safety of priority queue
      for I in 0 .. 7
      loop
         Backend_Queue.Dequeue(webots_elem);
         Ada.Text_IO.Put_Line (To_String (name) & " => " & Natural'Image (webots_elem.Priority));
         delay 0.25;
      end loop;

      Ada.Text_IO.Put_Line("webots done.");

   end webots_main;


end webots_thread;
