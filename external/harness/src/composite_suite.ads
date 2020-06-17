with AUnit.Test_Suites;
with AUnit; use AUnit;

package composite_suite is
   function Suite return AUnit.Test_Suites.Access_Test_Suite;
end composite_suite;
