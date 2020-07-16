#include "application.hpp"

#include <boost/program_options.hpp>

cab_manager& application::cab_manager()
{
    return _cab_manager;
}

const class cab_manager& application::cab_manager() const
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
