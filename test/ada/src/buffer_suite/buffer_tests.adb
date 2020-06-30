with AUnit.Assertions; use AUnit.Assertions;
with types; use types;
with byte_buffer; use byte_buffer;

package body buffer_tests is

   procedure Register_Tests (T: in out buffer_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Read_Write_Uint8'Access, "Test write and read uint8 from buffer.");
      Register_Routine (T, Test_Read_Write_Uint16'Access, "Test write and read uint16 from buffer.");
      Register_Routine (T, Test_Read_Write_Uint32'Access, "Test write and read uint32 from buffer.");
      Register_Routine (T, Test_Read_Write_Uint64'Access, "Test write and read uint64 from buffer.");
      Register_Routine (T, Test_Read_Write_Payload'Access, "Test write and read payload from buffer.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: buffer_test) return Test_String is
   begin
      return Format ("Buffer Tests");
   end Name;
   
   procedure Test_Read_Write_Uint8 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u8, u8t : uint8;
   begin
      b.Index := 0;
      u8 := 230;
      b.write_uint8 (u8);
      b.read_uint8 (u8t);
      
      Assert (u8 = u8t, "Writing and reading uint8 does not work");
   end Test_Read_Write_Uint8;
   
   procedure Test_Read_Write_Uint16 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u16, u16t : uint16;
   begin
      b.Index := 0;
      u16 := 5000;
      b.write_uint16 (u16);
      b.read_uint16 (u16t);
      
      Assert (u16 = u16t, "Writing and reading uint16 does not work");
   end Test_Read_Write_Uint16;
   
   procedure Test_Read_Write_Uint32 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u32, u32t : uint32;
   begin
      b.Index := 0;
      u32 := 200000;
      b.write_uint32 (u32);
      b.read_uint32 (u32t);
      
      Assert (u32 = u32t, "Writing and reading uint32 does not work");
   end Test_Read_Write_Uint32;
   
   procedure Test_Read_Write_Uint64 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u64, u64t : uint64;
   begin
      b.Index := 0;
      u64 := 5000000;
      b.write_uint64 (u64);
      b.read_uint64 (u64t);
      
      Assert (u64 = u64t, "Writing and reading uint64 does not work");
   end Test_Read_Write_Uint64;
   
   procedure Test_Read_Write_Payload (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      p_in, p_out : access payload := new payload (0 .. 31);
      u8 : uint8 := 0;
   begin
      for I in p_in'Range loop
         p_in (I) := u8;
         u8 := u8 + 1;
      end loop;
      
      b.write_payload (p_in);
      b.read_payload (p_out);
      
      for I in p_out'Range loop
         Assert (p_out (I) = p_in (I), "Writing and reading payload does not work");
      end loop;
   end Test_Read_Write_Payload;
   
end buffer_tests;
