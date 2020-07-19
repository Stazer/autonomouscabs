with Ada.Unchecked_Conversion;
with System; use type System.Bit_Order;

package body Types is

   function Unchecked_16_To_Octets is
     new Ada.Unchecked_Conversion (Source => Uint16, Target => Octets_2);
   
   function Unchecked_32_To_Octets is
     new Ada.Unchecked_Conversion (Source => Uint32, Target => Octets_4);
   
   function Unchecked_64_To_Octets is
      new Ada.Unchecked_Conversion (Source => Uint64, Target => Octets_8);
   
   function Unchecked_Octets_To_16 is
     new Ada.Unchecked_Conversion (Source => Octets_2, Target => Uint16);
   
   function Unchecked_Octets_To_32 is
     new Ada.Unchecked_Conversion (Source => Octets_4, Target => Uint32);
   
   function Unchecked_Octets_To_64 is 
     new Ada.Unchecked_Conversion (Source => Octets_8, Target => Uint64);
   
   function Unchecked_Uint64_To_Float64 is
      new Ada.Unchecked_Conversion (Source => Uint64, Target => Float64);
   
   function Unchecked_Float64_To_Uint64 is
      new Ada.Unchecked_Conversion (Source => Float64, Target => Uint64);
   
   function Uint16_To_Octets (X : Uint16) return Octets_2 is
   begin
      return Unchecked_16_To_Octets (X);
   end Uint16_To_Octets;
   
   function Uint32_To_Octets (X : Uint32) return Octets_4 is
   begin 
      return Unchecked_32_To_Octets (X);
   end Uint32_To_Octets;
   
   function Uint64_To_Octets (X : Uint64) return Octets_8 is
   begin 
      return Unchecked_64_To_Octets (X);
   end Uint64_To_Octets;
   
   function Octets_To_Uint16 (X : Octets_2) return Uint16 is
   begin 
      return Unchecked_Octets_To_16 (X);
   end Octets_To_Uint16;
   
   function Octets_To_Uint32 (X : Octets_4) return Uint32 is
   begin 
      return Unchecked_Octets_To_32 (X);
   end Octets_To_Uint32;
   
   function Octets_To_Uint64 (X : Octets_8) return Uint64 is 
   begin 
      return Unchecked_Octets_To_64 (X);
   end Octets_To_Uint64;   
   
   function Uint64_To_Float64 (X : Uint64) return Float64 is
   begin
      return Unchecked_Uint64_To_Float64 (X);
   end Uint64_To_Float64;
   
   function Float64_To_Uint64 (X : Float64) return Uint64 is
   begin
      return Unchecked_Float64_To_Uint64 (X);
   end Float64_To_Uint64;
   
   function Hton16 (X : Uint16) return Uint16 is
      o2 : Octets_2;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o2 := Uint16_To_Octets (X);
         return Octets_To_Uint16 ((o2 (1), o2 (0)));
      end if;
      return X;
   end Hton16;
   
   function Ntoh16 (X : Uint16) return Uint16 is
      o2 : Octets_2;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o2 := Uint16_To_Octets (X);
         return Octets_To_Uint16 ((o2 (1), o2 (0)));
      end if;
      return X;
   end Ntoh16;
   
   function Hton32 (X : Uint32) return Uint32 is 
      o4 : Octets_4;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o4 := Uint32_To_Octets (X);
         return Octets_To_Uint32 ((o4 (3), o4 (2), o4 (1), o4 (0)));
      end if;
      return X;
   end Hton32;
   
   function Ntoh32 (X : Uint32) return Uint32 is
      o4 : Octets_4;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o4 := Uint32_To_Octets (X);
         return Octets_To_Uint32 ((o4 (3), o4 (2), o4 (1), o4 (0)));
      end if;
      return X;
   end Ntoh32;
   
   function Hton64 (X : Uint64) return Uint64 is
      o8 : Octets_8;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o8 := Uint64_To_Octets (X);
         return Octets_To_Uint64 ((o8 (7), o8 (6), o8 (5), o8 (4), 
                                  o8 (3), o8 (2), o8 (1), o8 (0)));
      end if;
      return X;
   end Hton64;
   
   function Ntoh64 (X : Uint64) return Uint64 is
      o8 : Octets_8;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o8 := Uint64_To_Octets (X);
         return Octets_To_Uint64 ((o8 (7), o8 (6), o8 (5), o8 (4), 
                                  o8 (3), o8 (2), o8 (1), o8 (0)));
      end if;
      return X;
   end Ntoh64;
   
   function Is_Numeric (Item : in String) return Boolean is
      Check : Float;
   begin
      Check := Float'Value (Item);
      return True;
   exception
      when others =>
         return False;
   end Is_Numeric;
   
end types;
