#include "application.hpp"

application::application():
    _cab_session_server(_io_context, 9875, *this),
    _web_session_server(_io_context, 9876, *this)
{
}

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
    _cab_session_server.run();
    _web_session_server.run();

    _io_context.run();

    return 0;
}
