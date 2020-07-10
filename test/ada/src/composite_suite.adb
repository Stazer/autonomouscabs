with AUnit.Tests;

with tcp_suite;
with buffer_suite;
with types_suite;
with graph_suite;
with mailbox_suite;


package body composite_suite is
   use Test_Suites;
   use tcp_suite;
   use buffer_suite;
   use types_suite;

   function Suite return Access_Test_Suite is
      Result : Access_Test_Suite := AUnit.Test_Suites.New_Suite;
   begin
      Result.Add_Test (tcp_suite.Suite);
      Result.Add_Test (buffer_suite.Suite);
      Result.Add_Test (types_suite.Suite);
      Result.Add_Test (mailbox_suite.Suite);
      Result.Add_Test (graph_suite.Suite);
      return Result;
   end Suite;
   
end composite_suite;
