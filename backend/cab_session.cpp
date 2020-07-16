#include "cab_session.hpp"
#include "application.hpp"
#include "../shared/message.hpp"

cab_session::cab_session(boost::asio::ip::tcp::socket&& socket, class application& application):
    tcp_session(application),
    _socket(std::move(socket))
{
    std::cout << "Cab connection from " << this->_socket.remote_endpoint().address().to_string()
              << ":" << this->_socket.remote_endpoint().port() << " opened\n";
}

cab_session::~cab_session()
{
    if(_cab)
        application().cab_manager().remove(*_cab);

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
        challenge_message.from_buffer(_buffer);

        _cab = &application().cab_manager().create();

        std::cout << "Cab with id " << _cab->id() << " joined\n";

        _handle_buffer = std::bind(&cab_session::handle_running, this);

        auto self = shared_from_this();

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

void cab_session::handle_running()
{
    handle_receive();
}
