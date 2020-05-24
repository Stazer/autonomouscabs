// File:          controller.cpp
// Author:        Henrik Classen

#ifdef _WIN32
  #include <winsock.h>
#else
  #include <arpa/inet.h>
  #include <netdb.h>
  #include <netinet/in.h>
  #include <sys/socket.h>
  #include <sys/time.h>
  #include <unistd.h>
  #include <errno.h>
#endif

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

void close_socket(int sock){
  if(sock < 0){
    return;
  }

#ifdef _WIN32
  closesocket(sock);
#else
  close(sock);
#endif
}

int create_socket(int port){
  int err = 0;
#ifdef _WIN32
  WSADATA info;
  err = WSAStartup(MAKEWORD(1, 1), &info);
  if(err != 0){
    std::cerr << "cannot initialize Winsock" << std::endl;
    return -1;
  }
#endif

  int sock = socket(AF_INET, SOCK_STREAM, 0);
  if(sock < 0){
    std::cerr << "cannot create socket" << std::endl;
    return -1;
  }

  sockaddr_in hints;
  memset(&hints, 0, sizeof(sockaddr_in));
  hints.sin_family = AF_INET;
  hints.sin_port = htons(port);
  hints.sin_addr.S_un.S_addr = INADDR_ANY;

  err = bind(sock, (sockaddr *) &hints, sizeof(sockaddr));
  if(err != 0){
    close_socket(sock);
    std::cerr << "cannot bind socket" << std::endl;
    return -1;
  }

  err = listen(sock, 1);
  if(err != 0){
    close_socket(sock);
    std::cerr << "cannot listen on socket" << std::endl;
    return -1;
  }

  return sock;
}

int accept_client(int server) {
#ifdef _WIN32
  int asize;
#else
  socklen_t asize;
#endif
  asize = sizeof(struct sockaddr_in);
  
  int client;
  struct sockaddr_in addr;

  client = accept(server, (struct sockaddr *) &addr, &asize);
  if (client == -1) {
    std::cerr << "cannot accept external controller connection" << std::endl;
    return -1;
  }
  return client;
}

int is_socket_error(int error){
#ifdef _WIN32
    if(error == SOCKET_ERROR){
      return 1;
    }
#else
    if(error == -1){
      return 1;
    }
#endif

  return 0;
}

uint64_t host_to_net_64(uint64_t val){
  int num = 1;
  /* check endianness */
  if(*(char *) &num != 1){
    /* already big endian */
    return val;
  }

  /* convert to big endian */
  uint32_t high = htonl((uint32_t) ((uint64_t) val >> 32));
  uint32_t low = htonl((uint32_t) val & 0xFFFFFFFFLL);
  return (uint64_t) low << 32 | high;
}

uint64_t net_to_host_64(uint64_t val){
  int num = 1;
  /* check endianness */
  if(*(char *) &num != 1){
    /* already big endian */
    return val;
  }

  /* convert to little endian */
  uint32_t high = ntohl((uint32_t) ((uint64_t) val >> 32));
  uint32_t low = ntohl((uint32_t) val & 0xFFFFFFFFLL);
  return (uint64_t) low << 32 | high;
}

ds_message ds_message_marshall(double payload[N_DISTANCE_SENSORS]){
  ds_message message = {0};
  message.id = htonl(OUT_MESSAGE_DISTANCE_SENSOR);
  message.size = htonl(N_DISTANCE_SENSORS * sizeof(uint64_t));
  for(int i = 0; i<N_DISTANCE_SENSORS; i++){
    message.payload[i] = *(uint64_t *) &payload[i];
    message.payload[i] = host_to_net_64(message.payload[i]);
  }
  return message;
}

ls_message ls_message_marshall(double payload[N_LIGHT_SENSORS]){
  ls_message message = {0};
  message.id = htonl(OUT_MESSAGE_LIGHT_SENSOR);
  message.size = htonl(N_LIGHT_SENSORS * sizeof(uint64_t));
  for(int i = 0; i<N_LIGHT_SENSORS; i++){
    message.payload[i] = *(uint64_t *) &payload[i];
    message.payload[i] = host_to_net_64(message.payload[i]);
  }
  return message;
}

img_message *img_message_prepare(uint32_t size){
  img_message *message = (img_message *) malloc(sizeof(img_message) + size);
  if(message == NULL){
    std::cerr << "failed to allocate memory" << std::endl;
    return NULL;
  }

  message->id = htonl(OUT_MESSAGE_IMAGE);
  message->size = htonl(size);
  return message;
}

int send_sensor_data(int client, ds_message ds_msg, ls_message ls_msg, img_message *img_msg, int image_size){
  int err = send(client, (const char *) &ds_msg, sizeof(ds_message), 0);
  if(is_socket_error(err) == 1){
    std::cerr << "failed to send distance sensor data to external controller" << std::endl << "quitting... " << std::endl;
    return -1;
  }
  err = send(client, (const char *) &ls_msg, sizeof(ls_message), 0);
  if(is_socket_error(err) == 1){
    std::cerr << "failed to send light sensor data to external controller" << std::endl << "quitting... " << std::endl;
    return -1;
  }

  err = send(client, (const char *) img_msg, sizeof(img_message) + image_size, 0); 
  if(is_socket_error(err) == 1){
    std::cerr << "failed to send image data to external controller" << std::endl << "quitting... " << std::endl;
    return -1;
  }

  return 0;
}

int select_call(int client){
  struct timeval tv = {0, 0};
  struct fd_set rfds;
  FD_ZERO(&rfds);
  FD_SET(client, &rfds);
  int number = select(client + 1, &rfds, NULL, NULL, &tv);
  return number;
}

void incoming_message_unmarshall(buffer_reader reader, double *right_speed, double *left_speed){
    uint32_t id = 0, size = 0;
    uint64_t payload = 0;
    reader >> id;
    reader >> size;
    reader >> payload;

    id = ntohl(id);
    size = ntohl(size);
    payload = net_to_host_64(payload);

    if(id == IN_MESSAGE_VELOCITY){
      *left_speed =  *left_speed < 0 : -(*(double *) &payload) : *(double *) &payload;
      *right_speed = *right_speed < 0 : -(*(double *) &payload) : *(double *) &payload;
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

int main(int argc, char **argv) {
  if(argc != 2){
    std::cerr << "port missing" << std::endl;
    return EXIT_FAILURE;
  }
  
  // setup server socket
  std::cout << "creating server socket on port " << atoi(argv[1]) << std::endl;
  int sock = create_socket(atoi(argv[1]));
  if(sock == -1){
#ifdef _WIN32
    WSACleanup();
#endif
    return EXIT_FAILURE;
  }

  // wait for external controller to connect
  std::cout << "waiting for external controller" << std::endl;
  int client = accept_client(sock);
  if(client == -1){
    close_socket(sock);
#ifdef _WIN32
    WSACleanup();
#endif
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
    close_socket(sock);
    close_socket(client);
#ifdef _WIN32
    WSACleanup();
#endif
    delete robot;
    return EXIT_FAILURE;
  }

  buffer incoming;
  size_t size = 2 * sizeof(uint32_t) + sizeof(uint64_t);
  uint8_t dummy[2 * sizeof(uint32_t) + sizeof(uint64_t)] = {0};
  while (robot->step(timeStep) != -1) {
    // read sensor data
    double ds_values[N_DISTANCE_SENSORS];
    for(int i = 0; i<N_DISTANCE_SENSORS; i++){
      ds_values[i] = ds_sensors[i]->getValue();
    }

    double ls_values[N_LIGHT_SENSORS];
    for(int i = 0; i<N_LIGHT_SENSORS; i++){
      ls_values[i] = ls_sensors[i]->getValue();
    }

    const unsigned char *image = camera->getImage();

    // marshall sensor data
    ds_message ds_msg = ds_message_marshall(ds_values);
    ls_message ls_msg = ls_message_marshall(ls_values);
    memcpy(img_msg->payload, image, image_size); 

    int err = send_sensor_data(client, ds_msg, ls_msg, img_msg, image_size);
    if(err == -1){
      break;
    }
    
    int count = 0;
    do{
      err = select_call(client);
      if(err == 0){
        break;
      }

      if(is_socket_error(err) == 1){
        std::cout << "select failed" << std::endl << "quitting... " << std::endl;
        break;
      }
      std::cout << "select: " << err << std::endl;

      auto recbytes = recv(client, (char *) dummy, size, 0);
      buffer_writer writer(incoming);
      for(auto i = 0; i<recbytes; i++){
        writer << dummy[i];
      }

      if(writer.written() < size){
        break;
      }
      
      buffer_reader reader(incoming);
      incoming_message_unmarshall(reader, &right_speed, &left_speed);

      // reset buffer
      incoming.clear();
      count += 1;
    }while(err > 0 && count < 16);

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
  close_socket(sock);
  close_socket(client);
#ifdef _WIN32
  WSACleanup();
#endif
  free(img_msg);
  delete robot;
  return 0;
}
