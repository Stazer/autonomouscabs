with Interfaces;

package types is

   type uint8 is new Interfaces.Unsigned_8;
   type uint16 is new Interfaces.Unsigned_16;
   type uint32 is new Interfaces.Unsigned_32;
   type uint64 is new Interfaces.Unsigned_64;
   type Octets_2 is array(0 .. 1) of uint8;
   type Octets_4 is array (0 .. 3) of uint8;
   type Octets_8 is array (0 .. 7) of uint8;
   
   function uint16_to_octets (X : uint16) return Octets_2;
   function uint32_to_octets (X : uint32) return Octets_4;
   function uint64_to_octets (X : uint64) return Octets_8;
   
   function octets_to_uint16 (X : Octets_2) return uint16;
   function octets_to_uint32 (X : Octets_4) return uint32;
   function octets_to_uint64 (X : Octets_8) return uint64;

end types;
