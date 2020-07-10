with Interfaces;
with Ada.Real_Time;

package Types is

   type Uint8 is new Interfaces.Unsigned_8;
   type Uint16 is new Interfaces.Unsigned_16;
   type Uint32 is new Interfaces.Unsigned_32;
   type Uint64 is new Interfaces.Unsigned_64;
   type Float64 is new Interfaces.IEEE_Float_64;
   type Octets_2 is array(Uint32 range 0 .. 1) of Uint8;
   type Octets_4 is array (Uint32 range 0 .. 3) of Uint8;
   type Octets_8 is array (Uint32 range 0 .. 7) of Uint8;
   
   type Payload is array(Uint32 range <>) of Uint8 with
     Default_Component_Value => 0;
   
   type Communication_Packet is record
      Package_ID : Uint8;
      Payload_Length : Uint32;
      Local_Payload : access Payload;
      TTL : Ada.Real_Time.Time;
   end record;
   
   function Uint16_To_Octets (X : Uint16) return Octets_2;
   function Uint32_To_Octets (X : Uint32) return Octets_4;
   function Uint64_To_Octets (X : Uint64) return Octets_8;
   
   function Octets_To_Uint16 (X : Octets_2) return Uint16;
   function Octets_To_Uint32 (X : Octets_4) return Uint32;
   function Octets_To_Uint64 (X : Octets_8) return Uint64;

   function Uint64_To_Float64 (X : Uint64) return Float64;
   function Float64_To_Uint64 (X : Float64) return Uint64;  
   
   function Hton16 (X : Uint16) return Uint16;
   function Ntoh16 (X : Uint16) return Uint16;
   
   function Hton32 (X : Uint32) return Uint32;
   function Ntoh32 (X : Uint32) return Uint32;
   
   function Hton64 (X : Uint64) return Uint64;
   function Ntoh64 (X : Uint64) return Uint64;
   
end Types;
