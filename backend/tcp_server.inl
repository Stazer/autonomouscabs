template <typename T>
tcp_server<T>::tcp_server(boost::asio::io_context& io_context, std::uint16_t port, application& application):
    _io_context(io_context),
    _acceptor(io_context, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), port)),
    _application(application)
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
    _acceptor.async_accept([this](boost::system::error_code error_code, boost::asio::ip::tcp::socket socket)
    {
        if(!error_code)
        {
            std::make_shared<T>(std::move(socket), _application)->run();
        }

        handle_accept();
    });
}
