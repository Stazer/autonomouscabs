#pragma once

#include "node_type.hpp"

class request
{
    public:
        request(node_type src, node_type dst, std::uint32_t passengers);

        node_type src();
        node_type dst();
        std::uint32_t passengers();
        std::uint32_t detours();
        bool picked_up();

        void add_passengers(std::uint32_t passengers);
        void add_detours(std::uint32_t detours);
        void pick_up();

    private:
        node_type _src, _dst;
        std::uint32_t _passengers;
        std::uint32_t _detours;
        bool _picked_up;
};