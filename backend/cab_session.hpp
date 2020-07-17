#pragma once

#include <iostream>
#include <array>
#include <memory>

#include <boost/asio.hpp>

#include "cab.hpp"
#include "../shared/buffer.hpp"

class application;

class cab_session : public std::enable_shared_from_this<cab_session>
{
    public:
        cab_session(application& application, boost::asio::ip::tcp::socket&& socket);
        cab_session(const cab_session&) = delete;
        cab_session(cab_session&&) = default;

        cab_session& operator=(const cab_session&) = delete;
        cab_session& operator=(cab_session&&) = default;

        ~cab_session();

        void run();

        void send_request(request& request);

    private:
        application* _application = nullptr;

        boost::asio::ip::tcp::socket _socket;
        std::array<std::uint8_t, 1024> _receive_buffer;
        buffer _buffer;

        std::function<void(void)> _handle_buffer = std::bind(&cab_session::handle_join, this);

        cab* _cab;

        void handle_receive();

        void handle_join();
        void handle_update();
        void handle_running();
};