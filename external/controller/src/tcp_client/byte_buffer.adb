package body Byte_Buffer is
      
   procedure Read_Uint8 (Self : in out Buffer; Val : out Types.Uint8) is
   begin
      Val := Self.Vector.Element (Integer (Self.Read));
      Self.Read := Self.Read + 1;
   end Read_Uint8;
   
   procedure Read_Uint16 (Self : in out Buffer; Val : out Types.Uint16) is
      o2 : Types.Octets_2;
   begin
      o2 (0) := Self.Vector.Element (Integer (Self.Read));
      o2 (1) := Self.Vector.Element (Integer (Self.Read) + 1);
      Val := Types.octets_to_Uint16 (o2);
      Self.Read := Self.Read + 2;
   end Read_Uint16;
   
   procedure Read_Uint32 (Self : in out Buffer; Val : out Types.Uint32) is
      o4 : Types.Octets_4;
   begin
      o4 (0) := Self.Vector.Element (Integer (Self.Read));
      o4 (1) := Self.Vector.Element (Integer (Self.Read) + 1);
      o4 (2) := Self.Vector.Element (Integer (Self.Read) + 2);
      o4 (3) := Self.Vector.Element (Integer (Self.Read) + 3);
      Val := Types.octets_to_Uint32 (o4);
      Self.Read := Self.Read + 4;
   end Read_Uint32;
   
   procedure Read_Uint64 (Self : in out Buffer; Val : out Types.Uint64) is
      o8 : Types.Octets_8;
   begin
      o8 (0) := Self.Vector.Element (Integer (Self.Read));
      o8 (1) := Self.Vector.Element (Integer (Self.Read) + 1);
      o8 (2) := Self.Vector.Element (Integer (Self.Read) + 2);
      o8 (3) := Self.Vector.Element (Integer (Self.Read) + 3);
      o8 (4) := Self.Vector.Element (Integer (Self.Read) + 4);
      o8 (5) := Self.Vector.Element (Integer (Self.Read) + 5);
      o8 (6) := Self.Vector.Element (Integer (Self.Read) + 6);
      o8 (7) := Self.Vector.Element (Integer (Self.Read) + 7);
      Val := Types.octets_to_Uint64 (o8);
      Self.Read := Self.Read + 8;
   end Read_Uint64; 
   
   procedure Read_Payload (Self : in out Buffer; Val : access Types.Payload) is
      count : Types.Uint32 := 0;
   begin
      for I in Val'Range loop
         Val (I) := Self.Vector.Element (Integer (Self.Read + count));
         count := count + 1;
      end loop;
      Self.Read := Self.Read + count; 
   end Read_Payload;

   procedure Write_Uint8 (Self : in out Buffer; Val : in Types.Uint8) is
   begin
      Self.Vector.Append (Val);
      Self.Written := Self.Written + 1;
   end Write_Uint8;
      
   procedure Write_Uint16 (Self : in out Buffer; Val : in Types.Uint16) is
      o2 : Types.Octets_2 := Types.Uint16_To_Octets (Val);
   begin
      Self.Vector.Append (o2 (0));
      Self.Vector.Append (o2 (1));
      Self.Written := Self.Written + 2;
   end Write_Uint16;
   
   procedure Write_Uint32 (Self : in out Buffer; Val : in Types.Uint32) is
      o4 : Types.Octets_4 := Types.Uint32_To_Octets (Val);
   begin
      Self.Vector.Append (o4 (0));
      Self.Vector.Append (o4 (1));
      Self.Vector.Append (o4 (2));
      Self.Vector.Append (o4 (3));
      Self.Written := Self.Written + 4;
   end Write_Uint32;
      
   procedure Write_Uint64 (Self : in out Buffer; Val : in Types.Uint64) is
      o8 : Types.Octets_8 := Types.Uint64_To_Octets (Val);
   begin
      Self.Vector.Append (o8 (0));
      Self.Vector.Append (o8 (1));
      Self.Vector.Append (o8 (2));
      Self.Vector.Append (o8 (3));
      Self.Vector.Append (o8 (4));
      Self.Vector.Append (o8 (5));
      Self.Vector.Append (o8 (6));
      Self.Vector.Append (o8 (7));
      Self.Written := Self.Written + 8;
   end Write_Uint64; 
   
   procedure Write_Payload (Self : in out Buffer; Val : access Types.Payload) is
      count : Types.Uint32 := 0;
   begin
      for I in Val'Range loop
         Self.Vector.Append (Val (I));
         count := count + 1;
      end loop;
      Self.Written := Self.Written + count;
   end Write_Payload;
   
   function Bytes_Read (Self : in out Buffer) return Types.Uint32 is
   begin
      return Self.Read;
   end Bytes_Read;
   
   function Bytes_Written (Self : in out Buffer) return Types.Uint32 is
   begin
      return Self.Written;
   end Bytes_Written;
   
   function Bytes_Remaining (Self : in out Buffer) return Types.Uint32 is
   begin
      return Self.Written - Self.Read;
   end Bytes_Remaining;
   
   function Size (Self : in out Buffer) return Types.Uint32 is
   begin
      return Types.Uint32 (Self.Vector.Length);
   end Size;
      
   procedure Unwind (Self : in out Buffer; Bytes : in Types.Uint32) is
   begin
      Self.Read := Types.Uint32'Max (Self.Read - Bytes, 0);
   end Unwind;
   
   procedure Delete_Bytes (Self : in out Buffer; N : in Types.Uint32) is
      N_Bytes : Types.Uint32 :=  (if N > Self.Written then Self.Written else N);
   begin
      Self.Vector.Delete (0, Ada.Containers.Count_Type (N_Bytes));
   end Delete_Bytes;
   
end Byte_Buffer;
