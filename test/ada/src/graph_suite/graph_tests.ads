with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package graph_tests is

   type graph_tests is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out graph_tests);
  -- Register routines to be run

   function Name (T : graph_tests) return Message_String;
  -- Provide name identifying the test case

   -- Test Routines:
   procedure Test_Vertex_Is_Pickup (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Vertex_Is_Intersection (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Vertex_Is_Inner (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Vertex_Is_Outer (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Vertex_Comes_Before (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Simple_Add_To_Route (T : in out Test_Cases.Test_Case'Class);
   procedure Test_Complex_Add_To_Route (T : in out Test_Cases.Test_Case'Class);

end graph_tests;
