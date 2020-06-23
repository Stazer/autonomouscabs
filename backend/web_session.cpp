#include "web_session.hpp"

#include <iostream>

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
    handle_receive();
}

void web_session::handle_receive()
{
}
