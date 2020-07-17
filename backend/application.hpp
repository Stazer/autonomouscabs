#pragma once

#include <boost/asio.hpp>

#include "cab_server.hpp"
#include "cab_manager.hpp"

class application
{
    public:
        application();

        cab_manager& manager();
        const class cab_manager& manager() const;

        int run(int argc, char** argv);

    private:
        class cab_manager _cab_manager;

        boost::asio::io_service _io_service;
        std::unique_ptr<cab_server> _cab_server;

        boost::asio::signal_set _signals;
        
        boost::asio::posix::stream_descriptor _command_descriptor;
        boost::asio::streambuf _command_buffer;

        void handle_command();
};
