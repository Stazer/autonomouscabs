with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with types; use types;
with mailbox;

package pathfollowing is

   width : constant Integer := 64;
   height : constant Integer := 64;
   size : constant Integer := width * height * 4;

   type Pixel is array(0 .. 3) of uint8;
   type Column_Index is range 0 .. width - 1;
   type Row_Index is range 0 .. height - 1;

   type Image_Index is range 0 .. size - 1;
   type Image_Raw is array(Image_Index) of uint8;

   type Colour_Column is array(Column_Index) of uint8;
   type Colour_Matrix is array(Row_Index) of Colour_Column;
   type Wheehl_velocity is array(0..1) of float64;
   type Dtype is array(0..8) of float64;

   function path_following(dataInput : in Communication_Packet; d_sensor : in Dtype) return Communication_Packet;
   function binarize(grey : in Colour_Matrix) return Colour_Matrix;
   function findLine(binarizedImage : in Colour_Matrix) return Integer;
   function wheel_Velocity(whiteLine : in Integer; d_sensor : in Dtype) return Wheehl_velocity;


end pathfollowing;
