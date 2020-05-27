#pragma once

#include <boost/asio.hpp>
#include <memory>

class tcp_session : public std::enable_shared_from_this<tcp_session>
{
    public:
        tcp_session(boost::asio::ip::tcp::socket socket);
        ~tcp_session();

        void run();

    private:
        boost::asio::ip::tcp::socket socket;

        void handle_receive();
};
