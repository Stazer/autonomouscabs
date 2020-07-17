with Ada.Text_IO; use Ada.Text_IO;

with Tcp_Client;
with Backend_Thread;
with Webots_Thread;
with Types; use type Types.Float64; use Types;
with Mailbox;
with Messages; use Messages; use type Messages.Velocity_Message;
with Byte_Buffer;
with Graph; use Graph;
with Collision_Detection;
with Path_Following;

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

   Message : Messages.Message_Ptr;
   Alternator : Types.Uint8 := 1;

   DS_Data : Messages.Distance_Sensor_Array := (others => 1000.0);
   V_Path : Messages.Velocity_Message;
   V_Collision : Messages.Velocity_Message;
   Is_Object_Collision: Boolean := False;

   Out_Buffer : Byte_Buffer.Buffer;

   R : Graph.Route;
   A : Graph.Route;

   S, D : Graph.VID;
begin
   Graph.Create_Graph;

   -- threads have started here

   while true loop

      -- clear out both mailboxes
      Backend_Thread.Backend_Mailbox.Clear;
      Webots_Thread.Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      Mailbox.Check_Mailbox (Backend_Thread.Backend_Mailbox, Webots_Thread.Webots_Mailbox, Message, Alternator);
      Mailbox.Update_Alternator (Alternator);

      -- do calculations with current packet
      Put_Line (Message.Id'Image);

      if Message.Id = Messages.EXTERNAL_JOIN_SUCCESS then
         Put_Line (Messages.JS_Message_Ptr (Message).Cab_Id'Image);

         declare
            O : Byte_Buffer.Buffer;
            K : Messages.Position_Update_Message := Messages.Position_Update_Message_Create (2);
         begin
            O.Write_Message (K);
            Byte_Buffer.Buffer'Write (Backend_Thread.Backend_Stream, O);
         end;
      elsif Message.Id = Messages.EXTERNAL_ADD_REQUEST then
         S := Graph.VID'Enum_Val (Messages.AR_Message_Ptr (Message).Src);
         D := Graph.VID'Enum_Val (Messages.AR_Message_Ptr (Message).Dst);
         Put (S'Image & " ");
         Put (D'Image);
         New_Line;

         Graph.Add (R, A, S, D);

         declare
            O : Byte_Buffer.Buffer;
            P : Types.Payload_Ptr := new Types.Payload (0 .. Types.Uint32 (R.Length) - 1);
            K : Messages.Route_Update_Message;
            Index : Types.Uint32 := 0;
         begin
            for I of R loop
               P (Index) := Types.Uint8 (Graph.VID'Enum_Rep(I));
               Index := Index + 1;
            end loop;
            K := Messages.Route_Update_Message_Create (P);
            O.Write_Message (K);
            Byte_Buffer.Buffer'Write (Backend_Thread.Backend_Stream, O);
         end;
      elsif Message.Id = Messages.EXTERNAL_DISTANCE_SENSOR then
         DS_Data := Messages.DS_Message_Ptr (Message).Payload;
         V_Collision := Collision_Detection.Main(DS_Data);
         -- Sending 0 as velocity if object collision is over
         if V_Collision.Left_Speed /= 0.0 and V_Collision.Right_Speed /= 0.0 then
            is_object_collision := True;
            Declare Out_Buffer: Byte_Buffer.Buffer;
            begin
               Out_Buffer.Write_Message (V_Collision);
               Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Stream, Out_Buffer);
            end;
         else
            is_object_collision := False;
         end if;
      elsif Message.Id = Messages.EXTERNAL_IMAGE_DATA and is_object_collision = False then
         ada.Text_IO.Put_Line("image data");
         V_Path := Path_Following.Main (Messages.ID_Message_Ptr (Message), DS_Data);
         Declare Out_Buffer: Byte_Buffer.Buffer;
         begin
            Out_Buffer.Write_Message (V_Path);
            Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Stream, Out_Buffer);
         end;
      end if;
   end loop;

   Graph.Destroy_Graph;

end Main;
