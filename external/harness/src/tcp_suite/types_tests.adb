with AUnit.Assertions; use AUnit.Assertions;
with types; use types;

package body types_tests is
   
   -- Register test routines to call
   procedure Register_Tests (T: in out types_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Convert_Uint16'Access, "Test uint16 to Octet_2 and back.");
      Register_Routine (T, Test_Convert_Uint32'Access, "Test uint32 to Octet_4 and back.");
      Register_Routine (T, Test_Convert_Uint64'Access, "Test uint64 to Octet_8 and back.");
      
      Register_Routine (T, Test_Convert_Octet2'Access, "Test Octet_2 to uint16 and back.");
      Register_Routine (T, Test_Convert_Octet4'Access, "Test Octet_4 to uint32 and back.");
      Register_Routine (T, Test_Convert_Octet8'Access, "Test Octet_8 to uint64 and back.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: types_test) return Test_String is
   begin
      return Format ("Types Tests");
   end Name;

   procedure Test_Convert_Uint16 (T : in out Test_Cases.Test_Case'Class) is
      u16, u16t : uint16;
      o2 : Octets_2;
   begin
      u16 := 5000;
      o2 := uint16_to_octets (u16);
      u16t := octets_to_uint16 (o2);
      
      Assert (u16 = u16t, "Converting uint16 to octets and back does not work");
   end Test_Convert_Uint16;
   
   procedure Test_Convert_Uint32 (T : in out Test_Cases.Test_Case'Class) is
      u32, u32t : uint32;
      o4 : Octets_4;
   begin
      u32 := 100000;
      o4 := uint32_to_octets (u32);
      u32t := octets_to_uint32 (o4);
      
      Assert (u32 = u32t, "Converting uint32 to octets and back does not work");
   end Test_Convert_Uint32;
   
   procedure Test_Convert_Uint64 (T : in out Test_Cases.Test_Case'Class) is
      u64, u64t : uint64;
      o8 : Octets_8;
   begin
      u64 := 5000000;
      o8 := uint64_to_octets (u64);
      u64t := octets_to_uint64 (o8);
      
      Assert (u64 = u64t, "Converting uint64 to octets and back does not work");
   end Test_Convert_Uint64;
   
   procedure Test_Convert_Octet2 (T : in out Test_Cases.Test_Case'Class) is
      o2, o2t : Octets_2;
      u16 : uint16;
   begin
      o2 (0) := 150;
      o2 (1) := 35;
      u16 := octets_to_uint16 (o2);
      o2t := uint16_to_octets (u16);
      
      Assert (o2 (0) = o2t (0) and o2 (1) = o2t (1), 
              "Converting Octets_2 to uint16 and back does not work");
   end Test_Convert_Octet2;
   
   procedure Test_Convert_Octet4 (T : in out Test_Cases.Test_Case'Class) is
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
   end Test_Convert_Octet4;
   
   procedure Test_Convert_Octet8 (T : in out Test_Cases.Test_Case'Class) is
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
   end Test_Convert_Octet8;
   
end types_tests;
