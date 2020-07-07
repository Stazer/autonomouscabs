with Ada.Text_IO; use Ada.Text_IO;
with tcp_client; use tcp_client;
with backend_thread; use backend_thread;
with webots_thread; use webots_thread;
with pathfollowing; use pathfollowing;
with collision_detection; use collision_detection;
with types; use types;

with mailbox;
with ADA.Integer_Text_IO;



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
   send_packet_path_following : types.Communication_Packet;
   send_packet_collision_avoidance : types.Communication_Packet;
   dist: types.Octets_8;
   distance_sensor_data: collision_detection.Dtype;
   is_object_collision: Boolean := False;
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
      --Ada.Text_IO.Put_Line(Integer'Image(Integer(current_packet.package_ID)));
      -- Path following
     if(current_packet.package_ID = 67) then
         send_packet_path_following := pathfollowing.path_following(current_packet);
      end if;

      -- Object collision
      if(current_packet.package_ID = 66) then
         for J in uint32 range 0..8 loop
            for I in uint32 range 0..7 loop
               dist(I) := current_packet.local_payload(I+J*8);
            end loop;
            distance_sensor_data(Integer(J)) := Types.uint64_to_float64(octets_to_uint64(dist));
         end loop;
         send_packet_collision_avoidance := detect(distance_sensor_data);
      end if;
      if send_packet_collision_avoidance.payload_length = 0 then
         send_bytes(Webots_Channel, send_packet_path_following);
      else
         send_bytes(Webots_Channel, send_packet_collision_avoidance);
      end if;

   end loop;

end Main;
