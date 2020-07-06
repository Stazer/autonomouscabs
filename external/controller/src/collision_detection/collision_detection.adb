with Ada.Text_IO;
with ADA.Integer_Text_IO;
with tcp_client; use tcp_client;
with webots_thread; use webots_thread;
with Ada.Float_Text_IO;

package body collision_detection is

   function detect(distance: Dtype) return Boolean is
      threshold: float64 := 900.0;
      ls, rs : types.float64;
      u64 : types.uint64;
      o8 : types.Octets_8;
      Webots_Cmd : types.Communication_Packet;
      moves_left: Integer;
   begin
      -- Object in front of car
      case car_state is
         when Forward =>
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
            if distance(0) < threshold then
               -- Slow down car
               Webots_Cmd.package_ID := 129;
               Webots_Cmd.payload_length := 5 + 16;
               Webots_Cmd.local_payload := new types.payload (0 .. 15);
               ls := -10.0;
               u64 := types.float64_to_uint64 (ls);
               o8 := types.uint64_to_octets (u64);
               for I in o8'Range loop
                  Webots_Cmd.local_payload (I) := o8 (I);
               end loop;
               rs := 10.0;
               u64 := types.float64_to_uint64 (rs);
               o8 := types.uint64_to_octets (u64);
               for I in o8'Range loop
                  Webots_Cmd.local_payload (I + 8) := o8 (I);
               end loop;
               --ADA.Integer_Text_IO.Put(Integer(Webots_Cmd.package_ID));
               send_bytes(Webots_Channel, Webots_Cmd);


               Ada.Text_IO.Put_Line("Slow down or stop car");
               -- Take on obstacle
               if distance(2) > threshold then
                  Ada.Text_IO.Put_Line("Take on right side");
                  moves_left := 0;
                  car_state := Left;
               elsif distance(7) > threshold then
                  Ada.Text_IO.Put_Line("Take on left side");
                  car_state := Right;
               else
                  Ada.Text_IO.Put_Line("There is no space");
               end if;
            end if;

         when Left =>
            moves_left := moves_left + 1;
            if distance(0) > threshold then
               Webots_Cmd.package_ID := 129;
               Webots_Cmd.payload_length := 5 + 16;
               Webots_Cmd.local_payload := new types.payload (0 .. 15);
               ls := 1.5;
               u64 := types.float64_to_uint64 (ls);
               o8 := types.uint64_to_octets (u64);
               for I in o8'Range loop
                  Webots_Cmd.local_payload (I) := o8 (I);
               end loop;
               rs := 1.5;
               u64 := types.float64_to_uint64 (rs);
               o8 := types.uint64_to_octets (u64);
               for I in o8'Range loop
                  Webots_Cmd.local_payload (I + 8) := o8 (I);
               end loop;
               --ADA.Integer_Text_IO.Put(Integer(Webots_Cmd.package_ID));
               send_bytes(Webots_Channel, Webots_Cmd);
--                 if distance(3) < 200.0 then
--                    car_state := Get_back_Left;
--                 end if;

            end if;

          when Get_back_Left=>
--
--              if distance(3) > 500.0 then
--                 Webots_Cmd.package_ID := 129;
--                 Webots_Cmd.payload_length := 5 + 16;
--                 Webots_Cmd.local_payload := new types.payload (0 .. 15);
--                 ls := 10.0;
--                 u64 := types.float64_to_uint64 (ls);
--                 o8 := types.uint64_to_octets (u64);
--                 for I in o8'Range loop
--                    Webots_Cmd.local_payload (I) := o8 (I);
--                 end loop;
--                 rs := - 10.0;
--                 u64 := types.float64_to_uint64 (rs);
--                 o8 := types.uint64_to_octets (u64);
--                 for I in o8'Range loop
--                    Webots_Cmd.local_payload (I + 8) := o8 (I);
--                 end loop;
           ADA.Integer_Text_IO.Put(Integer(Webots_Cmd.package_ID));
--                 send_bytes(Webots_Channel, Webots_Cmd);
--

         when Right =>
            Ada.Text_IO.Put("Left");
            if distance(2) > threshold then
               Ada.Text_IO.Put_Line("Get Back to path");
               car_state := Forward;
            end if;

      end case;
      if car_state = Left or car_state = Right then
         return True;
      else
         return False;
      end if;


   end;

end ;
