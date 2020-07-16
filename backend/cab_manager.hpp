#pragma once

#include <vector>
#include <memory>
#include <map>

#include "cab.hpp"
#include "road_network.hpp"

class cab_manager
{
    public:
        cab& create();
        std::shared_ptr<cab> cab_provision(node_id src, node_id dst, std::uint32_t passengers);
        void update_cab(std::uint32_t id, node_id node);
        std::vector<std::shared_ptr<cab>> cabs_at_node(node_id node);
    private:
        std::vector<std::shared_ptr<cab>> _cabs;
        std::map<node_id, std::vector<std::shared_ptr<cab>>> _cabs_at_node;

        road_network _rnet;
};
