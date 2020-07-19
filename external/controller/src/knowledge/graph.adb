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
   
   -- Graph Methods
   
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
   
   procedure Put_Vertices is
      Iter : All_Vertex_Iterator := Iterate_All_Vertices (Road_Network);
      V : VID;
   begin
      while Has_Next (Iter) loop
         Next (Iter, V);
         
         Put_Line ("Id: " & V'Image & ", Cost: " & Vertices (V).Cost'Image);
      end loop;
   end Put_Vertices;
   
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
   
   -- see https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm for reference
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
      case V is
         when EV => return False;
         when I1 => return False;
         when I2 => return False;
         when I3 => return False;
         when I4 => return False;
         when D => return False;
         when others => return True;
      end case;
   end Vertex_Is_Pickup;
   
   function Vertex_Is_Intersection (V : VID) return Boolean is
   begin
      case V is
         when I1 => return True;
         when I2 => return True;
         when I3 => return True;
         when I4 => return True;
         when others => return False;
      end case;
   end Vertex_Is_Intersection;
      
   function Vertex_Is_Outer (V : VID) return Boolean is
   begin
      case V is
         when P4 => return True;
         when P5 => return True;
         when P6 => return True;
         when P7 => return True;
         when others => return False;
      end case;
   end Vertex_Is_Outer;
      
   -- returns wether V is on the outer edge
   function Vertex_Is_Inner (V : VID) return Boolean is
   begin
      case V is
         when P0 => return True;
         when P1 => return True;
         when P2 => return True;
         when P3 => return True;
         when others => return False;
      end case;
   end Vertex_Is_Inner;
   
   function Get_Inner_Sibling (V : VID) return VID is
   begin
      case V is
         when P4 => return P0;
         when P5 => return P1;
         when P6 => return P2;
         when P7 => return P3;
         when others => return V;
      end case;
   end Get_Inner_Sibling;
   
   -- compare values of vertecies V and W given the current position Start
   -- for every inner/outer pair of pickup locations the outcome is the same
   -- only edge case when Start = D and V or W is P4
   -- if V, W are an inner/outer pair the return value is false as no before-after
   -- relationship can be made
   function Vertex_Comes_Before (V, W, Start : VID) return Boolean is
      VI : VID := Get_Inner_Sibling (V);
      WI : VID := Get_Inner_Sibling (W);
      SI : VID := Get_Inner_Sibling (Start);
   begin      
      -- edge case
      if Start = D and V = P4 then
         return False;
      elsif Start = D and W = P4 then
         return True;
      end if;
            
      if V = Start then 
         return True;
      end if;
      
      if WI = Start then
         return False;
      end if;
            
      if V = W then
         return True;
      end if;
            
      if VI > SI and WI > SI then
         if WI > VI then
            return True;
         end if;
         return False;
      end if;
      
      if VI < SI and WI < SI then
         if VI < WI then
            return True;
         end if;
         return False;
      end if;
      
      -- VI and SI are outer/inner siblings and therefore VI can't come before WI
      if VI = SI then
         return False;
      end if;
      
      -- WI and SI are outer/inner siblings and therefore WI can't come before VI
      if WI = SI then
         return True;
      end if;
                  
      return False;
   end Vertex_Comes_Before;
         
   -- Route Methods
        
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
   
   -- expects A to be list of only pickup locations which the cab drives to
   -- expects A to be ordered
   -- inserts Src and Dst into A and preserves the ordering
   -- uses Dijkstra to calculate the shortest path between each i and i+1 in A
   -- starting with i is the current position
   procedure Add_To_Route (R, A : in out Route; Src, Dst, Position : VID) is
      Contains_Src : Boolean := A.Contains (Src);
      Contains_Dst : Boolean := A.Contains (Dst);
      
      C : Cursor;
      Index : Integer := 0;
      Copy, Tmp : Route;
      W, Start : VID := Position;
      Length : Integer := Integer (A.Length);
   begin
      
      if Contains_Src and Contains_Dst and In_Order (A, Src, Dst) then
         return;
      end if;
      
      C := A.First;
      W := Position;
      if not Contains_Src and Src /= Position then
         for I in 0 .. Length - 1 loop
            if Vertex_Comes_Before (Src, Element (C), W) then
               exit;
            else   
               if Element (C) = Dst then
                  Contains_Dst := False;
               end if;
               
               Copy.Append (Element (C));
               W := Element (C);
               Next (C);
               Index := Index + 1;
            end if;
         end loop;
         
         Copy.Append (Src);
         W := Src;
      end if;
      
      if not Contains_Dst then
         for I in Index .. Length - 1 loop
            if Vertex_Comes_Before (Dst, Element (C), W) then
               exit;
            else
               Copy.Append (Element (C));
               W := Element (C);
               Next (C);
               Index := Index + 1;
            end if;
         end loop;
      
         Copy.Append (Dst);
      end if; 
            
      for I in Index .. Length - 1 loop
         Copy.Append (Element (C));
         Next (C);
      end loop;
            
      A.Clear;
      A.Move (Copy);
      
      R.Clear;
      Length := Integer (A.Length);
      C := A.First;
      
      for I in 0 .. Length - 1 loop
         Dijkstra (Start, Element (C), Tmp);
         
         Tmp.Delete_First;
         for E of Tmp loop
            R.Append (E);
         end loop;
         
         Start := Element (C);
         Next (C);
      end loop;
      
   end Add_To_Route;
   
end Graph;
