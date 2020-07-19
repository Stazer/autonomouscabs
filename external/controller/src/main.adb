with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

with Tcp_Client;
with Backend_Thread;
with Webots_Thread;
with Types; use type Types.Float64;
with Mailbox;
with Messages;
with Byte_Buffer;
with Memory;
with Collision_Detection;
with Path_Following;
with Ada.Command_Line;

procedure Main is
   task webots_task;
   task backend_task;

   task body webots_task is
   begin
      -- check if port string is usable
      if Ada.Command_Line.Argument_Count >= 2 then
         declare
            Webots_Port : String := Ada.Command_Line.Argument (1);
         begin
            if
              types.Is_Numeric(Webots_Port) = True
              and then Integer'Value(Webots_Port) > 1024
              and then Integer'Value(Webots_Port) <= 65535
            then
               Webots_Thread.Main(Integer'Value(Webots_Port));
            else
               declare
                  Mail : Mailbox.Mail;
               begin
                  Mail.Message := new Messages.Message;
                  Mail.Message.Id := Messages.ERROR_PORTS_NOT_SET;
                  Webots_Thread.Webots_Mailbox.Deposit (Mail);
               end;
            end if;
         end;
      else
         declare
            Mail : Mailbox.Mail;
         begin
            Mail.Message := new Messages.Message;
            Mail.Message.Id := Messages.ERROR_PORTS_NOT_SET;
            Webots_Thread.Webots_Mailbox.Deposit (Mail);
         end;
      end if;
   end webots_task;

   task body backend_task is
   begin
      -- check if port string is usable
      if Ada.Command_Line.Argument_Count >= 2 then
         declare
            Backend_Port : String := Ada.Command_Line.Argument (2);
         begin
            if
              types.Is_Numeric(Backend_Port) = True
              and then Integer'Value(Backend_Port) > 1024
              and then Integer'Value(Backend_Port) <= 65535
            then
               Backend_Thread.Main(Integer'Value(Backend_Port));
            else
               declare
                  Mail : Mailbox.Mail;
               begin
                  Mail.Message := new Messages.Message;
                  Mail.Message.Id := Messages.ERROR_PORTS_NOT_SET;
                  Backend_Thread.Backend_Mailbox.Deposit (Mail);
               end;
            end if;
         end;
      else
         declare
            Mail : Mailbox.Mail;
         begin
            Mail.Message := new Messages.Message;
            Mail.Message.Id := Messages.ERROR_PORTS_NOT_SET;
            Backend_Thread.Backend_Mailbox.Deposit (Mail);
         end;
      end if;

   end backend_task;

   Message : Messages.Message_Ptr;
   Alternator : Types.Uint8 := 1;

   DS_Data : Messages.Distance_Sensor_Array := (others => 1000.0);
   V_Path : Messages.Velocity_Message;
   V_Collision : Messages.Velocity_Message;
   Is_Object_Collision: Boolean := False;

   Route_Update : Messages.Route_Update_Message;
   Position_Update : Messages.Position_Update_Message;

begin
   -- threads have started here

   loop

      -- clear out both mailboxes
      Backend_Thread.Backend_Mailbox.Clear;
      Webots_Thread.Webots_Mailbox.Clear;

      -- alternate between checking webots and backend mailbox first, then update alternator
      Mailbox.Check_Mailbox (Backend_Thread.Backend_Mailbox, Webots_Thread.Webots_Mailbox, Message, Alternator);

      -- do calculations with current packet
      Put_Line (Message.Id'Image);

      declare
         Out_Buffer : Byte_Buffer.Buffer;
      begin
         case Message.Id is
            when Messages.EXTERNAL_JOIN_SUCCESS =>
               Put_Line ("Cab id: " & Messages.JS_Message_Ptr (Message).Cab_Id'Image);
               Memory.Handle_Join (Messages.JS_Message_Ptr (Message));
            when Messages.EXTERNAL_ADD_REQUEST =>
               Route_Update := Memory.Add_Request (Messages.AR_Message_Ptr (Message));

               Out_Buffer.Write_Message (Route_Update);
               Byte_Buffer.Buffer'Write (Backend_Thread.Backend_Stream, Out_Buffer);
            when Messages.EXTERNAL_DISTANCE_SENSOR =>
               DS_Data := Messages.DS_Message_Ptr (Message).Payload;
               V_Collision := Collision_Detection.Main (DS_Data);

               -- Sending 0 as velocity if object collision is over
               if V_Collision.Left_Speed /= 0.0 and V_Collision.Right_Speed /= 0.0 then
                  Is_Object_Collision := True;

                  Out_Buffer.Write_Message (V_Collision);
                  Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Stream, Out_Buffer);
               else
                  Is_Object_Collision := False;
               end if;
            when Messages.EXTERNAL_IMAGE_DATA =>
               if Is_Object_Collision = False then
                  V_Path := Path_Following.Main (Messages.ID_Message_Ptr (Message), DS_Data);

                  Out_Buffer.Write_Message (V_Path);
                  Byte_Buffer.Buffer'Write (Webots_Thread.Webots_Stream, Out_Buffer);
               end if;
            when Messages.ERROR_BACKEND_DISCONNECTED =>
               Put_Line ("Backend disconnected, returning to depot after last request... ");
               Memory.Handle_Disconnect;
            when Messages.ERROR_WEBOTS_DISCONNECTED =>
               Put_Line ("Webots disconnected, exiting... ");
               exit;
            when Messages.ERROR_PORTS_NOT_SET =>
               Put_Line ("Port numbers not provided or incorrect, exiting... ");
               exit;
            when others => null;
         end case;
      end;
   end loop;

   Webots_Thread.Webots_Stop := True;
   Backend_Thread.Backend_Stop := True;
end Main;
