with Ada.Text_IO;
with ADA.Integer_Text_IO;
with tcp_client; use tcp_client;
with webots_thread; use webots_thread;
with Ada.Float_Text_IO;

package body Collision_Detection is

   function Main(Distance: Messages.Distance_Sensor_Array) return Messages.Velocity_Message is
      threshold: float64 := 700.0;
   begin
      -- Object in front of car
        Ada.Float_Text_IO.Put(FLoat(distance(0)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(1)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(2)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(3)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(4)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(5)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(6)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(7)),5,3,0);
            Ada.Float_Text_IO.Put(FLoat(distance(8)),5,3,0);
      Ada.Text_IO.Put_Line("");
      case car_state is
         when Forward =>
                        ada.Text_IO.Put_Line("forward ");
            threshold_d4 := 0.0;
            threshold_d3 := 0.0;

            threshold_d6 := 0.0;
            threshold_d5 := 0.0;

            left_obstacle := False;
            can_turn := False;
            if Distance(0) < 800.0 then
               if Distance(7) <= Distance(2) then
                  ls := 7.0;
                  rs := 1.0;
                  car_state := Right;
               else
                  ls := 1.0;
                  rs := 7.0;
                  car_state := Left;
               end if;
            end if;

            if Distance(1) < threshold or Distance(2) < threshold then
               ls := 1.0;
               rs := 5.0;
               car_state := Left;
            end if;


         when Left =>
                        ada.Text_IO.Put_Line("left");
            if Distance(2) < threshold and Distance(1) > threshold then
               ls := 4.0;
               rs := 4.0;
            elsif threshold_d3 = 0.0 then
               threshold_d3 := Distance(3);
            end if;
            if Distance(3) < 200.0 then
               car_state := Passing_Left;
               threshold_d4 := Distance(4);
            end if;


         when Passing_Left =>
            ada.Text_IO.Put_Line("passing left");

            if Distance(3) < threshold_d3 then
               ls := 7.0;
               rs := 1.0;
               --car_state := Forward;
            end if;
            if Distance(3) > 300.0  then
               left_obstacle := True;
            end if;

            if Distance(4) > threshold_d4 and left_obstacle = True then
                  ls := 0.0;
                  rs := 0.0;
                  car_state := Forward;
            end if;

         when Right =>
                        ada.Text_IO.Put_Line("right");
            if Distance(8) < threshold then
               ls := 4.0;
               rs := 4.0;
            elsif threshold_d3 = 0.0 then
               threshold_d6 := Distance(6);
            end if;
            if Distance(6) < 500.0 then
               car_state := Passing_Right;
               threshold_d5 := Distance(5);
            end if;


         when Passing_Right=>
                        ada.Text_IO.Put_Line("passing right");
            if Distance(6) < threshold_d3 then
               ls := 1.0;
               rs := 7.0;
               --car_state := Forward;
               if Distance(5) > threshold_d4 then
                  ls := 0.0;
                  rs := 0.0;
                  car_state := Forward;
               end if;
            end if;
--           when Forward =>
--              --ada.Text_IO.Put_Line("forward");
--              if Distance(0) < 1000.0 then
--                 if Distance(7) < Distance(2) then
--                    ls := 5.0;
--                    rs := 1.0;
--                    car_state := Right;
--                 else
--                    ls :=  1.0;
--                    rs :=  5.0;
--                    car_state := Left;
--                 end if;
--              end if;
--
--
--               --ada.Text_IO.Put_Line("forward");
--  --              if distance(1) < threshold or
--  --                 distance(2) < threshold then
--  --                 ls := -2.0;
--  --                 rs :=  2.0;
--  --                 car_state := Left;
--  --              elsif distance(8) < threshold or Distance(7) < threshold then
--  --                 ls := 2.0;
--  --                 rs := -2.0;
--  --                 car_state := Right;
--              end if;
--           when Left =>
--              --Ada.Text_IO.Put("Left");
--              if Distance(0) > 950.0 and Distance(1) > threshold and Distance(2) > threshold then
--                 ls := 3.75;
--                 rs := 4.0;
--              end if;
--              if Distance(1) < threshold or Distance(2) > threshold then
--                 ls := 1.0;
--                 rs := 7.0;
--              end if;
--
--              if Distance(4) = 1000.0 then
--                 ls := 2.0;
--                 rs := -2.0;
--              end if;
--
--
--           when Right =>
--              --ada.Text_IO.Put_Line("right");
--              if Distance(0) > 950.0 and Distance(8) > 900.0 and Distance(7) > threshold then
--                 ls := 3.0;
--                 rs := 2.0;
--                 if Distance(5) > 600.0 then
--                 ls := 0.0;
--                 rs := 0.0;
--                 car_state := Forward;
--                 end if;
--              end if;
--              if Distance(8) < threshold or Distance(7) < threshold then
--                 ls := 7.0;
--                 rs := 1.0;
--              end if;

      end case;



      ADA.Float_Text_IO.Put(Float(ls),5,3,0);
      ADA.Float_Text_IO.Put(Float(rs),5,3,0);
      ADA.Text_IO.Put_Line("");



      declare
         Message : Messages.Velocity_Message :=
           Messages.Velocity_Message_Create (ls, rs);
      begin
         return Message;
      end;
   end Main;
end Collision_Detection;

