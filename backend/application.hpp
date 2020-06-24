#pragma once

#include <boost/asio.hpp>

#include "tcp_server.hpp"
#include "cab_session.hpp"
#include "cab_manager.hpp"
#include "web_session.hpp"

class application
{
    public:
        application();

        cab_manager& cab_manager();
        const class cab_manager& cab_manager() const;

        int run(int argc, char** argv);

    private:
        class cab_manager _cab_manager;

        boost::asio::io_context _io_context;
        tcp_server<cab_session> _cab_session_server;
        tcp_server<web_session> _web_session_server;
};
