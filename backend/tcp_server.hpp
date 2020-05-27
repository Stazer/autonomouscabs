#pragma once

#include <boost/asio.hpp>

class tcp_server
{
    public:
        tcp_server(boost::asio::io_context& io_context);

        void run();

    private:
        boost::asio::io_context& io_context;
        boost::asio::ip::tcp::acceptor acceptor;

        void handle_accept();
};
