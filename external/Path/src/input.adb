with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure input is

   Input_File    : File_Type;
   value         : Integer;
   rangeIndex         : Integer := 0 ;
   I : Integer :=0;
   --type imageValue is range 0 .. 255;
   type pixelMatrix is array (0 .. 9999) of Integer;
   wholeImage : pixelMatrix;
   --procedure textOpen is
   begin

      Open (File => Input_File, Mode => Ada.Text_IO.In_File, Name => "dummy_image_curve.txt");

      while not End_OF_File (Input_File) loop
      Get(File => Input_File, Item => value);
      wholeImage(I) := value;
      Put (Integer'Image(wholeImage(I)));
      I := I + 1;
      New_Line;
      end loop;
      Close (File => Input_File);
      Put (I);
end input;
