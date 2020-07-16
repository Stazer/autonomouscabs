#pragma once

#include <boost/asio.hpp>

#include "cab_server.hpp"
#include "cab_manager.hpp"

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
        cab_server _cab_server;
};
