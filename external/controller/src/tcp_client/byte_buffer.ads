with Ada.Containers.Vectors;
with types; use types;

package byte_buffer is
      
   package Byte_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => types.uint8);
   use Byte_Vector;
   
   type Buffer is tagged record
      Buffer : Byte_Vector.Vector;
      Index : Integer;     
   end record;
   
   procedure write_uint8 (Self : in out Buffer; Val : in types.uint8);
   procedure write_uint16 (Self : in out Buffer; Val : in types.uint16);
   procedure write_uint32 (Self : in out Buffer; Val : in types.uint32);
   procedure write_uint64 (Self : in out Buffer; Val : in types.uint64);
   
   procedure read_uint8 (Self : in out Buffer; Val : out types.uint8);
   procedure read_uint16 (Self : in out Buffer; Val : out types.uint16);
   procedure read_uint32 (Self : in out Buffer; Val : out types.uint32);
   procedure read_uint64 (Self : in out Buffer; Val : out types.uint64);
   
   function size (Self : in out Buffer) return Integer;

end byte_buffer;
