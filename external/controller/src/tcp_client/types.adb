with Ada.Unchecked_Conversion;

package body types is

   function unchecked_16_to_octets is
     new Ada.Unchecked_Conversion (Source => uint16, Target => Octets_2);
   
   function unchecked_32_to_octets is
     new Ada.Unchecked_Conversion (Source => uint32, Target => Octets_4);
   
   function unchecked_64_to_octets is
      new Ada.Unchecked_Conversion (Source => uint64, Target => Octets_8);
   
   function unchecked_octets_to_16 is
     new Ada.Unchecked_Conversion (Source => Octets_2, Target => uint16);
   
   function unchecked_octets_to_32 is
     new Ada.Unchecked_Conversion (Source => Octets_4, Target => uint32);
   
   function unchecked_octets_to_64 is 
     new Ada.Unchecked_Conversion (Source => Octets_8, Target => uint64);
   
   function uint16_to_octets (X : uint16) return Octets_2 is
   begin
      return unchecked_16_to_octets (X);
   end uint16_to_octets;
   
   function uint32_to_octets (X : uint32) return Octets_4 is
   begin 
      return unchecked_32_to_octets (X);
   end uint32_to_octets;
   
   function uint64_to_octets (X : uint64) return Octets_8 is
   begin 
      return unchecked_64_to_octets (X);
   end uint64_to_octets;
   
   function octets_to_uint16 (X : Octets_2) return uint16 is
   begin 
      return unchecked_octets_to_16 (X);
   end octets_to_uint16;
   
   function octets_to_uint32 (X : Octets_4) return uint32 is
   begin 
      return unchecked_octets_to_32 (X);
   end octets_to_uint32;
   
   function octets_to_uint64 (X : Octets_8) return uint64 is 
   begin 
      return unchecked_octets_to_64 (X);
   end octets_to_uint64;   

end types;
