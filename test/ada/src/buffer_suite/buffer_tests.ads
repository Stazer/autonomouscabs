with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with types; use types;

package buffer_tests is

   type buffer_test is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out buffer_test);
  -- Register routines to be run

   function Name (T : buffer_test) return Message_String;
  -- Provide name identifying the test case

  -- Test Routines:
   procedure Test_Read_Write_Uint8 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Read_Write_Uint16 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Read_Write_Uint32 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Read_Write_Uint64 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Read_Write_Payload (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Delete_Bytes (T : in out Test_Cases.Test_Case'Class);

end buffer_tests;
