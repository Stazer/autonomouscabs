package body Path_Following is
   colour : Integer := 0;
   r : Integer := 0;
   g : Integer := 0;
   b : Integer := 0;

   bottomPoint : Integer := 0;
   --topPoint : Integer := 0;
   --leftPoint : Integer := 0;
   --rightPoint : Integer:= 0;
   bottomPoint1 : Integer := 0;
   white_Line : Integer := 0;
   --topPoint1 : Integer := 0;
   --leftPoint1 : Integer := 0;
   --rightPoint1 : Integer:= 0;
   --steeringAngle : float64 := 0.0;

   red : Colour_Matrix := (others => (others => 0));
   blue : Colour_Matrix := (others => (others => 0));
   green : Colour_Matrix := (others => (others => 0));
   grey : Colour_Matrix := (others => (others => 0));
   binaImage : Colour_Matrix := (others => (others => 0));

   wheehlvelocity : Velocity_Array := (others => 0.0);
   --axleTrack : float64 := 1.1;
   basicVelocity : Float64 :=4.0 ;
   --ratio : float64 := 8.0;
   V_turn : Float64 := 0.0;
   --offset : Integer := 32;
   --Kp : float64 := 0.08;
   --Ki : float64 :=0.08;
   --Kd : float64 := 0.08;
   --Error : float64 := 0.0;
   --lastError : float64 := 0.0;
   --integral : float64 := 0.0;
   --derivative : float64 := 0.0;

   function Binarize (grey : in Colour_Matrix) return Colour_Matrix is
   begin

       for I in Row_Index loop
         for J in Column_Index loop
            if grey (I)(J) > 150 then
               binaImage (I)(J) := 255;
            else
               binaImage (I)(j) := 0;
            end if;
            --Put(uint8'Image (binaImage (I) (J)));

         end loop;
         --Put_Line("");
      end loop;
      return binaImage;

   end Binarize;

   function Find_Line (binarizedImage : in Colour_Matrix) return Integer is
   begin
      for J in Column_Index loop
         if binaImage(Row_Index(height-5))(J) = 255 then
            bottomPoint := Integer(J);
         end if;
         --
      end loop;

      for J in reverse Column_Index loop
         if binaImage(Row_Index(height-5))(J) = 255 then
            bottomPoint1 := Integer(J);
         end if;
      end loop;

      bottomPoint := (bottomPoint + bottomPoint1) / 2;
 --     Put_Line(Integer'Image(bottomPoint));
      return bottomPoint;

   end Find_Line;


   function Wheel_Velocity (whiteLine : in Integer; d_sensor : in Messages.Distance_Sensor_Array) return Velocity_Array is
      Velocity : Velocity_Array := (others => 0.0);
   begin


      if whiteLine >= 56 then
         V_turn := 1.0;
      elsif whiteLine >= 49  and whiteLine < 56 then
         V_turn := 0.75;
      elsif whiteLine >= 42 and whiteLine < 49 then
         V_turn := 0.5;
      elsif whiteLine >= 35  and whiteLine < 42 then
         V_turn := 0.25;
      elsif whiteLine >= 28 and whiteLine < 35 then
         V_turn := 0.0;
      elsif whiteLine >= 21 and whiteLine < 28 then
         V_turn := -0.25;
      elsif whiteLine >= 14 and whiteLine < 21 then
         V_turn := -0.5;
      elsif whiteLine >= 7 and whiteLine < 14 then
         V_turn := -0.75;
      elsif whiteLine >= 0 and whiteLine < 7 then
         V_turn := -1.0;
      elsif whiteLine = 0 then
         if d_sensor (6) < 500.0 then
            V_turn := 1.0;
         end if;
         if d_sensor (3) < 500.0 then
            V_turn := -1.0;
         end if;
      end if;

--        Put_Line (d_sensor(3)'Image & ", " & d_sensor(6)'Image);
--        Put_Line (V_turn'Image);
      --turn right

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
  --    Put_Line (Velocity (0)'Image & ", " & Velocity (1)'Image);

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
