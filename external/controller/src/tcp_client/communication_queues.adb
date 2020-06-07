package body communication_queues is

   function Get_Priority (Element : Communication_Packet) return Natural is
   begin
      return Element.Priority;
   end Get_Priority;

   function Before (Left, Right : Natural) return Boolean is
   begin
      return Left > Right;
   end Before;

end communication_queues;
