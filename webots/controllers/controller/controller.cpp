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
#endif

#include <webots/Robot.hpp>
#include <webots/Motor.hpp>
#include <webots/Camera.hpp>
#include <webots/DistanceSensor.hpp>
#include <webots/LightSensor.hpp>

#define N_DISTANCE_SENSORS 9
#define N_LIGHT_SENSORS 1

// All the webots classes are defined in the "webots" namespace
using namespace webots;

typedef enum message_id{
  DISTANCE_SENSOR_MESSAGE = 1,
  LIGHT_SENSOR_MESSAGE = 2,
  CAMERA_MESSAGE = 3,
}message_id;

typedef struct ds_message{
  uint32_t id;
  uint32_t size;
  uint64_t payload[N_DISTANCE_SENSORS];
}ds_message;

typedef struct img_message{
  uint32_t id;
  uint32_t size;
  unsigned char payload[N_LIGHT_SENSORS];
}img_message;

typedef struct ls_message{
  uint32_t id;
  uint32_t size;
  uint64_t payload[];
}ls_message;

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
  message.id = htonl(DISTANCE_SENSOR_MESSAGE);
  message.size = htonl(N_DISTANCE_SENSORS * sizeof(uint64_t));
  for(int i = 0; i<N_DISTANCE_SENSORS; i++){
    message.payload[i] = *(uint64_t *) &payload[i];
    message.payload[i] = host_to_net_64(message.payload[i]);
  }
  return message;
}

ls_message ls_message_marshall(double payload[N_LIGHT_SENSORS]){
  ls_message message = {0};
  message.id = htonl(LIGHT_SENSOR_MESSAGE);
  message.size = htonl(N_LIGHT_SENSORS * sizeof(uint64_t));
  for(int i = 0; i<N_LIGHT_SENSORS; i++){
    message.payload[i] = *(uint64_t *) &payload[i];
    message.payload[i] = host_to_net_64(message.payload[i]);
  }
  return message;
}

int main(int argc, char **argv) {
  if(argc != 2){
    std::cerr << "port missing" << std::endl;
    return EXIT_FAILURE;
  }
  
  // setup server socket
  int sock = create_socket(atoi(argv[1]));
  if(sock == -1){
    return EXIT_FAILURE;
  }

  // wait for external controller to connect
  int client = accept_client(sock);
  if(client == -1){
    close_socket(sock);
    return EXIT_FAILURE;
  }

  fd_set rfds;
  FD_ZERO(&rfds);
  FD_SET(client, &rfds);
  
  Robot *robot = new Robot();

  // get the time step of the current world.
  int timeStep = (int) robot->getBasicTimeStep();

  // setup sensors
  std::string ds_names[N_DISTANCE_SENSORS] = {"ds_fc", "ds_fcr", "ds_fr", "ds_rf", "ds_rc", "ds_lc", "ds_lf", "ds_fl", "ds_fcl"};
  DistanceSensor *ds_sensors[N_DISTANCE_SENSORS];
  for(int i = 0; i<N_DISTANCE_SENSORS; i++){
    ds_sensors[i] = robot->getDistanceSensor(ds_names[i]);
    ds_sensors[i]->enable(timeStep);
  }

  std::string ls_names[N_LIGHT_SENSORS] = {"ls_front"};
  LightSensor *ls_sensors[N_LIGHT_SENSORS];
  for(int i = 0; i<N_LIGHT_SENSORS; i++){
    ls_sensors[i] = robot->getLightSensor(ls_names[i]);
    ls_sensors[i]->enable(timeStep);
  }

  Camera *camera = robot->getCamera("camera");
  camera->enable(timeStep);
  int image_height = camera->getHeight();
  int image_width = camera->getWidth();

  // setup motors
  std::string m_names[4] = {"wheelFR", "wheelRR", "wheelRL", "wheelFL"};
  Motor *m_motors[4];
  for(int i = 0; i<4; i++){
    m_motors[i] = robot->getMotor(m_names[i]);
    m_motors[i]->setPosition(INFINITY);
  }

  struct timeval tv = {0, 0};
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
    /* img_message img_msg = img_message_marshall(image); */

    int err = send(client, (const char *) &ds_msg, sizeof(ds_message), 0);
    if(err < 0){
      std::cerr << "failed to send distance sensor data to external controller" << std::endl << "quitting... " << std::endl;
      break;
    }
    err = send(client, (const char *) &ls_msg, sizeof(ls_message), 0);
    if(err < 0){
      std::cerr << "failed to send light sensor data to external controller" << std::endl << "quitting... " << std::endl;
      break;
    }

    /* err = send(client, (const char *) &img_msg, sizeof(img_message), 0); 
      if(err < 0){
        std::cerr << "failed to send image data to external controller" << std::endl << "quitting... " << std::endl;
        break;
      }
    */

    int number = select(client + 1, &rfds, NULL, NULL, &tv);
    if(number == 0){
      continue;
    }
    // read data from external controller
    // read_data(client);
    // aply data to motors
    /* for(int i = 0; i<4; i++){
      m_motors[i]->setVelocity(0);
    } */
  };

  // Enter here exit cleanup code.
  close_socket(sock);
  close_socket(client);
  delete robot;
  return 0;
}
