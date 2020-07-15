with AUnit.Assertions; use AUnit.Assertions;

package body tcp_tests is

   -- Register test routines to call
   procedure Register_Tests (T: in out tcp_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Sample_Test'Access, "This is an empty sample test, because Ada wants at least one test per suite to compile.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: tcp_test) return Test_String is
   begin
      return Format ("TCP Tests");
   end Name;

   procedure Sample_Test (T : in out Test_Cases.Test_Case'Class) is
      local : Integer;
   begin
      local := 1;

      Assert (local = 1, "This should never happen.");
   end Sample_Test;

end tcp_tests;
