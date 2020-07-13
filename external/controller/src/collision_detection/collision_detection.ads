with types;use types;
with Messages; use Messages;

package Collision_Detection is

   type State is (Forward, Right, Left);
   car_state: State;
   function Main(Distance: Messages.Distance_Sensor_Array) return Messages.Velocity_Message;
   ls, rs : types.float64 := 0.0;

end Collision_Detection;
