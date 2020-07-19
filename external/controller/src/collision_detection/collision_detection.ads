with types; use types;
with Messages; use Messages;

package Collision_Detection is

   type State is (Forward, Right, Left, Passing_Left, Passing_Right);
   Car_State: State;
   function Main(Distance: Messages.Distance_Sensor_Array) return Messages.Velocity_Message;
   Ls, Rs : types.float64 := 0.0;
   Obstacle_Passed : Boolean := False;
   Passing_Obstacle : Boolean := False;

end Collision_Detection;
