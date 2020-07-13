with Ada.Text_IO;
with ADA.Integer_Text_IO;
with tcp_client; use tcp_client;
with webots_thread; use webots_thread;
with Ada.Float_Text_IO;

package body Collision_Detection is

   function Main(Distance: Messages.Distance_Sensor_Array) return Messages.Velocity_Message is
      threshold: float64 := 500.0;
   begin
      -- Object in front of car
--              Ada.Float_Text_IO.Put(FLoat(distance(0)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(1)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(2)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(3)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(4)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(5)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(6)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(7)),5,3,0);
--              Ada.Float_Text_IO.Put(FLoat(distance(8)),5,3,0);
--        Ada.Text_IO.Put_Line("");
      case car_state is
         when Forward =>
            --ada.Text_IO.Put_Line("forward");
            if distance(0) < 700.0 or distance(1) < threshold or
               distance(2) < threshold then
               ls := -10.0;
               rs := 10.0;
               car_state := Left;
            elsif distance(8) < threshold or Distance(7) < threshold then
               ls := 10.0;
               rs := -10.0;
               car_state := Right;
            end if;
         when Left =>
            --Ada.Text_IO.Put("Left");
            if Distance(0) > 950.0 and Distance(1) > threshold then
               ls := 4.0;
               rs := 4.0;
            end if;
            if Distance(4) = 1000.0 then
               ls := 0.0;
               rs := 0.0;
            end if;

         when Right =>
            --ada.Text_IO.Put_Line("right");
            if Distance(0) > 950.0 and Distance(8) > threshold then
               ls := 4.0;
               rs := 4.0;
            end if;

      end case;


--
--        ADA.Float_Text_IO.Put(Float(ls));
--        ADA.Float_Text_IO.Put(Float(ls));
--        ADA.Text_IO.Put_Line("");



      declare
         Message : Messages.Velocity_Message :=
           Messages.Velocity_Message_Create (ls, rs);
      begin
         return Message;
      end;
   end Main;
end Collision_Detection;

