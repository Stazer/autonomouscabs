package body Messages is

   function Velocity_Message_Create (Left_Speed, Right_Speed : in Types.Float64)
                                     return Velocity_Message is
   begin
      return (Size => 21, Id => WEBOTS_VELOCITY,
              Left_Speed => Left_Speed, Right_Speed => Right_Speed);
   end Velocity_Message_Create;

   function Join_Challenge_Message_Create return Join_Challenge_Message is
   begin
      return (Size => 5, Id => BACKEND_JOIN_CHALLENGE);
   end Join_Challenge_Message_Create;

   function Position_Update_Message_Create (Position : Types.Uint8)
                                            return Position_Update_Message is
   begin
      return (Size => 6, Id => BACKEND_POSITION_UPDATE, Position => Position);
   end Position_Update_Message_Create;

   function Route_Update_Message_Create (Route : Types.Payload_Ptr)
                                         return Route_Update_Message is
   begin
      return (Size => 5 + Route'Length, Id => BACKEND_ROUTE_UPDATE, Route => Route);
   end Route_Update_Message_Create;

end Messages;
