#include <boost/asio.hpp>
#include <iostream>
#include <string>

class tcp_server
{
    public:
        tcp_server(boost::asio::io_context& io_context);

    private:
        boost::asio::io_context& io_context;
        boost::asio::ip::tcp::acceptor acceptor;

        void handle_accept();
};

tcp_server::tcp_server(boost::asio::io_context& io_context):
    io_context(io_context),
    acceptor(io_context, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), 9876))
{
    handle_accept();
}

void tcp_server::handle_accept()
{
    acceptor.async_accept([this](boost::system::error_code error_code, boost::asio::ip::tcp::socket socket)
    {
        std::cout << "Connection from " << socket.remote_endpoint().address().to_string() << ":" << socket.remote_endpoint().port() << " accepted!\n";

        handle_accept();
    });
}

int main(int argc, char *argv[])
{
    std::cout << "Autonomoues Cabs Backend\n";
    std::cout << "Starting...\n";

    try
    {
        boost::asio::io_context io_context;
        tcp_server server(io_context);

        io_context.run();
    }
    catch(std::exception& e)
    {
        std::cerr << e.what() << std::endl;
    }

    return 0;
}
