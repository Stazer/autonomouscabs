#pragma once

#include <array>

#include <webots/Robot.hpp>
#include <webots/Motor.hpp>
#include <webots/Camera.hpp>
#include <webots/DistanceSensor.hpp>
#include <webots/LightSensor.hpp>

#include <boost/asio.hpp>

#include "../../../shared/buffer.hpp"
#include "../../../shared/buffer_reader.hpp"
#include "../../../shared/buffer_writer.hpp"
#include "../../../shared/message.hpp"

class robot_container
{
    private:
        webots::Robot _robot;
        int _basic_time_step;
        std::array<webots::Motor *, 4> _motors;
        std::array<webots::DistanceSensor *, 9> _distance_sensors;
        std::array<webots::LightSensor *, 1> _light_sensors;
        webots::Camera *_camera;
        int _image_size;

        boost::asio::io_service _io_service;
        boost::asio::ip::tcp::socket _external;
        buffer _in;
        buffer_reader _reader;
        buffer_writer _writer;

        void fill_distance_sensor_message(buffer_writer& writer);
        void fill_light_sensor_message(buffer_writer& writer);
        void fill_image_data_message(buffer_writer& writer);
    public:
        robot_container();
        void setup_robot();
        int wait_for_connection(char *port);
        void run();
};
