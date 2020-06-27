with types;use types;

package collision_detection is

   type State is (Forward, Right, Left, Get_back_Left);
   type Dtype is array(0..8) of float64;
   car_state: State;
   procedure detect(distance: Dtype);

end collision_detection;
