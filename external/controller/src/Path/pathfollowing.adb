package body pathfollowing is


   raw : Image_Raw := (others => 0);
   index : Image_Index := 0;


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
   steeringAngle : uint8:= 0.0;

   red : Colour_Matrix := (others => (others => 0));
   blue : Colour_Matrix := (others => (others => 0));
   green : Colour_Matrix := (others => (others => 0));
   grey : Colour_Matrix := (others => (others => 0));
   binaImage : Colour_Matrix := (others => (others => 0));

   wheehlvelocity : Wheehl_velocity :=(others => 0);
   axleTrack : uint8 := 1.1;
   basicVelocity : uint8 := 1.0;

   function path_following (ImageData : in Communication_Packet) return Communication_Packet is
      begin

      raw : = Image_Raw(ImageData.local_payload);

      for I in Row_Index loop
         for J in Column_Index loop
            index := Image_Index(4 * (Integer(I) * width + Integer(J)));
            blue (I) (J) := raw (index);
            green (I) (J) := raw (index + 1);
            red (I) (J) := raw (index + 2);
            --colour := Integer((Integer(blue (I) (J)*50) + Integer(green (I) (J)*59)+ Integer(red (I) (J)*30) + 50)/100);
            colour := Integer(blue (I) (J))*114/1000 + Integer(green (I) (J)) *587/1000 + Integer(red (I) (J))*299/1000;
            --colour := colour / 3;
            --r := Integer(red(I)(J) * 30);
            --g := Integer(green(I)(J) * 59);
            --b := Integer(blue(I)(J) * 50);
            --colour := (r + g +b + 50) / 100;
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
         Put(uint8'Image (binaImage (I) (J)));

      end loop;
         Put_Line("");
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
      if grey(Row_Index(height-1))(J) = 255 then
         bottomPoint := Integer(J);
      end if;
      --
   end loop;
   for J in reverse Column_Index loop
      if grey(Row_Index(height-1))(J) = 255 then
         bottomPoint1 := Integer(J);
      end if;
   end loop;
   bottomPoint := (bottomPoint + bottomPoint1) / 2;
 -- find toppoint
   for J in Column_Index loop
      if grey(0)(J) = 255 then
         topPoint := Integer(J);
      end if;
   end loop;
   for J in reverse Column_Index loop
      if grey(Row_Index(0))(J) = 255 then
         topPoint1 := Integer(J);
      end if;
   end loop;
   topPoint := (topPoint + topPoint1) / 2;
   -- find rightpoint
   for I in Row_Index loop
      if grey(I)(Column_Index(width-1)) = 255 then
          rightPoint:= Integer(I);
      end if;
   end loop;
   for I in reverse Row_Index loop
      if grey(I)(Column_Index(width-1)) = 255 then
          rightPoint1:= Integer(I);
      end if;
   end loop;
   rightPoint := (rightPoint + rightPoint1) /2;

   --find leftPoint
   for I in Row_Index loop
      if grey(I)(0) = 255 then
          leftPoint:= Integer(I);
      end if;
   end loop;
   for I in reverse Row_Index loop
      if grey(I)(0) = 255 then
          leftPoint1 := Integer(I);
      end if;
   end loop;
   leftPoint := (leftPoint + leftPoint1)/2;

   Put_Line(Integer'Image(bottomPoint) & Integer'Image(topPoint) & Integer'Image(rightPoint) & Integer'Image(leftPoint));
   --calculate steering angle
   -- top and bottom
   if bottomPoint /= 0 and topPoint /= 0 and rightPoint = 0 and leftPoint = 0 then
      if topPoint - bottomPoint > 0 then
         steeringAngle := Float((topPoint - bottomPoint) / height) ;
      elsif topPoint - bottomPoint < 0 then
         steeringAngle := -Float((topPoint - bottomPoint) / height);
      else steeringAngle := 0.0;
      end if;
   end if;
   -- bottom and left
   if bottomPoint /= 0 and leftPoint/= 0 and topPoint = 0 and rightPoint = 0 then
      steeringAngle := - Float(bottomPoint / (height - leftPoint));
   end if;
   -- top and right
   if topPoint /= 0 and rightPoint /= 0 and bottomPoint = 0 and leftPoint= 0 then
      steeringAngle := - Float((width - topPoint) / rightPoint);
   end if;
   --top and left
   if topPoint /= 0 and leftPoint /=0 and bottomPoint = 0 and rightPoint = 0 then
      steeringAngle := Float(topPoint / leftPoint);
   end if;
   -- bottom and right
   if bottomPoint/= 0 and rightPoint /= 0 and topPoint =0 and leftPoint = 0 then
      steeringAngle := Float((width-bottomPoint) / (height - leftPoint));
   end if;


      Put_Line (Float'Image(steeringAngle));
      --turn right
      if steeringAngle > 0 then
         wheehlvelocity(0) = basicVelocity + steeringAngle * axleTrack;
         wheehlvelocity(1) = basicVelocity;
      --turn left
      elsif steeringAngle < 0 then
         wheehlvelocity(0) = basicVelocity;
         wheehlvelocity(1) = basicVelocity - steeringAngle * axleTrack;
      end if;
      ImageData.local_payload := wheehlvelocity;
      return ImageData;
   end path_following;

end pathfollowing;
