with Ada.Text_IO; use Ada.Text_IO;

procedure input is

   Input_File    : File_Type;
   value         : Character;
begin

   Ada.Text_IO.Open (File => Input_File, Mode => Ada.Text_IO.In_File, Name => "dummy_image_curve.txt");

   while not End_OF_File (Input_File) loop
      Ada.Text_IO.Get (File => Input_File, Item => value);
      Ada.Text_IO.Put (Item => value);
      Ada.Text_IO.New_Line;
   end loop;
   Ada.Text_IO.Close (File => Input_File);

end input;
