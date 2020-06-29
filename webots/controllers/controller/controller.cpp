 // File:          controller.cpp
// Author:        Henrik Classen
#include <pthread.h>
#include <cstdlib>
#include <iostream>
#include <boost/smart_ptr.hpp>
#include <boost/asio.hpp>
#include <boost/endian/conversion.hpp>

#include <webots/Robot.hpp>
#include <webots/Motor.hpp>
#include <webots/Camera.hpp>
#include <webots/DistanceSensor.hpp>
#include <webots/LightSensor.hpp>

#include "../../../shared/buffer.hpp"
#include "../../../shared/buffer_reader.hpp"
#include "../../../shared/buffer_writer.hpp"
#include "../../../shared/message.hpp"

#define N_DISTANCE_SENSORS 9
#define N_LIGHT_SENSORS 1

// All the webots classes are defined in the "webots" namespace
using namespace webots;

int main(int argc, char **argv) 
{
  if(argc != 2)
  {
    std::cerr << "port missing" << std::endl;
    return EXIT_FAILURE;
  }
  
  // setup server socket
  using boost::asio::ip::tcp;
  boost::asio::io_service io_service;
  tcp::socket client(io_service);
  try
  {
    tcp::acceptor acceptor(io_service, tcp::endpoint(tcp::v4(), std::atoi(argv[1])));
    acceptor.accept(client);
  }
  catch(std::exception& e)
  {
    std::cerr << "Exception: " << e.what() << "\n";
    return EXIT_FAILURE;
  } 
  
  Robot *robot = new Robot();

  // get the time step of the current world.
  int timeStep = (int) robot->getBasicTimeStep();

  // setup distance sensors
  std::cout << "setting up sensors" << std::endl;
  std::string ds_names[N_DISTANCE_SENSORS] = {"ds_fc", "ds_fcr", "ds_fr", "ds_rf", "ds_rc", "ds_lc", "ds_lf", "ds_fl", "ds_fcl"};
  DistanceSensor *ds_sensors[N_DISTANCE_SENSORS];
  for(int i = 0; i<N_DISTANCE_SENSORS; i++)
  {
    ds_sensors[i] = robot->getDistanceSensor(ds_names[i]);
    ds_sensors[i]->enable(timeStep);
  }

  // setup light sensors
  std::string ls_names[N_LIGHT_SENSORS] = {"ls_front"};
  LightSensor *ls_sensors[N_LIGHT_SENSORS];
  for(int i = 0; i<N_LIGHT_SENSORS; i++)
  {
    ls_sensors[i] = robot->getLightSensor(ls_names[i]);
    ls_sensors[i]->enable(timeStep);
  }

  // setup camera
  Camera *camera = robot->getCamera("camera");
  camera->enable(timeStep);
  int image_height = camera->getHeight();
  int image_width = camera->getWidth();
  int image_size = image_width * image_height * 4  * sizeof(unsigned char);

  // setup motors
  std::string m_names[4] = {"wheelFR", "wheelRR", "wheelRL", "wheelFL"};
  Motor *m_motors[4];
  for(int i = 0; i<4; i++)
  {
    m_motors[i] = robot->getMotor(m_names[i]);
    m_motors[i]->setPosition(INFINITY);
    m_motors[i]->setVelocity(0);
  }
  double left_speed = 0;
  double right_speed = 0;

  robot->step(timeStep);
  camera->saveImage("picture.png", 100);

  buffer in;
  buffer_reader reader(in);
  while (robot->step(timeStep) != -1) 
  {
    // read distance sensor data
    external_distance_sensor_message ds_msg;
    for(int i = 0; i<N_DISTANCE_SENSORS; i++)
    {
      ds_msg.data[i] = ds_sensors[i]->getValue();
    }

    // read light sensor data
    external_light_sensor_message ls_msg;
    for(int i = 0; i<N_LIGHT_SENSORS; i++)
    {
      ls_msg.data[i] = ls_sensors[i]->getValue();
    }

    // read image data
    external_image_data_message img_msg;
    const unsigned char *image = camera->getImage();
    std::vector<unsigned char> vec(image, image + image_size);
    img_msg.pixel = vec;

    try
    {
      buffer out;
      buffer_writer writer(out);
      writer << ds_msg << ls_msg << img_msg; 
      boost::asio::write(client, boost::asio::buffer(out));
    }
    catch(std::exception& e)
    {
      std::cerr << "Exception: " << e.what() << std::endl;
      break;
    }  

    if(client.available() < 1)
    {
      continue;
    }
    std::array<std::uint8_t, 256> data;
    boost::system::error_code error;
    size_t length = client.read_some(boost::asio::buffer(data), error);
    if(error == boost::asio::error::eof)
    {
      break;
    }
    else if (error)
    {
      std::cerr << "Error: " << error << std::endl;
      break;
    }

    buffer_writer writer(in);
    writer << data;

    if(length != sizeof(message_size) + sizeof(message_id))
    {
      continue;
    }

    try
    {
      webots_velocity_message vl_msg;
      reader >> vl_msg;
      right_speed = vl_msg.right_speed;
      left_speed = vl_msg.left_speed;
    }
    catch(const std::runtime_error& e)
    {
      std::cerr << e.what() << '\n';
    }
    // std::cout << "right_speed: " << right_speed << ", left_speed: " << left_speed << std::endl;

    m_motors[0]->setVelocity(right_speed);
    m_motors[1]->setVelocity(right_speed);
    m_motors[2]->setVelocity(left_speed);
    m_motors[3]->setVelocity(left_speed);
  };
  
  for(int i = 0; i<4; i++)
  {
    m_motors[i]->setVelocity(0);
  }

  // Enter here exit cleanup code.
  client.close(); 
  delete robot;
  return 0;
}
