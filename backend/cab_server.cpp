#include "cab_server.hpp"
#include "cab_session.hpp"

cab_server::cab_server(application& application, boost::asio::io_context& io_context, std::uint16_t port):
    _application(application),
    _io_context(io_context),
    _acceptor(io_context, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), port))
{
    std::cout << "TCP server Listening on *:" << port << "\n";
}

void cab_server::run()
{
    handle_accept();
}

void cab_server::handle_accept()
{
    _acceptor.async_accept([this](boost::system::error_code error_code, boost::asio::ip::tcp::socket socket)
    {
        if(!error_code)
        {
            std::make_shared<cab_session>(_application, std::move(socket))->run();
        }

        handle_accept();
    });
}
