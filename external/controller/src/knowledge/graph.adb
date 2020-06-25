with Ada.Text_IO; use Ada.Text_IO;

package body Graph is
   
   function Get_Priority (V : VID) return Float is
   begin
      return Vertices (V).Cost;
   end Get_Priority;
   
   function Before (V, W : Float) return Boolean is
   begin
      return V < W;
   end Before;
   
   function Hash_Vertex (V : VID) return GNAT.Bucket_Range_Type is
   begin
      return GNAT.Bucket_Range_Type (VID'Pos (V));
   end Hash_Vertex;
   
   function Same_Vertex (V, W : VID) return Boolean is
   begin
      return V = W;
   end Same_Vertex;
      
   function Hash_Edge (E : EID) return GNAT.Bucket_Range_Type is
   begin
      return GNAT.Bucket_Range_Type (EID'Pos (E));
   end Hash_Edge;
   
   function Same_Edge (E, F : EID) return Boolean is
   begin
      return E = F;
   end Same_Edge;
   
   procedure Create_Graph is
   begin
      Road_Network := Create (13, 26);

      -- add pickup locations
      Add_Vertex (G => Road_Network, V => P0);
      Add_Vertex (G => Road_Network, V => P1);
      Add_Vertex (G => Road_Network, V => P2);
      Add_Vertex (G => Road_Network, V => P3);
      Add_Vertex (G => Road_Network, V => P4);
      Add_Vertex (G => Road_Network, V => P5);
      Add_Vertex (G => Road_Network, V => P6);
      Add_Vertex (G => Road_Network, V => P7);
      
      -- add intersections
      Add_Vertex (G => Road_Network, V => I1);
      Add_Vertex (G => Road_Network, V => I2);
      Add_Vertex (G => Road_Network, V => I3);
      Add_Vertex (G => Road_Network, V => I4);
      
      -- add depot
      Add_Vertex (G => Road_Network, V => D);
      
      Vertices (EV) := (EV, EV, 0.0);
      
      Vertices (P0) := (P0, EV, 0.0);
      Vertices (P1) := (P1, EV, 0.0);
      Vertices (P2) := (P2, EV, 0.0);
      Vertices (P3) := (P3, EV, 0.0);
      Vertices (P4) := (P4, EV, 0.0);
      Vertices (P5) := (P5, EV, 0.0);
      Vertices (P6) := (P6, EV, 0.0);
      Vertices (P7) := (P7, EV, 0.0);
      
      Vertices (I1) := (I1, EV, 0.0);
      Vertices (I2) := (I2, EV, 0.0);
      Vertices (I3) := (I3, EV, 0.0);
      Vertices (I4) := (I4, EV, 0.0);      
      
      Vertices (D) := (D, EV, 0.0);
      
      -- add edges between pickup locations and intersections
      Add_Edge (G => Road_Network, E => EP0I1, Source => P0, Destination => I1);
      Add_Edge (G => Road_Network, E => EI4P0, Source => I4, Destination => P0);
      
      Add_Edge (G => Road_Network, E => EP1I2, Source => P1, Destination => I2);
      Add_Edge (G => Road_Network, E => EI1P1, Source => I1, Destination => P1);
      
      Add_Edge (G => Road_Network, E => EP2I3, Source => P2, Destination => I3);
      Add_Edge (G => Road_Network, E => EI2P2, Source => I2, Destination => P2);
      
      Add_Edge (G => Road_Network, E => EP3I4, Source => P3, Destination => I4);
      Add_Edge (G => Road_Network, E => EI3P3, Source => I3, Destination => P3);
      
      Add_Edge (G => Road_Network, E => EP4I1, Source => P4, Destination => I1);
      Add_Edge (G => Road_Network, E => EI4P4, Source => I4, Destination => P4);
      
      Add_Edge (G => Road_Network, E => EP5I2, Source => P5, Destination => I2);
      Add_Edge (G => Road_Network, E => EI1P5, Source => I1, Destination => P5);
      
      Add_Edge (G => Road_Network, E => EP6I3, Source => P6, Destination => I3);
      Add_Edge (G => Road_Network, E => EI2P6, Source => I2, Destination => P6);
      
      Add_Edge (G => Road_Network, E => EP7I4, Source => P7, Destination => I4);
      Add_Edge (G => Road_Network, E => EI3P7, Source => I3, Destination => P7);

      -- add edges between intersections
      Add_Edge (G => Road_Network, E => EI1I2, Source => I1, Destination => I2);
      Add_Edge (G => Road_Network, E => EI2I3, Source => I2, Destination => I3);
      Add_Edge (G => Road_Network, E => EI3I4, Source => I3, Destination => I4);
      Add_Edge (G => Road_Network, E => EI4I1, Source => I4, Destination => I1);

      -- add eges between depot and P1      
      Add_Edge (G => Road_Network, E => EDP0, Source => D, Destination =>  P0);
      Add_Edge (G => Road_Network, E => EP0D, Source => P0, Destination => D);
      
      -- empty edge
      Edges (EE) := 0.0;
      
      -- weights for inner edges
      -- add 0.5 weight for each edge so that Ix -> Iy is prefered to Ix -> Pz -> iy
      Edges (EP0I1) := 50.5;
      Edges (EI4P0) := 50.5;
      Edges (EP1I2) := 50.5;
      Edges (EI1P1) := 50.5;
      Edges (EP2I3) := 50.5;
      Edges (EI2P2) := 50.5;
      Edges (EP3I4) := 50.5;
      Edges (EI3P3) := 50.5;
      
      -- wights for outer edges
      Edges (EP4I1) := 65.0;
      Edges (EI4P4) := 65.0;
      Edges (EP5I2) := 65.0;
      Edges (EI1P5) := 65.0;
      Edges (EP6I3) := 65.0;
      Edges (EI2P6) := 65.0;
      Edges (EP7I4) := 65.0;
      Edges (EI3P7) := 65.0;
      
      -- edges between intersections
      Edges (EI1I2) := 100.0;
      Edges (EI2I3) := 100.0;
      Edges (EI3I4) := 100.0;
      Edges (EI4I1) := 100.0;
      
      -- edges to/from depot
      -- cost for taking I4 -> P0 -> D -> P0 -> I1 needs to be higher than 
      -- taking I4 -> P1 -> I1, otherwise we would take an unecessary detour
      Edges (EP0D) := 55.0;
      Edges (EDP0) := 55.0; 
         end Create_Graph;
            
   procedure Destroy_Graph is
   begin
      Destroy (Road_Network);
   end Destroy_Graph;
   
   -- prepare for Dijkstra
   procedure Clear_Nodes is
      Iter : All_Vertex_Iterator := Iterate_All_Vertices (Road_Network);
      V : VID;
   begin
      while Has_Next (Iter) loop
         Next (Iter, V);
         
         Vertices (V).Pre := EV;
         Vertices (V).Cost := Float'Last;
      end loop;
   end Clear_Nodes;
   
   procedure Put_Nodes is
      Iter : All_Vertex_Iterator := Iterate_All_Vertices (Road_Network);
      V : VID;
   begin
      while Has_Next (Iter) loop
         Next (Iter, V);
         
         Put_Line ("Id: " & V'Image & ", Cost: " & Vertices (V).Cost'Image);
      end loop;
   end Put_Nodes;
   
   procedure Put_Graph is
      V_Iter : All_Vertex_Iterator := Iterate_All_Vertices (Road_Network);
      E_Iter : Outgoing_Edge_Iterator;
      V, W : VID;
      E : EID;
   begin
      while Has_Next (V_Iter) loop
         Next (V_Iter, V);
         
         Put_Line ("Id: " & V'Image);
         
         E_Iter := Iterate_Outgoing_Edges (Road_Network, V);
         
         while Has_Next (E_Iter) loop
            Next (E_Iter, E);
            W := Destination_Vertex (Road_Network, E);
            Put_Line ("    -- " & E'Image & " --> " & W'Image);
         end loop;
         
      end loop;
   end Put_Graph;
      
   procedure Dijkstra (Src, Dst : VID; R : out Route) is
      PQ : Priotity_Q.Implementation.List_Type (32);
      
      Iter : Outgoing_Edge_Iterator;
      Current, V : VID;
      E : EID;
      
      Alt_Cost : Float;
      
      W : Vertex;
   begin
      Clear_Nodes;
      Vertices (Src).Cost := 0.0;
      PQ.Enqueue (Src);
      
      while Integer (PQ.Length) /= 0 loop
         PQ.Dequeue (Current);
         
         Iter := Iterate_Outgoing_Edges (Road_Network, Current);
         while Has_Next (Iter) loop
            Next (Iter, E);
            V := Destination_Vertex (Road_Network, E);
            
            Alt_Cost := Vertices (Current).Cost + Edges (E);
            if Alt_Cost < Vertices (V).Cost then
               Vertices (V).Pre := Current;
               Vertices (V).Cost := Alt_Cost;
               PQ.Enqueue (V);
            end if;
         end loop;
      end loop;
      
      R.Clear;
      W := Vertices (Dst);
      while W.Id /= EV loop
         R.Prepend (W.Id);
         W := Vertices (W.Pre);
      end loop;
      
   end Dijkstra;   
   
   function Vertex_Is_Pickup (V : VID) return Boolean is
   begin
      return VID'Pos (V) > 0 and VID'Pos (V) < 9;
   end Vertex_Is_Pickup;
        
   function In_Order (R : in Route; 
                      F, L : VID) return Boolean is
   begin
      For C of R loop
         if C = F then
            return True;
         end if;
         
         if C = L then
            return False;
         end if;
         
      end loop;
      return False;
   end In_Order;
   
   procedure Replace_All (R : in out Route; 
                          E_Start, E_End : VID; Segment : Route) is
      C_Start : Cursor := R.Find (E_Start);
      C_End : Cursor := R.Find (E_End);
      C : Cursor;
   begin
      for I of Segment loop
         R.Insert (C_Start, I);
      end loop;
      
            
      while Element (C_Start) /= Element (C_End) loop
         C := Next (C_Start);
         R.Delete (C_Start);
         C_Start := C;
      end loop;
      R.Delete (C_End);
   end Replace_All;
   
   procedure Put_Route (R : in Route) is
   begin
      for E of R loop
         Put_Line (E'Image);
      end loop;
   end Put_Route;
   
   procedure Add (R, A : in out Route; Src, Dst : VID) is
      Contains_Src : Boolean := A.Contains (Src);
      Contains_Dst : Boolean := A.Contains (Dst);
      
      C1, C2 : Cursor;
      Copy, Tmp : Route;
      Min : Integer;
      Min_C : Cursor;
      Min_R : Route;
      Start : VID := Position;
      Length : Integer;
   begin
      
      if Contains_Src and Contains_Dst and In_Order (A, Src, Dst) then
         return;
      end if;
      
      if not Contains_Src then
         A.Append (Src);
      end if;
      
      if not Contains_Dst then
         A.Append (Dst);
      end if;
      
      R.Clear;
      Copy := A.Copy;
      C1 := Copy.First;
      Length := Integer (Copy.Length);
            
      for I in 0 .. Length - 1 loop
         C2 := Copy.First;
         Min := Integer'Last;
         
         while Has_Element (C2) loop
            Dijkstra (Start, Element (C2), Tmp);
            if Integer (tmp.Length) < Min then
               Min := Integer (tmp.Length);
               Min_C := C2;
               Min_R := Tmp;
            end if;
            Next (C2);
         end loop;
         
         if Start /= Position then
            R.Delete_Last;
         end if;
                  
         for E of Min_R loop
            R.Append (E);
         end loop;
         
         
         --Next (C1);
         Start := Element (Min_C);
         Copy.Delete (Min_C);
         
      end loop;
   end Add;
   
end Graph;
