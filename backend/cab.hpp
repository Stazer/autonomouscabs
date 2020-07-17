#pragma once

#include <cstdint>
#include <vector>
#include <memory>

#include <boost/uuid/uuid.hpp>

#include "road_network.hpp"
#include "request.hpp"
#include "id_type.hpp"
#include "node_type.hpp"

class cab_manager;
class cab_session;

class cab
{
    public:
        cab(std::weak_ptr<cab_session> cab_session, cab_manager& cab_manager, id_type id, road_network* rnet);

        id_type id() const;
        std::uint32_t passengers();
        std::vector<node_type> route();
        std::uint32_t costs();
        node_type position();

        std::uint32_t passengers_at_node(node_type node);

        bool route_contains(node_type node);
        std::pair<bool, bool> route_contains_ordered(node_type src, node_type dst);

        std::int32_t calculate_costs(node_type src, node_type dst);
        void add_request(node_type src, node_type dst, std::uint32_t passengers);
        void update_route(std::vector<node_type> new_route);
        void update_position(node_type position);

    private:
        id_type _id = 0;
        std::uint32_t _passengers = 0;
        node_type _position;
        std::uint32_t _costs;

        road_network* _rnet;

        std::vector<node_type> _route;
        std::vector<request> _requests;

        std::weak_ptr<cab_session> _cab_session;
        cab_manager* _cab_manager;
};
