package body pathfollowing is
   colour : Integer := 0;
   r : Integer := 0;
   g : Integer := 0;
   b : Integer := 0;

   bottomPoint : Integer := 0;
   topPoint : Integer := 0;
   leftPoint : Integer := 0;
   rightPoint : Integer:= 0;
   bottomPoint1 : Integer := 0;
   topPoint1 : Integer := 0;
   leftPoint1 : Integer := 0;
   rightPoint1 : Integer:= 0;
   --steeringAngle : float64 := 0.0;

   red : Colour_Matrix := (others => (others => 0));
   blue : Colour_Matrix := (others => (others => 0));
   green : Colour_Matrix := (others => (others => 0));
   grey : Colour_Matrix := (others => (others => 0));
   binaImage : Colour_Matrix := (others => (others => 0));

   wheehlvelocity : Wheehl_velocity := (others => 0.0);
   --axleTrack : float64 := 1.1;
   basicVelocity : float64 :=4.0 ;
   --ratio : float64 := 8.0;
   V_turn : float64 := 0.0;
   --offset : Integer := 32;
   --Kp : float64 := 0.08;
   --Ki : float64 :=0.08;
   --Kd : float64 := 0.08;
   --Error : float64 := 0.0;
   --lastError : float64 := 0.0;
   --integral : float64 := 0.0;
   --derivative : float64 := 0.0;
   function binarize (grey : in Colour_Matrix) return Colour_Matrix is

   begin

       for I in Row_Index loop
         for J in Column_Index loop
            if grey (I)(J) > 100 then
               binaImage (I)(J) := 255;
            else
               binaImage (I)(j) := 0;
            end if;
            --Put(uint8'Image (binaImage (I) (J)));

         end loop;
         --Put_Line("");
      end loop;
      return binaImage;

   end binarize;

   function wheel_Velocity (binarizedImage : in Colour_Matrix; d_sensor : in Dtype) return Wheehl_velocity is
      wheehlvelocity : Wheehl_velocity := (others => 0.0);

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

      Put_Line(Integer'Image(bottomPoint));
      if bottomPoint >= 36 then
         V_turn := 3.6;
      elsif bottomPoint <= 28  and bottomPoint > 0 then
         V_turn := -3.6;
      elsif bottomPoint > 28 and bottomPoint < 36 then
         V_turn := 0.0;
      elsif bottomPoint = 0 then
         if d_sensor(6) < 450.0 then
            V_turn := 1.0;
         end if;
         if d_sensor(3) < 450.0 then
            V_turn := -1.0;
         end if;
      end if;

      Put_Line (d_sensor(3)'Image & ", " & d_sensor(6)'Image);
      Put_Line (V_turn'Image);
      --turn right

      if V_turn > 0.0 then
         wheehlvelocity(0) := basicVelocity + V_turn;
         wheehlvelocity(1) := basicVelocity - V_turn;
      --turn left
      elsif V_turn < 0.0 then
         wheehlvelocity(0) := basicVelocity + V_turn;
         wheehlvelocity(1) := basicVelocity - V_turn;
      else
         wheehlvelocity(0) := basicVelocity;
         wheehlvelocity(1) := basicVelocity;
      end if;
      Put_Line (wheehlvelocity (0)'Image & ", " & wheehlvelocity (1)'Image);

      return wheehlvelocity;

   end wheel_Velocity;

   function path_following (dataInput : in Communication_Packet; d_sensor : in Dtype) return Communication_Packet is
      raw : access types.payload := dataInput.local_payload;
      index : Image_Index := 0;
      o8 : Octets_8;
      u64 : uint64;
   begin
      --grayscale Image
      for I in Row_Index loop
         for J in Column_Index loop
            index := Image_Index(4 * (Integer(I) * width + Integer(J)));
            blue (I) (J) := raw (types.uint32(index) + 4);
            green (I) (J) := raw (types.uint32(index + 1) + 4);
            red (I) (J) := raw (types.uint32(index + 2) + 4);
            colour := Integer(blue (I) (J))*114/1000 + Integer(green (I) (J)) *587/1000 + Integer(red (I) (J))*299/1000;
            grey (I) (J) := uint8(colour);
         end loop;
      end loop;

      --Binarized
      binaImage := binarize(grey);
      --wheelvelocity calculate
      wheehlvelocity := wheel_Velocity(binaImage, d_sensor);

      declare packet : Communication_Packet;
      begin
         packet.package_ID := 129;
         packet.payload_length := 16 + 5;
         packet.local_payload := new payload (0 .. 15);

         u64 := types.float64_to_uint64 (wheehlvelocity (0));
         o8 := types.uint64_to_octets (u64);

         for I in o8'Range loop
            packet.local_payload (I) := o8 (I);
         end loop;

         u64 := types.float64_to_uint64 (wheehlvelocity (1));
         o8 := types.uint64_to_octets (u64);

         for I in o8'Range loop
            packet.local_payload (I + 8) := o8 (I);
         end loop;

         return packet;
      end;
   end path_following;

end pathfollowing;
