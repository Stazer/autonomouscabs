// File:          controller.cpp
// Author:        Henrik Classen

#include "robot_container.hpp"

// All the webots classes are defined in the "webots" namespace
using namespace webots;

int main(int argc, char **argv) 
{
  if(argc != 2)
  {
    std::cerr << "port missing" << std::endl;
    return EXIT_FAILURE;
  }
  
  robot_container container;
  container.wait_for_connection(argv[1]);
  container.setup_robot(8);
  container.run();
  return 0;
}
