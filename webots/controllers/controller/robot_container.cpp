#include <string>
#include <vector>
#include <iostream>

#include "robot_container.hpp"
#include "../../../shared/message.hpp"

robot_container::robot_container() 
    : _external(_io_service)
{
    _basic_time_step = (int) _robot.getBasicTimeStep();
}

void robot_container::setup_robot()
{
    std::cout << "setting up distance sensors" << '\n';
    std::vector<std::string> ds_names = {"ds_fc", "ds_fcr", "ds_fr", "ds_rf", "ds_rc", 
                                         "ds_lc", "ds_lf", "ds_fl", "ds_fcl"};
    for(std::size_t i = 0; i<ds_names.size(); ++i)
    {
        _distance_sensors[i] = _robot.getDistanceSensor(ds_names[i]);
        _distance_sensors[i]->enable(_basic_time_step);
    }

    std::cout << "setting up light sensors" << '\n';
    std::vector<std::string> ls_names = {"ls_front"};
    for(std::size_t i = 0; i<ls_names.size(); ++i)
    {
        _light_sensors[i] = _robot.getLightSensor(ls_names[i]);
        _light_sensors[i]->enable(_basic_time_step);
    }

    std::cout << "setting up camera" << '\n';
    _camera = _robot.getCamera("camera");
    _camera->enable(_basic_time_step);
    _image_size =  _camera->getHeight() * _camera->getWidth() * 4  * sizeof(unsigned char);

    std::cout << "setting up motor" << '\n';
    std::vector<std::string> m_names = {"wheelFR", "wheelRR", "wheelRL", "wheelFL"};
    for(std::size_t i = 0; i<m_names.size(); ++i)
    {
        _motors[i] = _robot.getMotor(m_names[i]);
        _motors[i]->setPosition(INFINITY);
        _motors[i]->setVelocity(0);
    }
}

int robot_container::wait_for_connection(char *port)
{   
    std::cout << "waiting for external controller" << '\n';
    using boost::asio::ip::tcp;
    try
    {
        tcp::acceptor acceptor(_io_service, tcp::endpoint(tcp::v4(), std::atoi(port)));
        acceptor.accept(_external);
        return 0;
    }
    catch(std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
        return -1;
    }
}

void robot_container::fill_distance_sensor_message(external_distance_sensor_message& message)
{
    for(std::size_t i = 0; i<_distance_sensors.size(); ++i)
    {
      message.data[i] = _distance_sensors[i]->getValue();
    }
}

void robot_container::fill_light_sensor_message(external_light_sensor_message& message)
{
    for(std::size_t i = 0; i<_light_sensors.size(); ++i)
    {
      message.data[i] = _light_sensors[i]->getValue();
    }
}

void robot_container::fill_image_data_message(external_image_data_message& message)
{
    const unsigned char *image = _camera->getImage();
    std::vector<unsigned char> vec(image, image + _image_size);
    message.pixel = vec;
}

void robot_container::run()
{
    while (_robot.step(_basic_time_step) != -1) 
    {
        external_distance_sensor_message ds_message;
        external_light_sensor_message ls_message;
        external_image_data_message id_message;
        fill_distance_sensor_message(ds_message);
        fill_light_sensor_message(ls_message);
        fill_image_data_message(id_message);

        try
        {
            boost::asio::write(_external, boost::asio::buffer(ds_message.to_buffer()));
            boost::asio::write(_external, boost::asio::buffer(ls_message.to_buffer()));
            boost::asio::write(_external, boost::asio::buffer(id_message.to_buffer()));
            if(_external.available() < 1)
            {
                continue;
            }

            boost::system::error_code error;
            std::size_t length = _external.read_some(boost::asio::buffer(_receive_buffer), error);
            if(error == boost::asio::error::eof)
            {
                std::cerr << "external controller has disconected" << std::endl;
                break;
            }
            else if (error)
            {
                std::cerr << "Error: " << error << std::endl;
                break;
            }

            _buffer.insert(_buffer.end(), _receive_buffer.begin(), _receive_buffer.begin() + length);

            webots_velocity_message vl_msg;
            if(!vl_msg.readable(_buffer))
            {
                continue;
            }

            vl_msg.from_buffer(_buffer);
            _motors[0]->setVelocity(vl_msg.right_speed);
            _motors[1]->setVelocity(vl_msg.right_speed);
            _motors[2]->setVelocity(vl_msg.left_speed);
            _motors[3]->setVelocity(vl_msg.left_speed);
            std::cout << "recieved rs: " << vl_msg.right_speed << ", ls: " << vl_msg.left_speed << '\n';
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            break;
        }
    }
    
    _external.close();
}