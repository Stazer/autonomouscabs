with Ada.Integer_Text_IO;

package body Path_Following is
   colour : Integer := 0;
   r : Integer := 0;
   g : Integer := 0;
   b : Integer := 0;

   Bottom_Point : Integer := 0;
   Bottom_Point1 : Integer := 0;
   white_Line : Integer := 0;

   red : Colour_Matrix := (others => (others => 0));
   blue : Colour_Matrix := (others => (others => 0));
   green : Colour_Matrix := (others => (others => 0));
   grey : Colour_Matrix := (others => (others => 0));
   binaImage : Colour_Matrix := (others => (others => 0));
   --Command_value : Command;

   wheehlvelocity : Velocity_Array := (others => 0.0);
   basicVelocity : Float64 :=4.0 ;
   V_turn : Float64 := 0.0;


   function Binarize (grey : in Colour_Matrix) return Colour_Matrix is
   begin

      for I in Row_Index loop
         for J in Column_Index loop
            if grey (I)(J) > 160 then
               binaImage (I)(J) := 255;
            else
               binaImage (I)(j) := 0;
            end if;
         end loop;
      end loop;
      return binaImage;

   end Binarize;

   function Find_Line (binarizedImage : in Colour_Matrix) return Integer is

      --pick_up_location_reached :  Boolean := False;
      Action : Memory.Action := Memory.Next_Action;

   begin
      for J in Column_Index loop
         if binaImage (Row_Index (height-1))(J) = 255 then
            Bottom_Point := Integer (J);
         end if;
      end loop;

      for J in reverse Column_Index loop
         if binaImage (Row_Index (height-1))(J) = 255 then
            Bottom_Point1 := Integer(J);
         end if;
      end loop;

      -- check for fork here
      if Bottom_Point /= 0 or Bottom_Point1 /= 0 then
         Check_For_Fork (Action, Bottom_Point, Bottom_Point1);
         Changed_Position := True;
      end if;

      Bottom_Point := (Bottom_Point + Bottom_Point1) / 2;
      return Bottom_Point;
   end Find_Line;

   procedure Check_For_Fork (Action : in Memory.Action; Bottom_Point : in out Integer; Bottom_Point1 : in out Integer ) is

      old_value : Integer;

   begin
      -- current assumption: bottomPoint: right, bottomPoint1: left
      -- careful: bottomPoint might be right point and bottomPoint1 might be the left point

      -- save old value
      if Action = Memory.RIGHT then
         old_value := Bottom_Point1;
         -- check right side
         for J in reverse Integer range Bottom_Point1 .. Bottom_Point loop
            -- if black pixel found, update bottomPoint
            if binaImage (Row_Index (height-5))(Column_Index(J)) /= 255 then
               Bottom_Point1 := Integer (J) + 1;
            end if;

            -- if the value changed then exit
            exit when old_value /= Bottom_Point1;
         end loop;
      elsif Action = Memory.STRAIGHT then
         old_value := Bottom_Point;
         -- check left side
         for J in Integer range Bottom_Point1 .. Bottom_Point loop
            -- if black pixel found, update bottomPoint1
            if binaImage(Row_Index(height-5))(Column_Index(J)) /= 255 then
               Bottom_Point := Integer (J) - 1;
            end if;
            -- if the value changed then exit
            exit when old_value /= Bottom_Point;
         end loop;
      end if;

   end Check_For_Fork;


   function Wheel_Velocity (whiteLine : in Integer; d_sensor : in Messages.Distance_Sensor_Array) return Velocity_Array is
      Velocity : Velocity_Array := (others => 0.0);
      steering_zones_size : Long_Float := Long_Float(width)/13.0;
      type steering_zones is array(1..13) of Long_Float;
      steering_zones_array : steering_zones;

   begin

      for I in steering_zones_array'Range loop
         steering_zones_array(I) := Long_Float(I)*steering_zones_size;
      end loop;

      -- Ada.Integer_Text_IO.put(whiteLine);
      if whiteLine = 0 then
         if d_sensor (6) < 500.0 then
            V_turn := 1.0;
         end if;
         if d_sensor (3) < 500.0 then
            V_turn := -1.0;
         end if;
      else
         if Long_Float(whiteLine) < steering_zones_array(1) then
            V_turn := -6.0;
         elsif Long_Float(whiteLine) < steering_zones_array(2) then
            V_turn := -6.0;
         elsif Long_Float(whiteLine) < steering_zones_array(3) then
            V_turn := -5.0;
         elsif Long_Float(whiteLine) < steering_zones_array(4) then
            V_turn := -5.0;
         elsif Long_Float(whiteLine) < steering_zones_array(5) then
            V_turn := -5.0;
         elsif Long_Float(whiteLine) < steering_zones_array(6) then
            V_turn := -1.0;
         elsif Long_Float(whiteLine) < steering_zones_array(7) then-- straight
            V_turn := 0.0;
         elsif Long_Float(whiteLine) < steering_zones_array(8) then
            V_turn := 1.0;
         elsif Long_Float(whiteLine) < steering_zones_array(9) then
            V_turn := 5.0;
         elsif Long_Float(whiteLine) < steering_zones_array(10) then
            V_turn := 5.0;
         elsif Long_Float(whiteLine) < steering_zones_array(11) then
            V_turn := 5.0;
         elsif Long_Float(whiteLine) < steering_zones_array(12) then
            V_turn := 6.0;
         else
            V_turn := 6.0;
         end if;
      end if;

      if V_turn > 0.0 then
         Velocity (0) := basicVelocity + V_turn;
         Velocity (1) := basicVelocity - V_turn;
         --turn left
      elsif V_turn < 0.0 then
         Velocity (0) := basicVelocity + V_turn;
         Velocity (1) := basicVelocity - V_turn;
      else
         Velocity (0) := basicVelocity;
         Velocity (1) := basicVelocity;
      end if;
      return Velocity;

   end Wheel_Velocity;

   function Main (Data_Input : in Messages.ID_Message_Ptr; d_sensor : in Messages.Distance_Sensor_Array) return Messages.Velocity_Message is
      Index : Image_Index := 0;
      Velocity : Velocity_Array;
   begin
      --grayscale Image
      for I in Row_Index loop
         for J in Column_Index loop
            Index := Image_Index(4 * (Integer(I) * width + Integer(J)));
            blue (I) (J) := Data_Input.Payload (Types.Uint32(Index));
            green (I) (J) := Data_Input.Payload (Types.Uint32(Index + 1));
            red (I) (J) := Data_Input.Payload (Types.Uint32(Index + 2));
            colour := Integer(blue (I) (J)) * 114/1000 + Integer(green (I) (J)) * 587/1000 + Integer(red (I) (J)) * 299/1000;
            grey (I) (J) := uint8(colour);
         end loop;
      end loop;

      --Binarized
      binaImage := Binarize (grey);
      --findLine
      white_Line := Find_Line (binaImage);
      --wheelvelocity calculate
      Velocity := Wheel_Velocity (white_Line, d_sensor);

      declare
         Message : Messages.Velocity_Message :=
           Messages.Velocity_Message_Create (Velocity (0), Velocity (1));
      begin
         return Message;
      end;
   end Main;

end Path_Following;
