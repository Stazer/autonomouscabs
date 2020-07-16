#pragma once

#include <iostream>

#include <boost/asio.hpp>

class application;

class cab_server
{
    public:
        cab_server(application& _application, boost::asio::io_context& io_context, std::uint16_t port);

        void run();

    private:
        application& _application;

        boost::asio::io_context& _io_context;
        boost::asio::ip::tcp::acceptor _acceptor;

        void handle_accept();
};
