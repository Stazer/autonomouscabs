// File:          controller.cpp
// Author:        Henrik Classen

#include <cstdlib>
#include <iostream>
#include <boost/bind/bind.hpp>
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

#define N_DISTANCE_SENSORS 9
#define N_LIGHT_SENSORS 1

// All the webots classes are defined in the "webots" namespace
using namespace webots;

using boost::asio::ip::tcp;

typedef enum message_id{
  OUT_MESSAGE_DISTANCE_SENSOR = 1,
  OUT_MESSAGE_LIGHT_SENSOR = 2,
  OUT_MESSAGE_IMAGE = 3,
  IN_MESSAGE_VELOCITY = 4,
  IN_MESSAGE_STEERING = 5,
}message_id;

typedef struct ds_message{
  uint32_t id;
  uint32_t size;
  uint64_t payload[N_DISTANCE_SENSORS];
}ds_message;

typedef struct ls_message{
  uint32_t id;
  uint32_t size;
  uint64_t payload[N_LIGHT_SENSORS];
}ls_message;

typedef struct img_message{
  uint32_t id;
  uint32_t size;
  unsigned char payload[];
}img_message;

ds_message marshall_ds_message(double payload[N_DISTANCE_SENSORS]){
  ds_message message = {0};
  uint32_t id = OUT_MESSAGE_DISTANCE_SENSOR;
  message.id = boost::endian::native_to_big(id);
  message.size = boost::endian::native_to_big((uint32_t) (N_DISTANCE_SENSORS * sizeof(uint64_t)));
  for(int i = 0; i<N_DISTANCE_SENSORS; i++){
    message.payload[i] = *(uint64_t *) &payload[i];
    message.payload[i] = boost::endian::native_to_big(message.payload[i]);
  }
  return message;
}

ls_message marshall_ls_message(double payload[N_LIGHT_SENSORS]){
  ls_message message = {0};
  uint32_t id = OUT_MESSAGE_LIGHT_SENSOR;
  message.id = boost::endian::native_to_big(id);
  message.size = boost::endian::native_to_big((uint32_t) (N_LIGHT_SENSORS * sizeof(uint64_t)));
  for(int i = 0; i<N_LIGHT_SENSORS; i++){
    message.payload[i] = *(uint64_t *) &payload[i];
    message.payload[i] = boost::endian::native_to_big(message.payload[i]);
  }
  return message;
}

img_message *img_message_prepare(uint32_t size){
  img_message *message = (img_message *) malloc(sizeof(img_message) + size);
  if(message == NULL){
    std::cerr << "failed to allocate memory" << std::endl;
    return NULL;
  }
  
  uint32_t id = OUT_MESSAGE_IMAGE;
  message->id = boost::endian::native_to_big(id);
  message->size = boost::endian::native_to_big(size);
  return message;
}

void unmarshall_incoming_message(buffer_reader reader, double *right_speed, double *left_speed){
    uint32_t id = 0, size = 0;
    uint64_t payload = 0;
    reader >> id;
    reader >> size;
    reader >> payload;

    id = boost::endian::big_to_native(id);
    size = boost::endian::big_to_native(size);
    payload = boost::endian::big_to_native(payload);

    if(id == IN_MESSAGE_VELOCITY){
      *left_speed =  *left_speed < 0 ? -(*(double *) &payload) : *(double *) &payload;
      *right_speed = *right_speed < 0 ? -(*(double *) &payload) : *(double *) &payload;
    }

    if(id == IN_MESSAGE_STEERING){
      double value = *(double *) &payload;
      if(value < 0){
        (*left_speed) *= value;
        *right_speed = *right_speed < 0 ? -(*right_speed) : *right_speed;
      }

      if(value > 0){
        (*right_speed) *= -value;
        *left_speed = *left_speed < 0 ? -(*left_speed) : *left_speed;
      }

      if(value == 0 && *right_speed != *left_speed){
        *right_speed = *right_speed < 0 ? -(*right_speed) : *right_speed;
        *left_speed = *left_speed < 0 ? -(*left_speed) : *left_speed;
      }
    }
    
    std::cout << "left: " << *left_speed << ", right: " << *right_speed << std::endl;
}

boost::shared_ptr<tcp::socket> server(boost::asio::io_service& io_service, unsigned short port){
  tcp::acceptor acceptor(io_service, tcp::endpoint(tcp::v4(), port));
  boost::shared_ptr<tcp::socket> client(new tcp::socket(io_service));
  acceptor.accept(*client);
  return client;
}

int main(int argc, char **argv) {
  if(argc != 2){
    std::cerr << "port missing" << std::endl;
    return EXIT_FAILURE;
  }
  
  // setup server socket
  boost::shared_ptr<tcp::socket> client = NULL;
  try{
    boost::asio::io_service io_service;
    client = server(io_service, std::atoi(argv[1]));
  }catch(std::exception& e){
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
  for(int i = 0; i<N_DISTANCE_SENSORS; i++){
    ds_sensors[i] = robot->getDistanceSensor(ds_names[i]);
    ds_sensors[i]->enable(timeStep);
  }

  // setup light sensors
  std::string ls_names[N_LIGHT_SENSORS] = {"ls_front"};
  LightSensor *ls_sensors[N_LIGHT_SENSORS];
  for(int i = 0; i<N_LIGHT_SENSORS; i++){
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
  for(int i = 0; i<4; i++){
    m_motors[i] = robot->getMotor(m_names[i]);
    m_motors[i]->setPosition(INFINITY);
    m_motors[i]->setVelocity(0);
  }
  double left_speed = 0;
  double right_speed = 0;

  // setup img_message (allocate memory once)
  img_message *img_msg = img_message_prepare(image_size);
  if(img_msg == NULL){
    client->close();
    delete robot;
    return EXIT_FAILURE;
  }

  buffer incoming;
  const size_t size = 2 * sizeof(uint32_t) + sizeof(uint64_t);
  while (robot->step(timeStep) != -1) {
    // read distance sensor data
    double ds_values[N_DISTANCE_SENSORS];
    for(int i = 0; i<N_DISTANCE_SENSORS; i++){
      ds_values[i] = ds_sensors[i]->getValue();
    }
    ds_message ds_msg = marshall_ds_message(ds_values);
    boost::asio::write(*client, boost::asio::buffer(&ds_msg, sizeof(ds_message)));

    // read light sensor data
    double ls_values[N_LIGHT_SENSORS];
    for(int i = 0; i<N_LIGHT_SENSORS; i++){
      ls_values[i] = ls_sensors[i]->getValue();
    }
    ls_message ls_msg = marshall_ls_message(ls_values);
    boost::asio::write(*client, boost::asio::buffer(&ls_msg, sizeof(ls_message)));

    // read image data
    const unsigned char *image = camera->getImage();
    memcpy(img_msg->payload, image, image_size); 
    boost::asio::write(*client, boost::asio::buffer(&img_msg, sizeof(img_message) + image_size));
    
    if(client->available() < 1){
      continue;
    }
    uint8_t data[size] = {0};
    boost::system::error_code error;
    size_t length = client->read_some(boost::asio::buffer(data), error);
    if(error == boost::asio::error::eof){
      break;
    }else if (error){
      std::cerr << "Error: " << error << std::endl;
      break;
    }

    buffer_writer writter(incoming);
    for(auto part : data){
      writter << part;
    }

    if(length != size){
      continue;
    }

    buffer_reader reader(incoming);
    unmarshall_incoming_message(reader, &right_speed, &left_speed);
    incoming.clear();
    // std::cout << "right_speed: " << right_speed << ", left_speed: " << left_speed << std::endl;

    m_motors[0]->setVelocity(right_speed);
    m_motors[1]->setVelocity(right_speed);
    m_motors[2]->setVelocity(left_speed);
    m_motors[3]->setVelocity(left_speed);
  };
  
  for(int i = 0; i<4; i++){
    m_motors[i]->setVelocity(0);
  }

  // Enter here exit cleanup code.
  client->close();
  free(img_msg);
  delete robot;
  return 0;
}
