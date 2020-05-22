#include <boost/asio.hpp>

#include <iostream>
#include <memory>
#include <string>
#include <utility>

class tcp_session : public std::enable_shared_from_this<tcp_session>
{
    public:
        tcp_session(boost::asio::ip::tcp::socket socket);
        ~tcp_session();

        void run();

    private:
        boost::asio::ip::tcp::socket socket;

        void handle_receive();
};

tcp_session::tcp_session(boost::asio::ip::tcp::socket socket):
    socket(std::move(socket))
{
    std::cout << "Connection from " << this->socket.remote_endpoint().address().to_string() << ":" << this->socket.remote_endpoint().port() << " opened!\n";
}

tcp_session::~tcp_session()
{
    std::cout << "Connection from " << socket.remote_endpoint().address().to_string() << ":" << socket.remote_endpoint().port() << " closed!\n";
}

void tcp_session::run()
{
    handle_receive();
}

void tcp_session::handle_receive()
{
    auto self = shared_from_this();
}

class tcp_server
{
    public:
        tcp_server(boost::asio::io_context& io_context);

        void run();

    private:
        boost::asio::io_context& io_context;
        boost::asio::ip::tcp::acceptor acceptor;

        void handle_accept();
};

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

int main(int argc, char *argv[])
{
    std::cout << "Autonomoues Cabs Backend\n";
    std::cout << "Starting...\n";

    try
    {
        boost::asio::io_context io_context;
        tcp_server server(io_context);

        server.run();
        io_context.run();
    }
    catch(std::exception& e)
    {
        std::cerr << "Error\n" << e.what() << std::endl;
    }

    return 0;
}
