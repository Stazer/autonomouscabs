with AUnit.Assertions; use AUnit.Assertions;

package body pathfollowing_tests is

   -- Register test routines to call
   procedure Register_Tests (T: in out pathfollowing_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Sample_test'Access, "Sample test.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: pathfollowing_test) return Test_String is
   begin
      return Format ("Pathfollowing Tests");
   end Name;

   procedure Sample_test (T : in out Test_Cases.Test_Case'Class) is

      sample : types.uint8 := 1;

   begin

      Assert (sample = 1, "Sample test, to show what a test should look like.");

   end Sample_test;

end pathfollowing_tests;
