#pragma once

#include <boost/asio.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/websocket.hpp>

#include "tcp_session.hpp"

class web_session : public tcp_session<web_session>
{
    public:
        web_session(boost::asio::ip::tcp::socket&& socket, class application& application);
        ~web_session();

        void run();

    private:
        boost::beast::websocket::stream<boost::beast::tcp_stream> _stream;
        boost::beast::flat_buffer _buffer;

        void handle_receive();
};
