with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with AUnit.Assertions; use AUnit.Assertions;
with Types; use Types;
with Mailbox;
with Byte_Buffer;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;

with Messages; use Messages;

package mailbox_tests is

   type mailbox_test is new Test_Cases.Test_Case with null record;

   -- Register routines to be run
   procedure Register_Tests (T : in out mailbox_test);

   -- Provide name identifying the test case
   function Name (T : mailbox_test) return Message_String;
   
   -- Set up performed before each test routine
   procedure Set_Up (T : in out mailbox_test);
   
   -- Tear down performed after each test routine
   procedure Tear_Down (T : in out mailbox_test);

   -- Test Routines
   procedure Test_Collect_and_Deposit (T : in out Test_Cases.Test_Case'Class);
   
   procedure Test_View_Inbox (T : in out Test_Cases.Test_Case'Class);
   
   procedure Test_Clear_Is_Not_Expired (T : in out Test_Cases.Test_Case'Class);
   
   procedure Test_Clear_Is_Expired (T : in out Test_Cases.Test_Case'Class);
   
   procedure Test_Empty (T : in out Test_Cases.Test_Case'Class);
   
   procedure Test_Is_Expired (T : in out Test_Cases.Test_Case'Class);

end mailbox_tests;
