#pragma once

#include <boost/asio.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/websocket.hpp>

#include "tcp_session.hpp"

class web_session : public tcp_session<web_session>
{
    public:
        web_session(boost::asio::ip::tcp::socket&& socket);
        ~web_session();

        void run();

    private:
        boost::beast::websocket::stream<boost::beast::tcp_stream> _stream;
        boost::beast::flat_buffer _buffer;

        void handle_receive();
};

web_session::web_session(boost::asio::ip::tcp::socket&& socket):
    _stream(std::move(socket))
{
    std::cout << "Web connection from " << _stream.next_layer().socket().remote_endpoint().address().to_string()
              << ":" << _stream.next_layer().socket().remote_endpoint().port() << " opened\n";
}

web_session::~web_session()
{
    std::cout << "Web connection from " << _stream.next_layer().socket().remote_endpoint().address().to_string()
              << ":" << _stream.next_layer().socket().remote_endpoint().port() << " closed\n";
}

void web_session::run()
{
}

void web_session::handle_receive()
{
}
