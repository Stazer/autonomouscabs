with AUnit.Test_Suites;
with mailbox_tests; use mailbox_tests;

package mailbox_suite is

   function Suite return AUnit.Test_Suites.Access_Test_Suite;

end mailbox_suite;
