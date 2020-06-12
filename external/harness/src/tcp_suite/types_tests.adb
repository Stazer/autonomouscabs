with AUnit.Assertions; use AUnit.Assertions;
with types; use types;

package body types_tests is
   
   -- Register test routines to call
   procedure Register_Tests (T: in out types_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Uint16_To_Octet2'Access, "Test uint16 to Octet_2 and back.");
      Register_Routine (T, Test_Uint32_To_Octet4'Access, "Test uint32 to Octet_4 and back.");
      Register_Routine (T, Test_Uint64_To_Octet8'Access, "Test uint64 to Octet_8 and back.");
      
      Register_Routine (T, Test_Octet2_To_Uint16'Access, "Test Octet_2 to uint16 and back.");
      Register_Routine (T, Test_Octet4_To_Uint32'Access, "Test Octet_4 to uint32 and back.");
      Register_Routine (T, Test_Octet8_To_Uint64'Access, "Test Octet_8 to uint64 and back.");
      
      Register_Routine (T, Test_Uint64_To_Float64'Access, "Test uint64 to float64 and back.");
      Register_Routine (T, Test_Float64_To_Uint64'Access, "Test float64 to uint64 and back.");
      
      Register_Routine (T, Test_Byte_Order_16'Access, "Test hton16 and ntoh16.");
      Register_Routine (T, Test_Byte_Order_32'Access, "Test hton32 and ntoh32.");
      Register_Routine (T, Test_Byte_Order_64'Access, "Test hton64 and ntoh64.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: types_test) return Test_String is
   begin
      return Format ("Types Tests");
   end Name;

   procedure Test_Uint16_To_Octet2 (T : in out Test_Cases.Test_Case'Class) is
      u16, u16t : uint16;
      o2 : Octets_2;
   begin
      u16 := 5000;
      o2 := uint16_to_octets (u16);
      u16t := octets_to_uint16 (o2);
      
      Assert (u16 = u16t, "Converting uint16 to octets and back does not work");
   end Test_Uint16_To_Octet2;
   
   procedure Test_Uint32_To_Octet4 (T : in out Test_Cases.Test_Case'Class) is
      u32, u32t : uint32;
      o4 : Octets_4;
   begin
      u32 := 100000;
      o4 := uint32_to_octets (u32);
      u32t := octets_to_uint32 (o4);
      
      Assert (u32 = u32t, "Converting uint32 to octets and back does not work");
   end Test_Uint32_To_Octet4;
   
   procedure Test_Uint64_To_Octet8 (T : in out Test_Cases.Test_Case'Class) is
      u64, u64t : uint64;
      o8 : Octets_8;
   begin
      u64 := 5000000;
      o8 := uint64_to_octets (u64);
      u64t := octets_to_uint64 (o8);
      
      Assert (u64 = u64t, "Converting uint64 to octets and back does not work");
   end Test_Uint64_To_Octet8;
   
   procedure Test_Octet2_To_Uint16 (T : in out Test_Cases.Test_Case'Class) is
      o2, o2t : Octets_2;
      u16 : uint16;
   begin
      o2 (0) := 150;
      o2 (1) := 35;
      u16 := octets_to_uint16 (o2);
      o2t := uint16_to_octets (u16);
      
      Assert (o2 (0) = o2t (0) and o2 (1) = o2t (1), 
              "Converting Octets_2 to uint16 and back does not work");
   end Test_Octet2_To_Uint16;
   
   procedure Test_Octet4_To_Uint32 (T : in out Test_Cases.Test_Case'Class) is
      o4, o4t : Octets_4;
      u32 : uint32;
   begin
      o4 (0) := 150;
      o4 (1) := 35;
      o4 (2) := 255;
      o4 (3) := 1;
      u32 := octets_to_uint32 (o4);
      o4t := uint32_to_octets (u32);
      
      Assert (o4 (0) = o4t (0) and o4 (1) = o4t (1) and 
              o4 (2) = o4t (2) and o4 (3) = o4t (3), 
              "Converting Octets_4 to uint32 and back does not work");
   end Test_Octet4_To_Uint32;
   
   procedure Test_Octet8_To_Uint64 (T : in out Test_Cases.Test_Case'Class) is
      o8, o8t : Octets_8;
      u64 : uint64;
   begin
      o8 (0) := 150;
      o8 (1) := 35;
      o8 (2) := 255;
      o8 (3) := 1;
      o8 (4) := 90;
      o8 (5) := 200;
      o8 (6) := 0;
      o8 (7) := 70;
      u64 := octets_to_uint64 (o8);
      o8t := uint64_to_octets (u64);
      
      Assert (o8 (0) = o8t (0) and o8 (1) = o8t (1) and 
              o8 (2) = o8t (2) and o8 (3) = o8t (3) and 
              o8 (4) = o8t (4) and o8 (5) = o8t (5) and
              o8 (6) = o8t (6) and o8 (7) = o8t (7), 
              "Converting Octets_4 to uint64 and back does not work");
   end Test_Octet8_To_Uint64;
   
   procedure Test_Uint64_To_Float64 (T : in out Test_Cases.Test_Case'Class) is
      u64, u64t : uint64;
      f64 : float64;
   begin
      u64 := 1234567;
      f64 := uint64_to_float64 (u64);
      u64t := float64_to_uint64 (f64);
      Assert (u64 = u64t, "Converting uint64 to float64 and back doe not work");
   end Test_Uint64_To_Float64;
   
   procedure Test_Float64_To_Uint64 (T : in out Test_Cases.Test_Case'Class) is
      f64, f64t : float64;
      u64 : uint64;
   begin
      f64 := 3.004972;
      u64 := float64_to_uint64 (f64);
      f64t := uint64_to_float64 (u64);
      
      Assert (f64 = f64t, "Converting float64 to uint64 and back doe not work");
   end Test_Float64_To_Uint64;
   
   procedure Test_Byte_Order_16 (T : in out Test_Cases.Test_Case'Class) is
      u16i, u16m, u16o : uint16;
   begin
      u16i := 45298;
      u16m := hton16 (u16i);
      u16o := ntoh16 (u16m);
      
      Assert (u16i = u16o, "hton16 and ntoh16 do not work.");
   end Test_Byte_Order_16;
   
   procedure Test_Byte_Order_32 (T : in out Test_Cases.Test_Case'Class) is
      u32i, u32m, u32o : uint32;
   begin
      u32i := 3568298;
      u32m := hton32 (u32i);
      u32o := ntoh32 (u32m);
      
      Assert (u32i = u32o, "hton32 and ntoh32 do not work.");
   end Test_Byte_Order_32;
   
   procedure Test_Byte_Order_64 (T : in out Test_Cases.Test_Case'Class) is
      u64i, u64m, u64o : uint64;
   begin
      u64i := 6568298;
      u64m := hton64 (u64i);
      u64o := ntoh64 (u64m);
      
      Assert (u64i = u64o, "hton64 and ntoh64 do not work.");
   end Test_Byte_Order_64;
      
end types_tests;
