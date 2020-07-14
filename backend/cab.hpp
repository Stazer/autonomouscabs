#pragma once

#include <cstdint>
#include <vector>
#include <map>
#include <memory>

#include <boost/uuid/uuid.hpp>
#include "cab_provision.hpp"

#include "cab_provision.hpp"

class road_network;

class cab
{
    public:
        cab(std::uint32_t id, std::shared_ptr<road_network> rnet);

        std::uint32_t id() const;
        std::uint32_t passengers();

        std::uint32_t passengers_at_node(node_id node);

        bool route_contains(node_id node);
        bool pickup_contains(node_id node);
        bool deliver_contains(node_id node);

        void add_request(node_id src, node_id dst);
        void set_route(std::vector<node_id> new_route);

    private:
        std::uint32_t _id = 0;
        std::uint32_t _passengers = 0; 
<<<<<<< HEAD
        std::vector<node_id> _route; 
=======

        std::shared_ptr<road_network> _rnet;

        std::vector<node_id> _route; 
        std::vector<node_id> _pickup; 
        std::vector<node_id> _deliver; 

        std::map<node_id, std::uint32_t> _pasengers_at_node;
>>>>>>> b4d8948ca89509bec218977a6eb5eb9a0eb14261
};
