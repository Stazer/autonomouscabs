with Ada.Text_IO; use Ada.Text_IO;

with Types; use Types;

package body Memory is

   procedure Handle_Join (Message : Messages.JS_Message_Ptr) is
   begin
      if Join_Successful = True then
         return;
      end if;
      Put_Line ("Cab id: " & Message.Cab_Id'Image);
      
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
   begin
      begin
         Src := Graph.VID'Enum_Val(Message.Src);
         Dst := Graph.VID'Enum_Val(Message.Dst);
         Put_Line ("New request " & Src'Image & " -> " & Dst'Image);
      exception 
         when E : Constraint_Error => 
            Success := Success and False;
      end;
      
      if Success then
         Graph.Add_To_Route (My_Route, My_Pickups, Src, Dst, Position);
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
   begin
      Position := My_Route.First_Element;
      My_Route.Delete_First;
      
      Update := Messages.Position_Update_Message_Create 
        (Types.Uint8 (Graph.VID'Enum_Rep (My_Route.First_Element)));
      return Update;
   end Update_Position;
   
   function Next_Action return Action is
      First : Graph.VID := My_Route.First_Element;
   begin
      if Graph.Vertex_Is_Intersection (Position) then
         if Graph.Vertex_Is_Intersection (First) then
            return RIGHT;
         end if;
         
         if Turned_Right then
            Turned_Right := False;
            return STOP;
         end if;
                  
         if Behind_Intersection then
            Behind_Intersection := False;
            Turned_Right := True;
            return RIGHT;
         else
            Behind_Intersection := True;
            if Graph.Vertex_Is_Inner (First) then
               return RIGHT;
            elsif Graph.Vertex_Is_Outer (First) then
               return STRAIGHT;
            end if;
         end if;
         
      elsif Graph.Vertex_Is_Pickup (Position) then
         if Turned_Left then
            Turned_Left := False;
            return STRAIGHT;
         end if;
         
         Turned_Left := True;
         return LEFT;
      elsif Position = Graph.D then
         return LEFT;
      end if;
            
      return NOTHING;
   end Next_Action;
   

end Memory;
