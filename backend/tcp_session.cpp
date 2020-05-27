#include <utility>
#include <iostream>

#include "tcp_session.hpp"

tcp_session::tcp_session(boost::asio::ip::tcp::socket socket):
    socket(std::move(socket))
{
    std::cout << "Connection from " << this->socket.remote_endpoint().address().to_string() << ":" << this->socket.remote_endpoint().port() << " opened!\n";
}

tcp_session::~tcp_session()
{
    std::cout << "Connection from " << socket.remote_endpoint().address().to_string() << ":" << socket.remote_endpoint().port() << " closed!\n";
}

void tcp_session::run()
{
    handle_receive();
}

void tcp_session::handle_receive()
{
    auto self = shared_from_this();
}
