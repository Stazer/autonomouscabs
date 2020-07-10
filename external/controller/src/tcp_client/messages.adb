package body Messages is

   function Velocity_Message_Create (Left_Speed, Right_Speed : in Types.Float64)
                                     return Velocity_Message is
   begin
      return (Size => 21, Id => WEBOTS_VELOCITY, Left_Speed => Left_Speed, Right_Speed => Right_Speed);
   end Velocity_Message_Create;

   function Join_Challenge_Message_Create return Join_Challenge_Message is
   begin
      return (Size => 5, Id => BACKEND_JOIN_CHALLENGE);
   end Join_Challenge_Message_Create;

end Messages;
