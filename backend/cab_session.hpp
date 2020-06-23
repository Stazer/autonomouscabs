#pragma once

#include <iostream>
#include <array>

#include <boost/asio.hpp>

#include "tcp_session.hpp"
#include "../shared/buffer.hpp"

class cab_session : public tcp_session<cab_session>
{
    public:
        cab_session(boost::asio::ip::tcp::socket&& socket);
        ~cab_session();

        void run();

    private:
        boost::asio::ip::tcp::socket socket;
        std::array<std::uint8_t, 1024> receive_buffer;
        ::buffer buffer;

        std::function<void(void)> handle_buffer;

        void handle_receive();

        void handle_join();
        void handle_running();
};
