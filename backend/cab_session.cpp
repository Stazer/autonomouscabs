#include "cab_session.hpp"
#include "application.hpp"
#include "node_type.hpp"
#include "../shared/message.hpp"

cab_session::cab_session(application& application, boost::asio::ip::tcp::socket&& socket):
    _application(&application),
    _socket(std::move(socket))
{
    std::cout << "Cab connection from " << this->_socket.remote_endpoint().address().to_string()
              << ":" << this->_socket.remote_endpoint().port() << " opened\n";
}

cab_session::~cab_session()
{
    if(_cab)
        _application->manager().remove(*_cab);

    std::cout << "Cab connection from " << this->_socket.remote_endpoint().address().to_string()
              << ":" << this->_socket.remote_endpoint().port() << " closed\n";
}

void cab_session::run()
{
    handle_receive();
}

void cab_session::handle_receive()
{
    auto self = shared_from_this();
    _socket.async_read_some(boost::asio::buffer(_receive_buffer), [this, self](boost::system::error_code error_code, std::size_t length)
    {
        if(!error_code)
        {
            _buffer.insert(_buffer.end(), _receive_buffer.begin(), _receive_buffer.begin() + length);
            _handle_buffer();
        }
    });
}

void cab_session::handle_join()
{
    backend_join_challenge_message challenge_message;
    if(challenge_message.readable(_buffer))
    {
        auto self = shared_from_this();

        challenge_message.from_buffer(_buffer);

        _cab = &_application->manager().create(self);

        std::cout << "Cab with id " << _cab->id() << " joined\n";

        _handle_buffer = std::bind(&cab_session::handle_update, this);

        external_join_success_message success_message;
        success_message.id = _cab->id();
        _socket.async_send(boost::asio::buffer(success_message.to_buffer()), [this, self](boost::system::error_code error_code, std::size_t written)
        {
            std::cout << "Data sent " << written << std::endl;
            if(!error_code)
            {
                handle_receive();
            }
        });
    }
    else
        handle_receive();
}

void cab_session::handle_update()
{
    backend_position_update_message position_message;
    backend_route_update_message route_message;
    if(position_message.readable(_buffer))
    {
        position_message.from_buffer(_buffer);

        std::cout << "Cab with id " << _cab->id() << " moved to " << static_cast<node_type>(position_message.position) << '\n';

        _cab->update_position(static_cast<node_type>(position_message.position));
    }
    else if(route_message.readable(_buffer))
    {
        route_message.from_buffer(_buffer);

        std::cout << "Cab with id " << _cab->id() << " updated its route\n";

        std::vector<node_type> converted;
        converted.reserve(route_message.size());
        std::cout << "received route: ";
        for(auto e : route_message.route)
        {
            converted.push_back(static_cast<node_type>(e));
            std::cout << converted.back() << ", ";
        }
        std::cout << '\n';
        _cab->update_route(converted);
    }

    handle_receive();
}

void cab_session::handle_running()
{
    handle_receive();
}

void cab_session::send_request(request& request)
{
    external_add_request_message add_message;
    add_message.src = static_cast<std::uint8_t>(request.src());
    add_message.dst = static_cast<std::uint8_t>(request.dst());
    add_message.passengers = request.passengers();

    auto self = shared_from_this();
    _socket.async_send(boost::asio::buffer(add_message.to_buffer()), [this, self](boost::system::error_code error_code, std::size_t written)
    {
        std::cout << "Data sent " << written << std::endl;
    });
}
