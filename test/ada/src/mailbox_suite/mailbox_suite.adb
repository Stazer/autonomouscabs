package body mailbox_suite is

   use AUnit.Test_Suites;

   --  Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   Test_1 : aliased mailbox_tests.mailbox_test;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, Test_1'Access);
      return Result'Access;
   end Suite;

end mailbox_suite;
