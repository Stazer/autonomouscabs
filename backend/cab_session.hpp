#pragma once

#include <iostream>
#include <array>

#include <boost/asio.hpp>

#include "tcp_session.hpp"
#include "cab.hpp"
#include "../shared/buffer.hpp"

class cab_session : public tcp_session<cab_session>
{
    public:
        cab_session(boost::asio::ip::tcp::socket&& socket, class application& application);
        ~cab_session();

        void run();

    private:
        boost::asio::ip::tcp::socket _socket;
        std::array<std::uint8_t, 1024> _receive_buffer;
        buffer _buffer;

        std::function<void(void)> _handle_buffer = std::bind(&cab_session::handle_join, this);

        cab* _cab;

        void handle_receive();

        void handle_join();
        void handle_running();
};
