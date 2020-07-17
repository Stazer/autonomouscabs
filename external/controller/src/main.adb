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
with ada.Integer_Text_IO;

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

   Is_Object_Collision: Boolean := False;
begin

   -- threads have started here
   while true loop

      -- clear out both mailboxes
      Backend_Thread.Backend_Mailbox.Clear;
      Webots_Thread.Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      Mailbox.check_mailbox (Backend_Thread.Backend_Mailbox, Webots_Thread.Webots_Mailbox, Current_Mail, alternator);
      Mailbox.update_alternator (alternator);


      if Current_Mail.Message.Id = Messages.EXTERNAL_DISTANCE_SENSOR then
         DS_Data := Messages.DS_Message_Ptr (Current_Mail.Message).Payload;
         V_Collision := Collision_Detection.Main(DS_Data);
         -- Sending 0 as velocity if object collision is over
         if V_Collision.Left_Speed /= 0.0 and V_Collision.Right_Speed /= 0.0 then
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
