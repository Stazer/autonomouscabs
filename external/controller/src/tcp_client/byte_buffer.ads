with Ada.Containers.Vectors;
with Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;

with Types;
with Messages;

package Byte_Buffer is
   
   -- a simple read and write buffer
   type Buffer is tagged private;
   
   Wrong_Message_Id : exception;
   Not_Enough_Data : exception;
   Unknown_Message_Id : exception;
   Connection_Closed : exception;
   
   -- procedures to read a Uintx/Payload from the buffer, raises Not_Enough_Data exception
   procedure Read_Uint8 (Self : in out Buffer; Val : out Types.Uint8);
   procedure Read_Uint16 (Self : in out Buffer; Val : out Types.Uint16);
   procedure Read_Uint32 (Self : in out Buffer; Val : out Types.Uint32);
   procedure Read_Uint64 (Self : in out Buffer; Val : out Types.Uint64);
   procedure Read_Float64 (Self : in out Buffer; Val : out Types.Float64);
   procedure Read_Payload (Self : in out Buffer; Val : access Types.Payload);
   
   -- procedures to write a Uintx/Payload from the buffer, raises Not_Enough_Data exception
   procedure Write_Uint8 (Self : in out Buffer; Val : in Types.Uint8);
   procedure Write_Uint16 (Self : in out Buffer; Val : in Types.Uint16);
   procedure Write_Uint32 (Self : in out Buffer; Val : in Types.Uint32);
   procedure Write_Uint64 (Self : in out Buffer; Val : in Types.Uint64);
   procedure Write_Float64 (Self : in out Buffer; Val : in Types.Float64);
   procedure Write_Payload (Self : in out Buffer; Val : access Types.Payload);
   
   -- try to read and parse a message in the buffer, raises Not_Enough_Data and Unknown_Message_Id exception
   procedure Read_Message (Self : in out Buffer; Val : out Messages.Message_Ptr);
   
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Light_Sensor_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Distance_Sensor_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Image_Data_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Join_Success_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Join_Challenge_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Velocity_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Position_Update_Message);
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Route_Update_Message);
   
   -- utility procedures
   function Bytes_Read (Self : in out Buffer) return Types.Uint32;
   function Bytes_Written (Self : in out Buffer) return Types.Uint32;
   function Bytes_Remaining (Self : in out Buffer) return Types.Uint32;
   function Size (Self : in out Buffer) return Types.Uint32;
   procedure Unwind (Self : in out Buffer; N : in Types.Uint32);
   
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
   
   -- write Bytes_Remaining of In_Buffer to Stream
   procedure Write_Stream (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                           In_Buffer : in Buffer);
   
   -- read a message from Stream into B
   procedure Read_Stream (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                          B : out Buffer);
   
   for Buffer'Write use Write_Stream;
   for Buffer'Read use Read_Stream;
   
end Byte_Buffer;
