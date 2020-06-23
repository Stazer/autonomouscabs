#include <iostream>

#include <boost/asio.hpp>

#include "tcp_server.hpp"
#include "cab_session.hpp"
#include "web_session.hpp"

int main(int argc, char *argv[])
{
    std::cout << "Autonomous Cabs Backend\n";

    try
    {
        boost::asio::io_context io_context;
        tcp_server<cab_session> cab_session_server(io_context, 9875);
        tcp_server<web_session> web_session_server(io_context, 9876);

        cab_session_server.run();
        web_session_server.run();

        io_context.run();
    }
    catch(std::exception& e)
    {
        std::cerr << "Critital error\n" << e.what() << std::endl;
        std::cerr << "Program terminated" << std::endl;
    }

    return 0;
}
