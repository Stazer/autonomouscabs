with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with types; use types;

package types_tests is

   type types_test is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out types_test);
  -- Register routines to be run

   function Name (T : types_test) return Message_String;
  -- Provide name identifying the test case

  -- Test Routines:
   procedure Test_Convert_Uint16 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Convert_Uint32 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Convert_Uint64 (T : in out Test_Cases.Test_Case'Class);
   
   procedure Test_Convert_Octet2 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Convert_Octet4 (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Convert_Octet8 (T : in out Test_Cases.Test_Case'Class);

end types_tests;
