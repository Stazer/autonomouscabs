#pragma once

#include <boost/asio.hpp>

template <typename T>
class tcp_server
{
    public:
        tcp_server(boost::asio::io_context& io_context, std::uint16_t port);

        void run();

    private:
        boost::asio::io_context& io_context;
        boost::asio::ip::tcp::acceptor acceptor;

        void handle_accept();
};

template <typename T>
tcp_server<T>::tcp_server(boost::asio::io_context& io_context, std::uint16_t port):
    io_context(io_context),
    acceptor(io_context, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), port))
{
    std::cout << "Listening on *:" << port << "\n";
}

template <typename T>
void tcp_server<T>::run()
{
    handle_accept();
}

template <typename T>
void tcp_server<T>::handle_accept()
{
    acceptor.async_accept([this](boost::system::error_code error_code, boost::asio::ip::tcp::socket socket)
    {
        if(!error_code)
        {
            std::make_shared<T>(std::move(socket))->run();
        }

        handle_accept();
    });
}
