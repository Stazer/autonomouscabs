with AUnit.Assertions; use AUnit.Assertions;

package body tcp_tests is

   -- Register test routines to call
   procedure Register_Tests (T: in out tcp_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_To_Unsigned_32'Access, "Test Conversion");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: tcp_test) return Test_String is
   begin
      return Format ("TCP Tests");
   end Name;

   -- Test routines:
   procedure Test_To_Unsigned_32 (T : in out Test_Cases.Test_Case'Class) is
      X : Octets_4;
   begin
      X := (1, 0, 0, 0);
      Assert (To_Unsigned_32 (X) = 1, "To_Unsigned_32 does not work.");
      return;
   end Test_To_Unsigned_32;

end tcp_tests;
