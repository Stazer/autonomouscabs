#pragma once

#include <iostream>

#include <boost/asio.hpp>

class application;

class cab_server
{
    public:
        cab_server(application& _application, boost::asio::io_service& io_service, std::uint16_t port);
        ~cab_server();

        void run();

    private:
        application& _application;

        boost::asio::io_service& _io_service;
        boost::asio::ip::tcp::acceptor _acceptor;

        void handle_accept();
};
