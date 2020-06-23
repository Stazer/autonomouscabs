#include "cab_session.hpp"
#include "../shared/message.hpp"

cab_session::cab_session(boost::asio::ip::tcp::socket&& socket):
    socket(std::move(socket)),
    handle_buffer(std::bind(&cab_session::handle_join, this))
{
    std::cout << "Cab connection from " << this->socket.remote_endpoint().address().to_string()
              << ":" << this->socket.remote_endpoint().port() << " opened\n";

    buffer.reserve(4096);
}

cab_session::~cab_session()
{
    std::cout << "Cab connection from " << this->socket.remote_endpoint().address().to_string()
              << ":" << this->socket.remote_endpoint().port() << " closed\n";
}

void cab_session::run()
{
    handle_receive();
}

void cab_session::handle_receive()
{
    auto self = shared_from_this();
    socket.async_read_some(boost::asio::buffer(receive_buffer), [this, self](boost::system::error_code error_code, std::size_t length)
    {
        if(!error_code)
        {
            buffer.insert(buffer.end(), receive_buffer.begin(), receive_buffer.begin() + length);
            handle_buffer();
        }
    });
}

void cab_session::handle_join()
{
    {
        backend_join_challenge_message message;
        buffer_reader reader(buffer);
        if(reader.available() >= message.size())
        {
            reader >> message;
            buffer.erase(buffer.begin(), buffer.begin() + reader.read());

            handle_buffer = std::bind(&cab_session::handle_running, this);
        }
    }

    handle_receive();
}

void cab_session::handle_running()
{
    handle_receive();
}
