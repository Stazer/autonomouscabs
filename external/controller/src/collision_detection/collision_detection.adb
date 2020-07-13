with Ada.Text_IO;
with ADA.Integer_Text_IO;
with tcp_client; use tcp_client;
with webots_thread; use webots_thread;
with Ada.Float_Text_IO;

package body Collision_Detection is

   function Main(Distance: Messages.Distance_Sensor_Array) return Messages.Velocity_Message is
      threshold: float64 := 800.0;
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
--        case car_state is
--           when Forward =>
--              if distance(0) < threshold or distance(1) < threshold or
--                 distance(2) < threshold then
--                 ls := -10.0;
--                 rs := 10.0;
--                 car_state := Left;
--              end if;
--              if distance(7) < threshold or distance(8) < threshold then
--                 ls := 10.0;
--                 rs := -10.0;
--                 car_state := Right;
--              end if;
--           when Left =>
--              Ada.Text_IO.Put("Left");
--              if Distance(4) > threshold and Distance(0) > threshold then
--                 ls := 0.0;
--                 rs := 0.0;
--              else
--
--              end if;
--           when Right =>
--              if Distance(5) > threshold and Distance(0) > threshold then
--                 ls := 0.0;
--                 rs := 0.0;
--              end if;
--
--        end case;

      if distance(0) < threshold then
         if Distance(2)<threshold or Distance(1)<threshold then
            ada.Text_IO.Put_Line("take left");
            ls := ls - 0.01;
            rs := rs + 0.01;
         end if;

         if Distance(7)<threshold or Distance(8)<threshold then
            ada.Text_IO.Put_Line("take right");
            ls := ls + 0.01;
            rs := ls - 0.01;
         end if;

         if ls = 0.0 and rs = 0.0 then
            ls := ls + 2.0;
            rs := rs - 2.0;
         end if;


      end if;

      ADA.Float_Text_IO.Put(Float(ls));
      ADA.Float_Text_IO.Put(Float(ls));
      ADA.Text_IO.Put_Line("");



      declare
         Message : Messages.Velocity_Message :=
           Messages.Velocity_Message_Create (ls, rs);
      begin
         return Message;
      end;
   end Main;
end Collision_Detection;

