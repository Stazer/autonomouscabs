package collision_detection is
   
   type Dtype is array(0..2) of Integer;
   type State is (Forward, Right, Left);
   car_state: State;
   procedure collision_detection_main;
   procedure detect(distance: dtype);
   
end collision_detection;
