#pragma once

#include <unordered_map>
#include <memory>
#include <map>

#include "id_type.hpp"
#include "road_network.hpp"
#include "cab.hpp"
#include "cab_session.hpp"

class cab_manager
{
    public:
        cab& create(std::weak_ptr<cab_session> cab_session);

        void remove(cab& cab);
        void remove(id_type id);

        std::shared_ptr<cab> cab_provision(node_id src, node_id dst, std::uint32_t passengers);
        void update_cab(id_type id, node_id from, node_id to);
        std::vector<std::weak_ptr<cab>> cabs_at_node(node_id node);
    private:
        std::unordered_map<id_type, std::shared_ptr<cab>> _cabs;
        id_type _counter = 0;

        std::map<node_id, std::vector<std::weak_ptr<cab>>> _cabs_at_node;
        road_network _rnet;
};
