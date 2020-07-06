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
   basicVelocity : float64 :=2.0 ;
   --ratio : float64 := 8.0;
   V_turn : float64 := 0.0;
   offset : Integer := 32;
   Kp : float64 := 0.08;
   Ki : float64 :=0.08;
   Kd : float64 := 0.08;
   Error : float64 := 0.0;
   lastError : float64 := 0.0;
   integral : float64 := 0.0;
   derivative : float64 := 0.0;


   function path_following (imageInput : in Communication_Packet) return Communication_Packet is
      raw : access types.payload := imageInput.local_payload;
      index : Image_Index := 0;
      o8 : Octets_8;
      u64 : uint64;
   begin
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

   --for I in Row_Index loop
      --for J in Column_Index loop
         --Put(Value'Image (blue (I) (J)));
         --Put(Value'Image (green (I) (J)));
         --Put(Value'Image (red (I) (J)));
         --Put(Value'Image (grey (I) (J)));
         --Put_Line("");
      --end loop;
      --end loop;
-- find bottompoint
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
      -- find toppoint
      for J in Column_Index loop
         if binaImage(0)(J) = 255 then
            topPoint := Integer(J);
         end if;
      end loop;
      for J in reverse Column_Index loop
         if binaImage(Row_Index(0))(J) = 255 then
            topPoint1 := Integer(J);
         end if;
      end loop;
      topPoint := (topPoint + topPoint1) / 2;
      -- find rightpoint
      for I in Row_Index loop
         if binaImage(I)(Column_Index(width-1)) = 255 then
            rightPoint:= Integer(I);
         end if;
      end loop;
      for I in reverse Row_Index loop
         if binaImage(I)(Column_Index(width-1)) = 255 then
            rightPoint1:= Integer(I);
         end if;
      end loop;
      rightPoint := (rightPoint + rightPoint1) /2;

      --find leftPoint
      for I in Row_Index loop
         if binaImage(I)(0) = 255 then
            leftPoint:= Integer(I);
         end if;
      end loop;
      for I in reverse Row_Index loop
         if binaImage(I)(0) = 255 then
            leftPoint1 := Integer(I);
         end if;
      end loop;
      leftPoint := (leftPoint + leftPoint1)/2;

 --     Put_Line(Integer'Image(bottomPoint) & Integer'Image(topPoint) & Integer'Image(rightPoint) & Integer'Image(leftPoint));
      --calculate steering angle
      -- top and bottom
      --if bottomPoint /= 0 and topPoint /= 0 and rightPoint = 0 and leftPoint = 0 then
         --if topPoint - bottomPoint > 0 then
            --steeringAngle := float64((topPoint - bottomPoint) / height) ;
         --elsif topPoint - bottomPoint < 0 then
            --steeringAngle := -float64((topPoint - bottomPoint) / height);
         --else steeringAngle := 0.0;
         --end if;
      --end if;
      -- bottom and left
      --if bottomPoint /= 0 and leftPoint/= 0 and topPoint = 0 and rightPoint = 0 then
         --steeringAngle := - float64(bottomPoint / (height - leftPoint));
      --end if;
      -- top and right
      --if topPoint /= 0 and rightPoint /= 0 and bottomPoint = 0 and leftPoint= 0 then
         --steeringAngle := - float64((width - topPoint) / rightPoint);
      --end if;
      --top and left
      --if topPoint /= 0 and leftPoint /=0 and bottomPoint = 0 and rightPoint = 0 then
         --steeringAngle := float64(topPoint / leftPoint);
      --end if;
      -- bottom and right
      --if bottomPoint/= 0 and rightPoint /= 0 and topPoint =0 and leftPoint = 0 then
         --steeringAngle := float64((width-bottomPoint) / (height - leftPoint));
         --end if;
      --Error : = bottomPoint - offset;
      --integral :  =  integral + Error;
      --derivative  : =  Error -  lastError;
      --V_turn := Kp * Error + Ki  * integral + Kd * derivative;



      if bottomPoint >= 36 then
         V_turn := 0.9;
      elsif bottomPoint <= 28  and bottomPoint > 0 then
         V_turn := -0.9;
         else V_turn := 0.0;
      end if;


  --    Put_Line (V_turn'Image);
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

--      Put_Line (wheehlvelocity (0)'Image & ", " & wheehlvelocity (1)'Image);

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
