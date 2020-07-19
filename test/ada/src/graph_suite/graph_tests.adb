with AUnit.Assertions; use AUnit.Assertions;
with Graph; use Graph;

package body graph_tests is

   procedure Register_Tests (T: in out graph_tests) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Vertex_Is_Pickup'Access, "Test classifying the vertices as pickup locations.");
      Register_Routine (T, Test_Vertex_Is_Intersection'Access, "Test classifying the vertices as intersections.");
      Register_Routine (T, Test_Vertex_Is_Inner'Access, "Test classifying the vertices as inner.");
      Register_Routine (T, Test_Vertex_Is_Outer'Access, "Test classifying the vertices as outer.");
      Register_Routine (T, Test_Vertex_Comes_Before'Access, "Test the correct comes-before relationships.");
      Register_Routine (T, Test_Simple_Add_To_Route'Access, "Test simple route building with one source destination pair.");
      Register_Routine (T, Test_Complex_Add_To_Route'Access, "Test complex route building with more than one source destination pair.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: graph_tests) return Test_String is
   begin
      return Format ("Graph Tests");
   end Name;
   
   procedure Test_Vertex_Is_Pickup (T : in out Test_Cases.Test_Case'Class) is
   begin
      Graph.Create_Graph;
      
      Assert (Graph.Vertex_Is_Pickup (Graph.P0) = True, "Failed to classify P0 as pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.P1) = True, "Failed to classify P1 as pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.P2) = True, "Failed to classify P2 as pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.P3) = True, "Failed to classify P3 as pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.P4) = True, "Failed to classify P4 as pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.P5) = True, "Failed to classify P5 as pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.P6) = True, "Failed to classify P6 as pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.P7) = True, "Failed to classify P7 as pickup");
      
      Assert (Graph.Vertex_Is_Pickup (Graph.I1) = False, "Failed to classify I1 as not pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.I2) = False, "Failed to classify I2 as not pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.I3) = False, "Failed to classify I3 as not pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.I4) = False, "Failed to classify I5 as not pickup");
      
      Assert (Graph.Vertex_Is_Pickup (Graph.EV) = False, "Failed to classify EV as not pickup");
      Assert (Graph.Vertex_Is_Pickup (Graph.D) = False, "Failed to classify D as not pickup");
      
      Graph.Destroy_Graph;
   end Test_Vertex_Is_Pickup;
   
   procedure Test_Vertex_Is_Intersection (T : in out Test_Cases.Test_Case'Class) is
   begin
      Graph.Create_Graph;
      
      Assert (Graph.Vertex_Is_Intersection (Graph.I1) = True, "Failed to classify I1 as intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.I2) = True, "Failed to classify I2 as intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.I3) = True, "Failed to classify I3 as intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.I4) = True, "Failed to classify I5 as intersection");
      
      Assert (Graph.Vertex_Is_Intersection (Graph.P0) = False, "Failed to classify P0 as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.P1) = False, "Failed to classify P1 as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.P2) = False, "Failed to classify P2 as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.P3) = False, "Failed to classify P3 as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.P4) = False, "Failed to classify P4 as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.P5) = False, "Failed to classify P5 as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.P6) = False, "Failed to classify P6 as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.P7) = False, "Failed to classify P7 as not intersection");
      
      Assert (Graph.Vertex_Is_Intersection (Graph.EV) = False, "Failed to classify EV as not intersection");
      Assert (Graph.Vertex_Is_Intersection (Graph.D) = False, "Failed to classify D as not intersection");
      
      Graph.Destroy_Graph;
   end Test_Vertex_Is_Intersection;
   
   procedure Test_Vertex_Is_Inner (T : in out Test_Cases.Test_Case'Class) is
   begin
      Graph.Create_Graph;
      
      Assert (Graph.Vertex_Is_Inner (Graph.P0) = True, "Failed to classify P0 as inner");
      Assert (Graph.Vertex_Is_Inner (Graph.P1) = True, "Failed to classify P1 as inner");
      Assert (Graph.Vertex_Is_Inner (Graph.P2) = True, "Failed to classify P2 as inner");
      Assert (Graph.Vertex_Is_Inner (Graph.P3) = True, "Failed to classify P3 as inner");
      
      Assert (Graph.Vertex_Is_Inner (Graph.P4) = False, "Failed to classify P4 as not inner");
      Assert (Graph.Vertex_Is_Inner (Graph.P5) = False, "Failed to classify P5 as not inner");
      Assert (Graph.Vertex_Is_Inner (Graph.P6) = False, "Failed to classify P6 as not inner");
      Assert (Graph.Vertex_Is_Inner (Graph.P7) = False, "Failed to classify P7 as not inner");
      
      Assert (Graph.Vertex_Is_Inner (Graph.I1) = False, "Failed to classify I1 as not inner");
      Assert (Graph.Vertex_Is_Inner (Graph.I2) = False, "Failed to classify I2 as not inner");
      Assert (Graph.Vertex_Is_Inner (Graph.I3) = False, "Failed to classify I3 as not inner");
      Assert (Graph.Vertex_Is_Inner (Graph.I4) = False, "Failed to classify I5 as not inner");
      
      Assert (Graph.Vertex_Is_Inner (Graph.EV) = False, "Failed to classify EV as not inner");
      Assert (Graph.Vertex_Is_Inner (Graph.D) = False, "Failed to classify D as not inner");
      
      Graph.Destroy_Graph;
   end Test_Vertex_Is_Inner;
   
   procedure Test_Vertex_Is_Outer (T : in out Test_Cases.Test_Case'Class) is
   begin
      Graph.Create_Graph;
      
      Assert (Graph.Vertex_Is_Outer (Graph.P4) = True, "Failed to classify P4 as outer");
      Assert (Graph.Vertex_Is_Outer (Graph.P5) = True, "Failed to classify P5 as outer");
      Assert (Graph.Vertex_Is_Outer (Graph.P6) = True, "Failed to classify P6 as outer");
      Assert (Graph.Vertex_Is_Outer (Graph.P7) = True, "Failed to classify P7 as outer");
      
      Assert (Graph.Vertex_Is_Outer (Graph.P0) = False, "Failed to classify P0 as not outer");
      Assert (Graph.Vertex_Is_Outer (Graph.P1) = False, "Failed to classify P1 as not outer");
      Assert (Graph.Vertex_Is_Outer (Graph.P2) = False, "Failed to classify P2 as not outer");
      Assert (Graph.Vertex_Is_Outer (Graph.P3) = False, "Failed to classify P3 as not outer");
      
      Assert (Graph.Vertex_Is_Outer (Graph.I1) = False, "Failed to classify I1 as not outer");
      Assert (Graph.Vertex_Is_Outer (Graph.I2) = False, "Failed to classify I2 as not outer");
      Assert (Graph.Vertex_Is_Outer (Graph.I3) = False, "Failed to classify I3 as not outer");
      Assert (Graph.Vertex_Is_Outer (Graph.I4) = False, "Failed to classify I5 as not outer");
      
      Assert (Graph.Vertex_Is_Outer (Graph.EV) = False, "Failed to classify EV as not outer");
      Assert (Graph.Vertex_Is_Outer (Graph.D) = False, "Failed to classify D as not outer");
      
      Graph.Destroy_Graph;
   end Test_Vertex_Is_Outer;
   
   procedure Test_Vertex_Comes_Before (T : in out Test_Cases.Test_Case'Class) is
   begin
      Graph.Create_Graph;
      
      Assert (Graph.Vertex_Comes_Before (Graph.P0, Graph.P4, Graph.D) = True, 
              "Failed to recognize P0 comes before P4 given D");
      Assert (Graph.Vertex_Comes_Before (Graph.P1, Graph.P3, Graph.D) = True, 
              "Failed to recognize P1 comes before P3 given D");
      Assert (Graph.Vertex_Comes_Before (Graph.P2, Graph.P7, Graph.I2) = True, 
              "Failed to recognize P2 comes before P7 given I2");
      Assert (Graph.Vertex_Comes_Before (Graph.P0, Graph.P2, Graph.P6) = True, 
              "Failed to recognize P0 comes before P2 given P6");
      
      Assert (Graph.Vertex_Comes_Before (Graph.I2, Graph.P1, Graph.D) = False, 
              "Failed to recognize I2 does not come before P1 given D");
      Assert (Graph.Vertex_Comes_Before (Graph.P7, Graph.P6, Graph.P5) = False, 
              "Failed to recognize P7 does not come before P6 given P5");
      Assert (Graph.Vertex_Comes_Before (Graph.I4, Graph.I1, Graph.P0) = False, 
              "Failed to recognize I4 does not come before I1 given P0");
      Assert (Graph.Vertex_Comes_Before (Graph.P0, Graph.P2, Graph.P4) = False, 
              "Failed to recognize P0 does not comes before P2 given P4");
      
      Assert (Graph.Vertex_Comes_Before (Graph.P3, Graph.P0, Graph.P0) = False, 
              "Failed to recognize P3 does not come before P0 given P0");
      
      Assert (Graph.Vertex_Comes_Before (Graph.P1, Graph.P5, Graph.D) = False and
              Graph.Vertex_Comes_Before (Graph.P5, Graph.P1, Graph.D) = False, 
              "Failed to recognize neither P1 comes before P5 nor P5 comes before P1 given D");
      Assert (Graph.Vertex_Comes_Before (Graph.P2, Graph.P6, Graph.D) = False and
              Graph.Vertex_Comes_Before (Graph.P6, Graph.P2, Graph.D) = False, 
              "Failed to recognize neither P2 comes before P6 nor P6 comes before P2 given D");
      Assert (Graph.Vertex_Comes_Before (Graph.P3, Graph.P7, Graph.D) = False and
              Graph.Vertex_Comes_Before (Graph.P7, Graph.P3, Graph.D) = False, 
              "Failed to recognize neither P3 comes before P7 nor P7 comes before P3 given D");
      Assert (Graph.Vertex_Comes_Before (Graph.P0, Graph.P4, Graph.P3) = False and
              Graph.Vertex_Comes_Before (Graph.P7, Graph.P0, Graph.P3) = False, 
              "Failed to recognize neither P0 comes before P4 nor P4 comes before P0 given P3");
      
      Graph.Destroy_Graph;
   end Test_Vertex_Comes_Before;
   
   procedure Test_Simple_Add_To_Route (T : in out Test_Cases.Test_Case'Class) is
      R, A : Route;
      E : VID;
   begin
      Graph.Create_Graph;
      
      Add_To_Route (R, A, P0, P7, D);
      Assert (Integer (R.Length) = 5, "Route has the wrong Length");
      
      E := R.First_Element;
      Assert (E = P0, "Route is wrong. Expected P0");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I1, "Route is wrong. Expected I1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I2, "Route is wrong. Expected I2");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I3, "Route is wrong. Expected I3");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = P7, "Route is wrong. Expected P7");
      R.Delete_First;   
      
      A.Clear;
      Add_To_Route (R, A, P1, P2, D);
      Assert (Integer (R.Length) = 5, "Route has the wrong Length");
      
      E := R.First_Element;
      Assert (E = P0, "Route is wrong. Expected P0");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I1, "Route is wrong. Expected I1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = P1, "Route is wrong. Expected P1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I2, "Route is wrong. Expected I2");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = P2, "Route is wrong. Expected P2");
      R.Delete_First;   
      
      A.Clear;
      Add_To_Route (R, A, P1, D, D);
      Assert (Integer (R.Length) = 8, "Route has the wrong Length");
      
      E := R.First_Element;
      Assert (E = P0, "Route is wrong. Expected P0");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I1, "Route is wrong. Expected I1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = P1, "Route is wrong. Expected P1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I2, "Route is wrong. Expected I2");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I3, "Route is wrong. Expected I3");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I4, "Route is wrong. Expected I4");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = P0, "Route is wrong. Expected P0");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = D, "Route is wrong. Expected D");
      R.Delete_First;
      
      Graph.Destroy_Graph;
   end Test_Simple_Add_To_Route;
   
   procedure Test_Complex_Add_To_Route (T : in out Test_Cases.Test_Case'Class) is
      R, A : Route;
      E : VID;
   begin
      Graph.Create_Graph;
      
      Add_To_Route (R, A, P0, P2, D);
      Assert (Integer (R.Length) = 4, "Route has the wrong Length");
      
      Add_To_Route (R, A, P3, P4, D);
      Assert (Integer (R.Length) = 8, "Route has the wrong Length");
      
      E := R.First_Element;
      Assert (E = P0, "Route is wrong. Expected P0");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I1, "Route is wrong. Expected I1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I2, "Route is wrong. Expected I2");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = P2, "Route is wrong. Expected P2");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I3, "Route is wrong. Expected I3");
      R.Delete_First;  
      E := R.First_Element;
      Assert (E = P3, "Route is wrong. Expected P3");
      R.Delete_First;    
      E := R.First_Element;
      Assert (E = I4, "Route is wrong. Expected I4");
      R.Delete_First;  
      E := R.First_Element;
      Assert (E = P4, "Route is wrong. Expected P4");
      R.Delete_First;
      
      A.Clear;
      Add_To_Route (R, A, P0, P3, D);
      Assert (Integer (R.Length) = 5, "Route has the wrong Length");
      
      Add_To_Route (R, A, P1, P0, D);
      Assert (Integer (R.Length) = 8, "Route has the wrong Length");
      
      E := R.First_Element;
      Assert (E = P0, "Route is wrong. Expected P0");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I1, "Route is wrong. Expected I1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = P1, "Route is wrong. Expected P1");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I2, "Route is wrong. Expected I2");
      R.Delete_First;
      E := R.First_Element;
      Assert (E = I3, "Route is wrong. Expected I3");
      R.Delete_First;  
      E := R.First_Element;
      Assert (E = P3, "Route is wrong. Expected P3");
      R.Delete_First;    
      E := R.First_Element;
      Assert (E = I4, "Route is wrong. Expected I4");
      R.Delete_First;  
      E := R.First_Element;
      Assert (E = P0, "Route is wrong. Expected P0");
      R.Delete_First;
      
      Graph.Destroy_Graph;
   end Test_Complex_Add_To_Route;

end graph_tests;
