with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_line; use Ada.Command_Line;

with Tcp_Client;
with Backend_Thread;use Backend_Thread;
with Webots_Thread;
with Types;
with Mailbox;
with Messages; use Messages;
with Byte_Buffer;
with Path_Following;
with collision_detection;

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

   V : Messages.Velocity_Message;
   -- D : Messages.Distance_Sensor_Message;
   Out_Buffer : Byte_Buffer.Buffer;

   is_object_collision: Boolean := False;

   use type Webots_Thread.Channel_Type;
   use type Webots_Thread.Thread_Number;
begin

   -- threads have started here
   while true loop


      -- clear out both mailboxes
      Backend_Thread.Backend_Mailbox.Clear;
      Webots_Thread.Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      Mailbox.check_mailbox (Backend_Thread.Backend_Mailbox, Webots_Thread.Webots_Mailbox, Current_Mail, alternator);
      Mailbox.update_alternator (alternator);

      if Current_Mail.Message.Id = Messages.EXTERNAL_IMAGE_DATA then
         V := Path_Following.Main (Messages.ID_Message_Ptr (Current_Mail.Message), DS_Data);
         Out_Buffer.Write_Message (V);
         Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Channel(0), Out_Buffer);
      elsif Current_Mail.Message.Id = Messages.EXTERNAL_DISTANCE_SENSOR then
         DS_Data := Messages.DS_Message_Ptr (Current_Mail.Message).Payload;
      end if;


   end loop;

end Main;
