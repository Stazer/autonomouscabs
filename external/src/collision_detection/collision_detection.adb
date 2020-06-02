with Ada.Text_IO;
with ADA.Integer_Text_IO;

package body collision_detection is
     
   procedure collision_detection_main is
   distance: Dtype;
   begin
      car_state := Forward;
      while True loop
         -- Get distances
         Ada.Text_IO.Put_Line("Enter distances:");
         for I in 0..Dtype'Length-1 loop
            Ada.Integer_Text_IO.Get(distance(I));
         end loop;
         detect(distance);
      end loop;
         
   end ;
   
   procedure detect(distance: dtype) is  
   threshold: Integer := 10;                
   begin
      -- Object in front of car
      case car_state is
         when Forward =>
            if distance(1) < threshold then
               -- Slow down car
               Ada.Text_IO.Put_Line("Slow down or stop car");
           
               -- Take on obstacle
               if distance(2) > threshold then
                  Ada.Text_IO.Put_Line("Take on right side");
                  car_state := Right;
               elsif distance(0) > threshold then
                  Ada.Text_IO.Put_Line("Take on left side");
                  car_state := Left;
               else
                  Ada.Text_IO.Put_Line("There is no space");
               end if;
            end if;
            
         when Right =>
            Ada.Text_IO.Put_Line("Right");
            if distance(0) > threshold then
               Ada.Text_IO.Put_Line("Get Back to path");
               car_state := Forward;
            end if;
            
         when Left =>
            if distance(2) > threshold then
               Ada.Text_IO.Put_Line("Get Back to path");
               car_state := Forward;
            end if;
               
      end case;
        
        
   end;
    

end ;
