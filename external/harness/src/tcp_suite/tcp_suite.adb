with tcp_tests;
with types_tests;
with buffer_tests;


package body tcp_suite is
   use AUnit.Test_Suites;

   --  Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   Test_1 : aliased tcp_tests.tcp_test;
   Test_2 : aliased types_tests.types_test;
   Test_3 : aliased buffer_tests.buffer_test;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, Test_1'Access);
      Add_Test (Result'Access, Test_2'Access);
      Add_Test (Result'Access, Test_3'Access);
      return Result'Access;
   end Suite;
end tcp_suite;
