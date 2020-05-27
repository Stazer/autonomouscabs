#include <iostream>

#include <boost/asio.hpp>

#include "tcp_server.hpp"

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
