with tcp_suite;
with AUnit.Tests;


package body composite_suite is
   use Test_Suites;
   use tcp_suite;

   function Suite return Access_Test_Suite is
      Result : Access_Test_Suite := AUnit.Test_Suites.New_Suite;
   begin
      Result.Add_Test (tcp_suite.Suite);
      return Result;
   end Suite;
   
end composite_suite;
