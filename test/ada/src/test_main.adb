with AUnit.Reporter.Text;
with AUnit.Run;
with composite_suite; use composite_suite;
with Ada.Task_Identification;  use Ada.Task_Identification;

procedure Test_Main is
   procedure Runner is new AUnit.Run.Test_Runner (composite_suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Runner (Reporter);
   return;
end Test_Main;
