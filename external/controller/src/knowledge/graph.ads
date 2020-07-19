with GNAT.Graphs;
with Ada.Containers.Synchronized_Queue_Interfaces;
with Ada.Containers.Bounded_Priority_Queues;
with Ada.Containers.Indefinite_Doubly_Linked_Lists;

package Graph is
   
   -- all vertices in the graph
   -- EV stands for an empty Vertex
   type VID is (EV, D, P0, I1, P1, I2, P2, I3, P3, I4, P4, P5, P6, P7);
   
   -- all edges in the graph
   -- EE stands for an empty edge
   type EID is (EE, EP0I1, EI4P0, EP1I2, EI1P1, EP2I3, EI2P2, EP3I4, EI3P3, EP4I1, 
                EI4P4, EP5I2, EI1P5, EP6I3, EI2P6, EP7I4, EI3P7, EI1I2, EI2I3, 
                EI3I4, EI4I1, EDP0, EP0D);
   
   -- set up the graph and all data structures according to our environment
   procedure Create_Graph;
   
   -- free memory used by graph
   procedure Destroy_Graph;
   
   -- print out all Vertices
   procedure Put_Vertices;
   
   -- print out the graoh
   procedure Put_Graph;
   
   function Same_Vertex (V, W : VID) return Boolean;
   function Same_Edge (E, F : EID) return Boolean;
   
   package VID_List is new Ada.Containers.Indefinite_Doubly_Linked_Lists
     (Element_Type => Graph.VID, "=" => Graph.Same_Vertex);
   use VID_List;
   
   subtype Route is VID_List.List;
   
   -- replaces all elements between E_Start and E_End (inclusive) with the Elements in Segment
   procedure Replace_All (R : in out Route; 
                          E_Start, E_End : VID; Segment : Route);
   
   -- checks wether F comes before L in R
   function In_Order (R : in Route; 
                      F,L : VID) return Boolean;
   
   -- add stops at Src and Dst to route, R is the actual route, A contains only the stops
   -- R = {e | e in VID}, A = {e | e in VID and e > EV and e < I1}
   procedure Add_To_Route (R, A : in out Route; Src, Dst, Position : VID);
   
   -- Dijkstra algorithm, puts shortest path between Src and Dst in R
   procedure Dijkstra (Src, Dst : VID; R : out Route);
   
   -- returns wether V is a pickup location
   function Vertex_Is_Pickup (V : VID) return Boolean;
   
   -- returns wether V is a intersection
   function Vertex_Is_Intersection (V : VID) return Boolean;
   
   -- returns wether V is on the outer edge
   function Vertex_Is_Outer (V : VID) return Boolean;
   
   -- returns wether V is on the inner edge
   function Vertex_Is_Inner (V : VID) return Boolean;
   
   -- return wether V comes before W given position Start
   function Vertex_Comes_Before (V, W, Start : VID) return Boolean;
      
private
   
   -- only used in Dijkstra algorithm
   -- keep track of current cost to get to node and predecessor
   type Vertex is record
      Id : VID;
      Pre : VID;
      Cost : Float;
   end record;
      
   function Hash_Vertex (V : VID) return GNAT.Bucket_Range_Type;
   function Hash_Edge (E : EID) return GNAT.Bucket_Range_Type;
   
   package Road_Graph is new GNAT.Graphs.Directed_Graphs
     (Vertex_Id => VID, No_Vertex => EV, Hash_Vertex => Hash_Vertex,
      Same_Vertex => Same_Vertex, Edge_Id => EID, No_Edge => EE,
      Hash_Edge => Hash_Edge, Same_Edge => Same_Edge);
   use Road_Graph;
   
   Road_Network : Road_Graph.Directed_Graph;
   
   type Vertex_Array is array (VID'Range) of Vertex;
   type Edge_Array is array (EID'Range) of Float;
   
   -- store information about vertices
   Vertices : Vertex_Array;
   
   -- store weights of edges
   Edges : Edge_Array;
   
   -- data structure for Dijkstra
   function Get_Priority (V : VID) return Float;
   function Before (V, W : Float) return Boolean;
   
   package Q is new Ada.Containers.Synchronized_Queue_Interfaces 
     (Element_Type => VID);
   use Q;
   
   package Priotity_Q is new Ada.Containers.Bounded_Priority_Queues
     (Queue_Interfaces => Q,
      Queue_Priority   => Float,
      Get_Priority     => Get_Priority,
      Before           => Before,
      Default_Capacity => 23,
      Default_Ceiling  => 1);
   use Priotity_Q;
   
end Graph;
