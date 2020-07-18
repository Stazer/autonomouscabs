with Messages;
with Graph; use type Graph.VID;
with Types;

package Memory is
   
   type Action is (NOTHING, STOP, LEFT, RIGHT, STRAIGHT);
   
   procedure Handle_Join (Message : Messages.JS_Message_Ptr);
   procedure Handle_Disconnect;
   
   function Add_Request (Message : Messages.AR_Message_Ptr) 
                         return Messages.Route_Update_Message;
   function Update_Position return Messages.Position_Update_Message;
   function Next_Action return Action;
   
private
   
   Join_Successful : Boolean := False;
   Backend_Disconnected : Boolean := True;
   
   Id : Types.Uint32;
   
   My_Route : Graph.Route;
   My_Pickups : Graph.Route;
   Position : Graph.VID := Graph.D;
   
   Behind_Intersection : Boolean := False;
   Turned_Right : Boolean := False;
   Turned_Left : Boolean := False;

end Memory;
