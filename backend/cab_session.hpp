#pragma once

#include <iostream>

#include <boost/asio.hpp>

#include "tcp_session.hpp"

class cab_session : public tcp_session<cab_session>
{
    public:
        cab_session(boost::asio::ip::tcp::socket&& socket);
        ~cab_session();

        void run();

    private:
        boost::asio::ip::tcp::socket _socket;
};

cab_session::cab_session(boost::asio::ip::tcp::socket&& socket):
    _socket(std::move(socket))
{
    std::cout << "Cab connection from " << _socket.remote_endpoint().address().to_string()
              << ":" << _socket.remote_endpoint().port() << " opened\n";
}

cab_session::~cab_session()
{
    std::cout << "Cab connection from " << _socket.remote_endpoint().address().to_string()
              << ":" << _socket.remote_endpoint().port() << " closed\n";
}

void cab_session::run()
{
}
