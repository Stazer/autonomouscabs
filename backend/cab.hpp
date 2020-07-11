#pragma once

#include <cstdint>
#include <vector>

#include <boost/uuid/uuid.hpp>
#include "cab_provision.hpp"

class cab
{
    public:
        cab(std::uint32_t id);

        std::uint32_t id() const;
        std::uint32_t passengers(); 

        bool in_route(node_id node);
        void set_route(std::vector<node_id> new_route);

    private:
        std::uint32_t _id = 0;
        std::uint32_t _passengers = 0; 
        std::vector<node_id> _route; 
};
