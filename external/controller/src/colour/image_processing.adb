with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Long_Elementary_Functions; use Ada.Numerics.Long_Elementary_Functions;

package body image_processing is
   
   function Parse_Raw_Image (raw : in Image_Raw) return Image_Matrix is
      img : Image_Matrix;
      index : Image_Index;
   begin
      for I in Row_Index loop
         for J in Column_Index loop
            index := Image_Index(4 * (Integer(I) * width + Integer(J)));
            img(I)(J).B := raw (index);
            img(I)(J).G := raw (index + 1);
            img(I)(J).R := raw (index + 2);
            img(I)(J).A := raw (index + 3);
         end loop;
      end loop;
      
      return img;
   end Parse_Raw_Image;
   
   
   procedure Get_Colour_Matrices(img : in Image_Matrix; 
                                 blue, green, red, grey : out Colour_Matrix) is
      colour : Integer := 0;
   begin
      blue := (others => (others => 0));
      green := (others => (others => 0));
      red := (others => (others => 0));
      grey := (others => (others => 0));
      
      for I in Row_Index loop
         for J in Column_Index loop
            blue (I) (J) := img(I)(J).B;
            green (I) (J) := img(I)(J).G;
            red (I) (J) := img(I)(J).R;
            colour := Integer(blue (I) (J)) + Integer(green (I) (J)) + Integer(red (I) (J));
            colour := colour / 3;
            grey (I) (J) := Colour_Value(colour);
         end loop;
      end loop;
   end Get_Colour_Matrices;
   
   -- step 1: RGB to XYZ
   -- step 2: XYZ to Lab
   -- source: http://www.easyrgb.com/en/math.php
   function RGB_To_LAB (rgb : in RGBAPixel) return LABPixel is
      X, Y, Z : Long_Float;
      R, G, B : Long_Float;
      lab : LABPixel;
      frac1 : Long_Float := Long_Float(1)/Long_Float(3);
      frac2 : Long_Float := Long_Float(16)/Long_Float(116);
   begin
      R := Long_Float(rgb.R) / 255.0;
      G := Long_Float(rgb.G) / 255.0;
      B := Long_Float(rgb.B) / 255.0;
      
      if R > 0.04045 then
         R := ((R + 0.055) / 1.055) ** 2.4;
      else
         R := R / 12.92;
      end if;
      
      if G > 0.04045 then
         G := ((G + 0.055) / 1.055) ** 2.4;
      else
         G := G / 12.92;
      end if; 
      
      if B > 0.04045 then
         B := ((B + 0.055) / 1.055) ** 2.4;
      else
         B := B / 12.92;
      end if;
      
      R := R * 100.0;
      G := G * 100.0;
      B := B * 100.0;
      
      -- D65/2° standard illuminant
      X := R * 0.4124 + G * 0.3576 + B * 0.1805;
      Y := R * 0.2126 + G * 0.7152 + B * 0.0722;
      Z := R * 0.0193 + G * 0.1192 + B * 0.9505;
      
      X := X / 95.047;
      Y := Y / 100.000;
      Z := Z / 108.883;
      
      if X > 0.008856 then
         X := X ** frac1;
      else
         X := (7.787 * X) + frac2;
      end if;
      
      if Y > 0.008856 then
         Y := Y ** frac1;
      else
         Y := (7.787 * Y) + frac2;
      end if;
      
      if Z > 0.008856 then
         Z := Z ** frac1;
      else
         Z := (7.787 * Z) + frac2;
      end if;
      
      lab.L := (116.0 * Y) - 16.0;
      lab.a := 500.0 * (X - Y);
      lab.b := 200.0 * (Y - Z);
      
      return lab;
   end RGB_To_LAB;
   
     
end image_processing;
