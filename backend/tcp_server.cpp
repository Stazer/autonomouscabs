#include "tcp_server.hpp"
#include "tcp_session.hpp"

tcp_server::tcp_server(boost::asio::io_context& io_context):
    io_context(io_context),
    acceptor(io_context, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), 9876))
{
}

void tcp_server::run()
{
    handle_accept();
}

void tcp_server::handle_accept()
{
    acceptor.async_accept([this](boost::system::error_code error_code, boost::asio::ip::tcp::socket socket)
    {
        if(!error_code)
        {
            std::make_shared<tcp_session>(std::move(socket))->run();
        }

        handle_accept();
    });
}
