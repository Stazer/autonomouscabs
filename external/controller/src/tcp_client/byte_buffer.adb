with Ada.Unchecked_Conversion;
with types;

package body byte_buffer is      

   procedure write_uint8 (Self : in out Buffer; Val : in types.uint8) is
   begin
      Self.buffer.Append (Val);
   end write_uint8;
      
   procedure write_uint16 (Self : in out Buffer; Val : in types.uint16) is
      o2 : types.Octets_2 := types.uint16_to_octets (Val);
   begin
      Self.Buffer.Append (o2 (0));
      Self.Buffer.Append (o2 (1));
   end write_uint16;
   
   procedure write_uint32 (Self : in out Buffer; Val : in types.uint32) is
      o4 : types.Octets_4 := types.uint32_to_octets (Val);
   begin
      Self.Buffer.Append (o4 (0));
      Self.Buffer.Append (o4 (1));
      Self.Buffer.Append (o4 (2));
      Self.Buffer.Append (o4 (3));
   end write_uint32;
      
   procedure write_uint64 (Self : in out Buffer; Val : in types.uint64) is
      o8 : types.Octets_8 := types.uint64_to_octets (Val);
   begin
      Self.Buffer.Append (o8 (0));
      Self.Buffer.Append (o8 (1));
      Self.Buffer.Append (o8 (2));
      Self.Buffer.Append (o8 (3));
      Self.Buffer.Append (o8 (4));
      Self.Buffer.Append (o8 (5));
      Self.Buffer.Append (o8 (6));
      Self.Buffer.Append (o8 (7));
   end write_uint64;
   
   procedure read_uint8 (Self : in out Buffer; Val : out types.uint8) is
   begin
      Val := Self.Buffer.Element (Self.Index);
      Self.Index := Self.Index + 1;
   end read_uint8;
   
   procedure read_uint16 (Self : in out Buffer; Val : out types.uint16) is
      o2 : types.Octets_2;
   begin
      o2 (0) := Self.Buffer.Element (Self.Index);
      o2 (1) := Self.Buffer.Element (Self.Index + 1);
      Val := types.octets_to_uint16 (o2);
      Self.Index := Self.Index + 2;
   end read_uint16;
   
   procedure read_uint32 (Self : in out Buffer; Val : out types.uint32) is
      o4 : types.Octets_4;
   begin
      o4 (0) := Self.Buffer.Element (Self.Index);
      o4 (1) := Self.Buffer.Element (Self.Index + 1);
      o4 (2) := Self.Buffer.Element (Self.Index + 2);
      o4 (3) := Self.Buffer.Element (Self.Index + 3);
      Val := types.octets_to_uint32 (o4);
      Self.Index := Self.Index + 4;
   end read_uint32;
   
   procedure read_uint64 (Self : in out Buffer; Val : out types.uint64) is
      o8 : types.Octets_8;
   begin
      o8 (0) := Self.Buffer.Element (Self.Index);
      o8 (1) := Self.Buffer.Element (Self.Index + 1);
      o8 (2) := Self.Buffer.Element (Self.Index + 2);
      o8 (3) := Self.Buffer.Element (Self.Index + 3);
      o8 (4) := Self.Buffer.Element (Self.Index + 4);
      o8 (5) := Self.Buffer.Element (Self.Index + 5);
      o8 (6) := Self.Buffer.Element (Self.Index + 6);
      o8 (7) := Self.Buffer.Element (Self.Index + 7);
      Val := types.octets_to_uint64 (o8);
      Self.Index := Self.Index + 8;
   end read_uint64; 
   
   function size (Self : in out Buffer) return Integer is
   begin
      return Integer (Self.Buffer.Length);
   end Size;

end byte_buffer;
