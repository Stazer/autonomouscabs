package body backend_thread is

   name  : Unbounded_String := To_Unbounded_String("backend");

   procedure backend_main is

      backend_elem : Communication_Packet;

   begin

      Backend_Queue.Enqueue(New_Item => (Priority => 8,Identifier => 2,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
      Backend_Queue.Enqueue(New_Item => (Priority => 9,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
      Backend_Queue.Enqueue(New_Item => (Priority => 10,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
      Backend_Queue.Enqueue(New_Item => (Priority => 11,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));
      Backend_Queue.Enqueue(New_Item => (Priority => 12,Identifier => 1,Header => (1,1,1,1,1,1,1,1),Packet_Payload => (1,1,1,1,1,1,1,1),TTL => Clock));

      Backend_Channel := build_connection ( Backend_Client, 2000, Backend_Address);

      -- test send function
      Backend_Cmd :=(1,1,1,1,1,1,1,1);

      send_bytes(Backend_Channel, Backend_Cmd);

      --test thread safety of priority queue
      for I in 0 .. 7
      loop
         Backend_Queue.Dequeue(backend_elem);
         Ada.Text_IO.Put_Line (To_String (name) & " => " & Natural'Image (backend_elem.Priority));
         delay 0.5;
      end loop;

      Ada.Text_IO.Put_Line("backend done.");

      -- listen not finished
      -- listen_task.Start(Backend_Channel, Backend_Header, Backend_Offset);

   end backend_main;


end backend_thread;
