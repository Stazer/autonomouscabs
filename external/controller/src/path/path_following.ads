with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

with Types; use Types;
with Mailbox;
with Messages;

package Path_Following is

   width : constant Integer := 64;
   height : constant Integer := 5;
   size : constant Integer := width * height * 4;

   type Pixel is array(0 .. 3) of uint8;
   type Column_Index is range 0 .. width - 1;
   type Row_Index is range 0 .. height - 1;

   type Image_Index is range 0 .. size - 1;
   type Image_Raw is array(Image_Index) of uint8;

   type Colour_Column is array(Column_Index) of uint8;
   type Colour_Matrix is array(Row_Index) of Colour_Column;
   type Velocity_Array is array(0..1) of Float64;
   type Command is (turnLeft, turnRight, goStraight);

   function Main (Data_Input : in Messages.ID_Message_Ptr; d_sensor : in Messages.Distance_Sensor_Array) return Messages.Velocity_Message;
   function Binarize (grey : in Colour_Matrix) return Colour_Matrix;
   function Find_Line (binarizedImage : in Colour_Matrix) return Integer;
   function Wheel_Velocity (whiteLine : in Integer; d_sensor : in Messages.Distance_Sensor_Array) return Velocity_Array;

   procedure Check_For_Fork (Command_Value : in Command; left_bottomPoint : in out Integer; right_bottomPoint : in out Integer );

end Path_Following;
