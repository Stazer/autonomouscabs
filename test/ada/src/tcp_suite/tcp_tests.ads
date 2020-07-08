with AUnit; use AUnit;
with Ada.Text_IO;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with Tcp_Client; use Tcp_Client;
with Types; use Types;
with Byte_Buffer;
with Mailbox;

package tcp_tests is

   type tcp_test is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out tcp_test);
  -- Register routines to be run

   function Name (T : tcp_test) return Message_String;
  -- Provide name identifying the test case

   -- Test Routines
   procedure Test_read_payload (T : in out Test_Cases.Test_Case'Class);

end tcp_tests;
