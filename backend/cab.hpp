#pragma once

#include <cstdint>
#include <vector>
#include <map>
#include <memory>
#include <tuple>

#include <boost/uuid/uuid.hpp>

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

        std::uint32_t calculate_costs(node_id src, node_id dst);
        void add_request(node_id src, node_id dst, std::uint32_t passengers);
        void update_route(std::vector<node_id> new_route);
        void update_position(node_id position);
        std::vector<node_id> route();

    private:
        std::uint32_t _id = 0;
        std::uint32_t _passengers = 0; 
        node_id _position;

        std::shared_ptr<road_network> _rnet;

        std::vector<node_id> _route; 
        std::vector<std::tuple<node_id, node_id, std::uint32_t>> _requests;

        std::vector<std::pair<node_id, std::uint32_t>> _pickup; 
        std::vector<std::pair<node_id, std::uint32_t>> _deliver; 

        std::map<node_id, std::uint32_t> _passengers_at_node;
        std::map<node_id, std::uint32_t> _costs;

        std::size_t s_pos;
        std::size_t d_pos;
};
