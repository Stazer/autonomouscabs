with Ada.Unchecked_Conversion;
with System; use type System.Bit_Order;
with Ada.Text_IO;

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
   
   function unchecked_uint64_to_float64 is
      new Ada.Unchecked_Conversion (Source => uint64, Target => float64);
   
   function unchecked_float64_to_uint64 is
      new Ada.Unchecked_Conversion (Source => float64, Target => uint64);
   
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
   
   function uint64_to_float64 (X : uint64) return float64 is
   begin
      return unchecked_uint64_to_float64 (X);
   end uint64_to_float64;
   
   function float64_to_uint64 (X : float64) return uint64 is
   begin
      return unchecked_float64_to_uint64 (X);
   end float64_to_uint64;
   
   function hton16 (X : uint16) return uint16 is
      o2 : Octets_2;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o2 := uint16_to_octets (X);
         return octets_to_uint16 ((o2 (1), o2 (0)));
      end if;
      return X;
   end hton16;
   
   function ntoh16 (X : uint16) return uint16 is
      o2 : Octets_2;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o2 := uint16_to_octets (X);
         return octets_to_uint16 ((o2 (1), o2 (0)));
      end if;
      return X;
   end ntoh16;
   
   function hton32 (X : uint32) return uint32 is 
      o4 : Octets_4;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o4 := uint32_to_octets (X);
         return octets_to_uint32 ((o4 (3), o4 (2), o4 (1), o4 (0)));
      end if;
      return X;
   end hton32;
   
   function ntoh32 (X : uint32) return uint32 is
      o4 : Octets_4;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o4 := uint32_to_octets (X);
         return octets_to_uint32 ((o4 (3), o4 (2), o4 (1), o4 (0)));
      end if;
      return X;
   end ntoh32;
   
   function hton64 (X : uint64) return uint64 is
      o8 : Octets_8;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o8 := uint64_to_octets (X);
         return octets_to_uint64 ((o8 (7), o8 (6), o8 (5), o8 (4), 
                                  o8 (3), o8 (2), o8 (1), o8 (0)));
      end if;
      return X;
   end hton64;
   
   function ntoh64 (X : uint64) return uint64 is
      o8 : Octets_8;
   begin
      if System.Default_Bit_Order = System.Low_Order_First then
         o8 := uint64_to_octets (X);
         return octets_to_uint64 ((o8 (7), o8 (6), o8 (5), o8 (4), 
                                  o8 (3), o8 (2), o8 (1), o8 (0)));
      end if;
      return X;
   end ntoh64;
   
   protected body Mailbox is
      procedure Clear is
      begin
         Full := False;
      end Clear;
      entry Deposit(X: in Communication_Packet) when Full = False is
      begin
         A := X;
         Full := True;
      end Deposit;
      entry Collect(X: out Communication_Packet) when Full = True is
      begin
         X := A;
         Clear;
      end Collect;
   end Mailbox;
   
end types;
