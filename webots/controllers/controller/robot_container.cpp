#include <string>
#include <vector>
#include <iostream>

#include "robot_container.hpp"
#include "../../../shared/message.hpp"

robot_container::robot_container() : 
    _external(_io_service)
{
    _basic_time_step = (int) _robot.getBasicTimeStep();
    _last = std::chrono::duration_cast<std::chrono::milliseconds>
                (std::chrono::system_clock::now().time_since_epoch());
}

void robot_container::setup_robot(int n_images)
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
    _image_size =  _camera->getHeight() * _camera->getWidth() * 4  * sizeof(unsigned char);

    // limiting the number if image messages send per second
    // standart value is 10
    if((n_images * 16) > 1000 || n_images == -1)
    {
        n_images = 10;
    }
    // calculate wait time in milliseconds in steps of _basic_time_step
    _wait_time = static_cast<int>(1000 / (n_images * _basic_time_step)) * _basic_time_step;
    std::cout << "wait time: " << _wait_time << '\n';

    std::cout << "setting up motor" << '\n';
    std::vector<std::string> m_names = {"wheelFR", "wheelRR", "wheelRL", "wheelFL"};
    for(std::size_t i = 0; i<m_names.size(); ++i)
    {
        _motors[i] = _robot.getMotor(m_names[i]);
        _motors[i]->setPosition(INFINITY);
        _motors[i]->setVelocity(0);
    }
}

void robot_container::wait_for_connection(char *port)
{
    std::cout << "waiting for external controller" << '\n';
    using boost::asio::ip::tcp;
    try
    {
        tcp::acceptor acceptor(_io_service, tcp::endpoint(tcp::v4(), std::atoi(port)));
        acceptor.accept(_external);
    }
    catch(std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }
}

void robot_container::fill_distance_sensor_message(buffer& out)
{
    external_distance_sensor_message message;
    for(std::size_t i = 0; i<_distance_sensors.size(); ++i)
    {
      message.data[i] = _distance_sensors[i]->getValue();
    }
    buffer_writer writer(out);
    writer << message;
}

void robot_container::fill_light_sensor_message(buffer& out)
{
    external_light_sensor_message message;
    for(std::size_t i = 0; i<_light_sensors.size(); ++i)
    {
      message.data[i] = _light_sensors[i]->getValue();
    }
    buffer_writer writer(out);
    writer << message;
}

void robot_container::fill_image_data_message(buffer& out)
{
    std::chrono::milliseconds now = std::chrono::duration_cast<std::chrono::milliseconds>
                (std::chrono::system_clock::now().time_since_epoch());
    // turn on camera at least _basic_time_step millieconds before _wait_time
    if((now - _last).count() > (_wait_time - (_basic_time_step + 4))){
        _camera->enable(_basic_time_step);
    }

    if((now - _last).count() < _wait_time){
        return;
    }

    const unsigned char *image = _camera->getImage();
    std::vector<unsigned char> vec(image, image + _image_size);
    external_image_data_message message;
    message.pixel = vec;
    buffer_writer writer(out);
    writer << message;

    _last = now;
    _camera->disable();
}

void robot_container::run()
{
    while (_robot.step(_basic_time_step) != -1)
    {
        buffer out;
        fill_distance_sensor_message(out);
        fill_light_sensor_message(out);
        fill_image_data_message(out);

        try
        {
            std::size_t t = boost::asio::write(_external, boost::asio::buffer(out));
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
            // std::cout << "recieved rs: " << vl_msg.right_speed << ", ls: " << vl_msg.left_speed << '\n';
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            break;
        }
    }

    for(auto m : _motors)
    {
        m->setVelocity(0);
    }

    _external.close();
}
