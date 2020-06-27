package image_processing is
   width : constant Integer := 10;
   height : constant Integer := 10;
   size : constant Integer := width * height * 4;

   type Colour_Value is range 0 .. 255;
   
   type RGBAPixel is record
      R, G, B, A : Colour_Value;
   end record;
   
   type LABPixel is record
      L, a, b : Long_Float;
   end record;
   
   
   type Column_Index is range 0 .. width - 1;
   type Row_Index is range 0 .. height - 1;

   type Image_Index is range 0 .. size - 1;
   type Image_Raw is array(Image_Index) of Colour_Value;
   
   type Image_Column is array(Column_Index) of RGBAPixel;
   type Image_Matrix is array(Row_Index) of Image_column;

   type Colour_Column is array(Column_Index) of Colour_Value;
   type Colour_Matrix is array(Row_Index) of Colour_Column;
   
   function Parse_Raw_Image (raw : in Image_Raw) return Image_Matrix;
   
   procedure Get_Colour_Matrices(img : in Image_Matrix; 
                                 blue, green, red, grey : out Colour_Matrix);
   
   function RGB_To_LAB (rgb : in RGBAPixel) return LABPixel;
   
   

end image_processing;
