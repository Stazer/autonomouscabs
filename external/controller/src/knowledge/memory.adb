with Ada.Text_IO; use Ada.Text_IO;
with Types; use Types;

package body Memory is

   procedure Handle_Join (Message : Messages.JS_Message_Ptr) is
   begin
      if Join_Successful = True then
         return;
      end if;
      
      Join_Successful := True;
      Id := Message.Cab_Id;
      Graph.Create_Graph;
   end Handle_Join;
   
   procedure Handle_Disconnect is
      Last : Graph.VID := Position;
   begin
      if not My_Route.Is_Empty then
         Last := My_Route.Last_Element;
      end if;
      
      Graph.Add_To_Route (My_Route, My_Pickups, Last, Graph.D, Position);
      Join_Successful := False;
   end Handle_Disconnect;
   
   function Add_Request (Message : Messages.AR_Message_Ptr) return Messages.Route_Update_Message is
      Update : Messages.Route_Update_Message;
      Payload : Types.Payload_Ptr;
      Index : Types.Uint32 := 1;
      Src, Dst : Graph.VID;
      Success : Boolean := Join_Successful;
      Dummy : Graph.Route;
   begin
      begin
         Src := Graph.VID'Enum_Val(Message.Src);
         Dst := Graph.VID'Enum_Val(Message.Dst);
      exception 
         when E : Constraint_Error => 
            Success := Success and False;
      end;
      
      if Success then
         Graph.Add_To_Route (My_Route, My_Pickups, Src, Dst, Position);
         Graph.Add_To_Route (Route_To_Depot, Dummy, My_Route.Last_Element, Graph.D, Position); 
      end if;
      
      Payload := new Types.Payload (1 .. Types.Uint32 (My_Route.Length));
      for I of My_Route loop
         Payload (Index) := Types.Uint8 (Graph.VID'Enum_Rep(I));
         Index := Index + 1;
      end loop;
      Update := Messages.Route_Update_Message_Create (Payload);
      return Update;
   end Add_Request;
   
   function Update_Position return Messages.Position_Update_Message is
      Update : Messages.Position_Update_Message;
      Next : Graph.VID;
   begin
      if Integer (My_Route.Length) > 0 then
         Position := My_Route.First_Element;
         My_Route.Delete_First;
      end if;
      
      if Integer (My_Route.Length) > 0 then
         Next := My_Route.First_Element;
      else
         My_Route := Route_To_Depot;
      end if;
            
      Update := Messages.Position_Update_Message_Create 
        (Types.Uint8 (Graph.VID'Enum_Rep (Next)));
      return Update;
   end Update_Position;
   
   function Next_Action return Action is
      First : Graph.VID := (if Integer (My_Route.Length) > 0 then My_Route.First_Element else Position);
   begin
      if Graph.Vertex_Is_Intersection (Position) then
         if Behind_Intersection then
            if Graph.Vertex_Is_Inner (First) then
               return RIGHT;
            else
               return STRAIGHT;
            end if;
         else
            Behind_Intersection := True;
            if Graph.Vertex_Is_Intersection (First) or
              Graph.Vertex_Is_Inner (First) then
               return RIGHT;
            elsif Graph.Vertex_Is_Outer (First) then
               return STRAIGHT;
            end if;
         end if;
      elsif Graph.Vertex_Is_Pickup (Position) then
         Behind_Intersection := False;
         if First = Graph.D then
            return RIGHT;
         elsif Position /= First then
            return STRAIGHT;
         end if;
      elsif Position = Graph.D then
         return STRAIGHT;
      end if;
            
      return NOTHING;
   end Next_Action;
   
   procedure Put_Route is
   begin
      Put_Line ("current position: " & Position'Image);
      for E of My_Route loop
         Put_Line ("next: " & E'Image);
      end loop;
   end Put_Route;

end Memory;
