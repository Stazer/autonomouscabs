#include <csignal>
#include <cstdlib>
#include <cstring>
#include <iostream>

#include <boost/asio/posix/stream_descriptor.hpp>
#include <boost/program_options.hpp>

#include "application.hpp"
// #include "cab_manager.hpp"

application::application():
    _cab_manager(),
    _io_context(),
    _cab_server(),
    _signals(_io_context, SIGINT),
    _command_descriptor(_io_context, STDIN_FILENO),
    _command_buffer()
{
    _signals.async_wait([this](const boost::system::error_code& error_code, int signal)
    {
        if(!error_code)
        {
            std::cout << "Received SIGINT\n";
            _io_context.stop();
        }
    });

    handle_command();
}

cab_manager& application::manager()
{
    return _cab_manager;
}

const class cab_manager& application::manager() const
{
    return _cab_manager;
}

int application::run(int argc, char** argv)
{
    std::uint16_t port = 0;

    boost::program_options::options_description options("Options");
    options.add_options()
        ("help", "shows this message")
        ("port", boost::program_options::value<std::uint16_t>(&port)->default_value(9876), "sets the cab server port");

    boost::program_options::variables_map variables;
    boost::program_options::store(boost::program_options::parse_command_line(argc, argv, options), variables);
    boost::program_options::notify(variables);

    if(variables.count("help"))
    {
        std::cout << options;
        return 0;
    }

    _cab_server = std::make_unique<cab_server>(*this, _io_context, port);

    _cab_server->run();
    _io_context.run();

    return 0;
}

void application::handle_command()
{
    boost::asio::async_read_until(_command_descriptor, _command_buffer, '\n', [this](const boost::system::error_code& error_code, std::size_t length)
    {
        _cab_manager.add_request(node_type::P1, node_type::P3, 4);
        _command_buffer.consume(length);
        handle_command();
    });
}
