#pragma once

#include <boost/asio.hpp>

template <typename T>
class tcp_server
{
    public:
        tcp_server(boost::asio::io_context& io_context, std::uint16_t port);

        void run();

    private:
        boost::asio::io_context& io_context;
        boost::asio::ip::tcp::acceptor acceptor;

        void handle_accept();
};

#include "tcp_server.inl"
