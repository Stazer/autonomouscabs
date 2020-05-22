#include <webots/distance_sensor.h>
#include <webots/motor.h>
#include <webots/robot.h>
#define TIME_STEP 64
int main(int argc, char **argv) {
  wb_robot_init();
  int i;
  bool avoid_obstacle_counter = 0;
  WbDeviceTag ds[3];
  char ds_names[3][7] = {"ds_fl", "ds_fc", "ds_fr"};
  for (i = 0; i < 3; i++) {
    ds[i] = wb_robot_get_device(ds_names[i]);
    wb_distance_sensor_enable(ds[i], TIME_STEP);
  }
  WbDeviceTag wheels[4];
  char wheels_names[4][9] = {"wheelFL", "wheelFR", "wheelRL", "wheelRR"};
  for (i = 0; i < 4; i++) {
    wheels[i] = wb_robot_get_device(wheels_names[i]);
    wb_motor_set_position(wheels[i], INFINITY);
  }
  while (wb_robot_step(TIME_STEP) != -1) {
    double left_speed = 4.0;
    double right_speed = 4.0;
    if (avoid_obstacle_counter > 0) {
      avoid_obstacle_counter--;
      left_speed = 2.0;
      right_speed = -2.0;
    } else { // read sensors
      double ds_values[3];
      for (i = 0; i < 3; i++)
        ds_values[i] = wb_distance_sensor_get_value(ds[i]);
      if (ds_values[0] < 500.0 || ds_values[1] < 500.0 || ds_values[2] < 500.0)
        avoid_obstacle_counter = 100;
    }
    wb_motor_set_velocity(wheels[0], left_speed);
    wb_motor_set_velocity(wheels[1], right_speed);
    wb_motor_set_velocity(wheels[2], left_speed);
    wb_motor_set_velocity(wheels[3], right_speed);
  }
  wb_robot_cleanup();
  return 0;  // EXIT_SUCCESS
}