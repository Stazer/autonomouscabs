#pragma once

#include "road_network.hpp"

class request
{
    public:
        request(node_id src, node_id dst, std::uint32_t passengers);

        node_id src();
        node_id dst();
        std::uint32_t passengers();
        std::uint32_t detours();
        bool picked_up();

        void add_passengers(std::uint32_t passengers);
        void add_detours(std::uint32_t detours);
        void pick_up();

    private:
        node_id _src, _dst;
        std::uint32_t _passengers;
        std::uint32_t _detours;
        bool _picked_up;
};