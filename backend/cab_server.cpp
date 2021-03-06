#include "cab_server.hpp"
#include "cab_session.hpp"

cab_server::cab_server(application& application, boost::asio::io_service& io_service, std::uint16_t port):
    _application(application),
    _io_service(io_service),
    _acceptor(io_service, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), port))
{
    std::cout << "Cab server Listening on *:" << port << "\n";
}

cab_server::~cab_server()
{
    std::cout << "Cab server stopped\n";
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
