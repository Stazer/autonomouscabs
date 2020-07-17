#pragma once

#include <unordered_map>
#include <memory>
#include <map>

#include "id_type.hpp"
#include "node_type.hpp"
#include "road_network.hpp"
#include "cab.hpp"
#include "cab_session.hpp"

class cab_manager
{
    public:
        cab& create(std::weak_ptr<cab_session> cab_session);

        void remove(cab& cab);
        void remove(id_type id);

        void add_request(node_type src, node_type dst, std::uint32_t passengers);
        void update_cab(id_type id, node_type from, node_type to);

        std::shared_ptr<cab> find_cab(node_type src, node_type dst, std::uint32_t passengers);
        std::vector<std::weak_ptr<cab>> cabs_at_node(node_type node);
    private:
        std::unordered_map<id_type, std::shared_ptr<cab>> _cabs;
        id_type _counter = 0;

        std::map<node_type, std::vector<std::weak_ptr<cab>>> _cabs_at_node;
        road_network _rnet;
};
