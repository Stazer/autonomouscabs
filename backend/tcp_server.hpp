#pragma once

#include <iostream>

#include <boost/asio.hpp>

class application;

template <typename T>
class tcp_server
{
    public:
        tcp_server(boost::asio::io_context& io_context, std::uint16_t port, application& _application);

        void run();

    private:
        boost::asio::io_context& _io_context;
        boost::asio::ip::tcp::acceptor _acceptor;

        application& _application;

        void handle_accept();
};

#include "tcp_server.inl"
