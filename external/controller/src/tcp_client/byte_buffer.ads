with Ada.Containers.Vectors;

with Types;
with Messages;

package Byte_Buffer is
   
   -- a simple read and write buffer
   type Buffer is tagged private;
   
   Wrong_Message_Id : exception;
   Not_Enough_Data : exception;
   
   -- procedures to read a Uintx/Payload from the buffer
   procedure Read_Uint8 (Self : in out Buffer; Val : out Types.Uint8);
   procedure Read_Uint16 (Self : in out Buffer; Val : out Types.Uint16);
   procedure Read_Uint32 (Self : in out Buffer; Val : out Types.Uint32);
   procedure Read_Uint64 (Self : in out Buffer; Val : out Types.Uint64);
   procedure Read_Float64 (Self : in out Buffer; Val : out Types.Float64);
   procedure Read_Payload (Self : in out Buffer; Val : access Types.Payload);
   
   -- procedures to write a Uintx/Payload from the buffer
   procedure Write_Uint8 (Self : in out Buffer; Val : in Types.Uint8);
   procedure Write_Uint16 (Self : in out Buffer; Val : in Types.Uint16);
   procedure Write_Uint32 (Self : in out Buffer; Val : in Types.Uint32);
   procedure Write_Uint64 (Self : in out Buffer; Val : in Types.Uint64);
   procedure Write_Float64 (Self : in out Buffer; Val : in Types.Float64);
   procedure Write_Payload (Self : in out Buffer; Val : access Types.Payload);
   
   procedure Read_Message (Self : in out Buffer; Val : in out Messages.Distance_Sensor_Message);
   procedure Read_Message (Self : in out Buffer; Val : in out Messages.Image_Data_Message);
   procedure Read_Message (Self : in out Buffer; Val : in out Messages.Join_Challenge_Message);
   
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Join_Success_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Velocity_Message);
   
   -- utility procedures
   function Bytes_Read (Self : in out Buffer) return Types.Uint32;
   function Bytes_Written (Self : in out Buffer) return Types.Uint32;
   function Bytes_Remaining (Self : in out Buffer) return Types.Uint32;
   function Size (Self : in out Buffer) return Types.Uint32;
   procedure Unwind (Self : in out Buffer; Bytes : in Types.Uint32);
   
   -- delete (N <= Self.Written ? N : Self.Written) bytes from the start of the Buffer
   procedure Delete_Bytes (Self : in out Buffer; N : in Types.Uint32);
   
private
   
   use Types;
   package Byte_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => Types.Uint8);
   use Byte_Vector;
   
   type Buffer is tagged record
      Vector : Byte_Vector.Vector;
      Read : Types.Uint32 := 0;
      Written : Types.Uint32 := 0;
   end record;
   
end Byte_Buffer;
