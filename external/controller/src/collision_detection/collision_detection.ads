with types;use types;
with Messages; use Messages;

package Collision_Detection is

   type State is (Forward, Right, Left, Passing_Left,Passing_Right);
   car_state: State;
   function Main(Distance: Messages.Distance_Sensor_Array) return Messages.Velocity_Message;
   ls, rs : types.float64 := 0.0;
   threshold_d3: types.Float64 := 0.0;
   threshold_d4: types.Float64 := 0.0;
   threshold_d5: types.Float64 := 0.0;
   threshold_d6: types.Float64 := 0.0;
   left_obstacle : Boolean := False;
   can_turn : Boolean := False;



end Collision_Detection;
