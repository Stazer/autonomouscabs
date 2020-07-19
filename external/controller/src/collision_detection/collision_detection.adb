with Ada.Text_IO;
with ADA.Integer_Text_IO;
with tcp_client; use tcp_client;
with webots_thread; use webots_thread;
with Ada.Float_Text_IO;

package body Collision_Detection is

   function Main(Distance: Messages.Distance_Sensor_Array) return Messages.Velocity_Message is
      Threshold: float64 := 700.0;
   begin

      case Car_State is
         when Forward =>

            -- Oobstacle in front of car
            if Distance(0) < 800.0 then
               -- Checking if there is space on left side
               if Distance(7) = 1000.0 and Distance(8) = 1000.0 then
                  Ls := -4.0;
                  Rs := 2.0;
                  Car_State := Left;
                  -- Checking if there is space on right side
               elsif Distance(1) = 1000.0 and Distance(2) = 1000.0 then
                  Ls := 2.0;
                  Rs := -4.0;
                  Car_State := Right;
               end if;
            end if;

            -- Obstacle on slightly right side
            if Distance(1) < Threshold or Distance(2) < Threshold then
               Ls := -3.0;
               Rs := 2.5;
               Car_State := Left;
            end if;
            -- Obstacle on slightly left side
            if Distance(7) < Threshold or Distance(8) < Threshold then
               ls := 4.0;
               rs := -3.0;
               Car_State := Right;
            end if;

         when Left =>
            if Distance(2) < Threshold and Distance(1) > Threshold then
               ls := 3.0;
               rs := 4.0;
            end if;
            -- Mostly taken on object, returning to path
            if Distance(3) < 200.0 then
               Passing_Obstacle := False;
               Car_State := Passing_Left;
            end if;

         when Passing_Left =>
            if Distance(3) < 200.0 then
               ls := 3.0;
               rs := 2.5;
            end if;

            if Distance(4) < 300.0 then
               ls := 3.0;
               rs := 2.0;
               Passing_Obstacle := True;
            end if;

            if Distance(4) < 600.0 and Passing_Obstacle = True then
               ls := 3.0;
               rs := 1.0;
               Obstacle_Passed := True;
            end if;

            if Distance(3) > 300.0 and Distance(4) > 300.0 and Obstacle_Passed = True then
               ls := 0.0;
               rs := 0.0;
               Obstacle_Passed := False;
               Passing_Obstacle := False;
               Car_State := Forward;
            end if;

         when Right =>
            if Distance(7) < Threshold and Distance(8) > Threshold then
               ls := 4.0;
               rs := 3.0;
            end if;

            -- Mostly taken on object, returning to line
            if Distance(6) < 200.0 then
               Passing_Obstacle := False;
               Car_State := Passing_Right;
            end if;

         when Passing_Right=>
            if Distance(6) < 200.0 then
               Ls := 2.5;
               Rs := 3.0;
            end if;

            if Distance(6) < 300.0 then
               ls := 2.0;
               rs := 3.0;
               Passing_Obstacle := True;
            end if;

            if Distance(5) < 600.0 and Passing_Obstacle = True then
               ls := 1.0;
               rs := 3.0;
               Obstacle_Passed := True;
            end if;

            if Distance(6) > 300.0 and Distance(5) > 300.0 and Obstacle_Passed = True then
               ls := 0.0;
               rs := 0.0;
               Obstacle_Passed := False;
               Passing_Obstacle := False;
               Car_State := Forward;
            end if;

      end case;

      declare
         Message : Messages.Velocity_Message :=
           Messages.Velocity_Message_Create (Ls, Rs);
      begin
         return Message;
      end;
   end Main;
end Collision_Detection;

