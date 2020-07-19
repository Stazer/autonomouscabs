#include <csignal>
#include <cstdlib>
#include <cstring>
#include <iostream>

#include <boost/asio/posix/stream_descriptor.hpp>
#include <boost/program_options.hpp>

#include "application.hpp"
#include "node_type.hpp"

application::application():
    _cab_manager(),
    _io_service(),
    _cab_server(),
    _signals(_io_service, SIGINT),
    _command_descriptor(_io_service, STDIN_FILENO),
    _command_buffer()
{
    _signals.async_wait([this](const boost::system::error_code& error_code, int signal)
    {
        if(!error_code)
        {
            std::cout << "Received SIGINT\n";
            _io_service.stop();
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

    _cab_server = std::make_unique<cab_server>(*this, _io_service, port);

    _cab_server->run();
    _io_service.run();

    return 0;
}

void application::handle_command()
{
    boost::asio::async_read_until(_command_descriptor, _command_buffer, '\n', [this](const boost::system::error_code& error_code, std::size_t length)
    {
        std::istream is(&_command_buffer);
        std::string in;
        is >> in;
        std::string src_string, dst_string;

        for(auto c : in)
        {
            if(c == ' ')
            {
                break;
            }
            src_string += c;
        }

        std::pair<bool, node_type> pair = string_to_node(src_string);
        if(pair.first == false)
        {
            std::cout << "wrong input, only D, P0, ..., P7, I1, ..., I4 allowed\n";
            
        }

        _command_buffer.consume(length);
        handle_command();
    });
}
