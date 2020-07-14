#pragma once

#include <vector>
#include <memory>
#include <map>

#include "cab.hpp"
#include "cab_provision.hpp"

class cab_manager
{
    public:
        cab& create();
        std::shared_ptr<cab> cab_manager::cab_provision(node_id src, node_id dst);
    private:
        std::vector<std::unique_ptr<cab>> _cabs;
        std::map<node_id, std::vector<std::shared_ptr<cab>>> _cabs_at_node;

        road_network _rnet;
};
