with Ada.Text_IO; use Ada.Text_IO;


with Tcp_Client;
with Backend_Thread;
with Webots_Thread;
with Types;use type Types.Float64;
use Types;
with Mailbox;
with Messages; use Messages;use type Messages.Velocity_Message;
with Byte_Buffer;
with Path_Following;
with Collision_Detection;
with Ada.Float_Text_IO;

procedure Main is

   task webots_task;
   task backend_task;

   task body webots_task is
   begin
      Webots_Thread.Main;
   end webots_task;

   task body backend_task is
   begin
      Backend_Thread.Main;
   end backend_task;

   Current_Mail : Mailbox.Mail;
   alternator : Types.Uint8 := 1;

   DS_Data : Messages.Distance_Sensor_Array := (others => 1000.0);

   V_Path : Messages.Velocity_Message;
   V_Collision : Messages.Velocity_Message;

   -- D : Messages.Distance_Sensor_   Out_Buffer : Byte_Buffer.Buffer;

   is_object_collision: Boolean := False;
begin

   -- threads have started here
   while true loop

      -- clear out both mailboxes
      Backend_Thread.Backend_Mailbox.Clear;
      Webots_Thread.Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      Mailbox.check_mailbox (Backend_Thread.Backend_Mailbox, Webots_Thread.Webots_Mailbox, Current_Mail, alternator);
      Mailbox.update_alternator (alternator);

      -- Put_Line (Current_Mail.Message.Id'Image);

      -- do calculations with current packet
--  <<<<<<< HEAD
--        --Ada.Text_IO.Put_Line(Integer'Image(Integer(current_packet.package_ID)));
--
--        send_packet_path_following.payload_length := 0;
--        -- Path following
--       if current_packet.package_ID = 67 then
--           send_packet_path_following := pathfollowing.path_following(current_packet);
--       end if;
--
--        -- Object collision
--        if current_packet.package_ID = 66 then
--           for J in uint32 range 0..8 loop
--              for I in uint32 range 0..7 loop
--                 dist(I) := current_packet.local_payload(I+J*8);
--              end loop;
--              distance_sensor_data(Integer(J)) := Types.uint64_to_float64(octets_to_uint64(dist));
--           end loop;
--           send_packet_collision_avoidance := detect(distance_sensor_data);
--        end if;
--        if send_packet_collision_avoidance.payload_length = 0 then
--           if send_packet_path_following.payload_length /= 0 then
--              send_bytes(Webots_Channel, send_packet_path_following);
--           end if;
--        else
--           send_bytes(Webots_Channel, send_packet_collision_avoidance);
--  =======
--        if Current_Mail.Message.Id = Messages.EXTERNAL_IMAGE_DATA then
--           V_Path := Path_Following.Main (Messages.ID_Message_Ptr (Current_Mail.Message), DS_Data);
--        elsif Current_Mail.Message.Id = Messages.EXTERNAL_DISTANCE_SENSOR then
--           DS_Data := Messages.DS_Message_Ptr (Current_Mail.Message).Payload;
--           V_Collision := Collision_Detection.Main(DS_Data);
--        end if;
--        declare Out_Buffer : Byte_Buffer.Buffer;
--        begin
--         --  if (V_Collision.Left_Speed = 0.0) and (V_Collision.Right_Speed = 0.0) then
--              Out_Buffer.Write_Message(V_Path);
--  --           else
--  --              Out_Buffer.Write_Message(V_Collision);
--  --           end if;
--           Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Channel, Out_Buffer);
--        end;


      -- do calculations with current packet

      if Current_Mail.Message.Id = Messages.EXTERNAL_DISTANCE_SENSOR then
         DS_Data := Messages.DS_Message_Ptr (Current_Mail.Message).Payload;
         V_Collision := Collision_Detection.Main(DS_Data);
--           ADA.Float_Text_IO.Put(Float(V_Collision.Left_Speed));
--           ADA.Text_IO.Put_Line("");
         if V_Collision.Left_Speed /= 0.0 and V_Collision.Right_Speed /= 0.0 then
                     ada.Text_IO.Put_Line("collision");
            is_object_collision := True;
            Declare Out_Buffer: Byte_Buffer.Buffer;
            begin
               Out_Buffer.Write_Message (V_Collision);
               Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Channel, Out_Buffer);
            end;
         else
            is_object_collision := False;
         end if;

      elsif Current_Mail.Message.Id = Messages.EXTERNAL_IMAGE_DATA and is_object_collision = False then
         ada.Text_IO.Put_Line("image data");
         V_Path := Path_Following.Main (Messages.ID_Message_Ptr (Current_Mail.Message), DS_Data);
         Declare Out_Buffer: Byte_Buffer.Buffer;
         begin
            Out_Buffer.Write_Message (V_Path);
            Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Channel, Out_Buffer);
         end;
      end if;


   end loop;

end Main;
