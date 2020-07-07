with AUnit; use AUnit;
with Ada.Text_IO;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with tcp_client; use tcp_client;
with types; use types;
with byte_buffer;
with mailbox;

package pathfollowing_tests is

   type pathfollowing_test is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out pathfollowing_test);
  -- Register routines to be run

   function Name (T : pathfollowing_test) return Message_String;
  -- Provide name identifying the test case

   -- Test Routines
   procedure Sample_test (T : in out Test_Cases.Test_Case'Class);

end pathfollowing_tests;
