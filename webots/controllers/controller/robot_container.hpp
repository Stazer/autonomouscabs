#pragma once

#include <array>
#include <chrono>

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
        int _wait_time;

        std::chrono::milliseconds _last;

        boost::asio::io_service _io_service;
        boost::asio::ip::tcp::socket _external;

        std::array<std::uint8_t, 256> _receive_buffer;
        buffer _buffer;

        void fill_distance_sensor_message(buffer& out);
        void fill_light_sensor_message(buffer& out);
        void fill_image_data_message(buffer& out);
    public:
        robot_container();
        void setup_robot(int n_images);
        void wait_for_connection(char *port);
        void run();
};
