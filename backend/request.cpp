#include "request.hpp"

request::request(node_type src, node_type dst, std::uint32_t passengers) :
    _src(src), _dst(dst), _passengers(passengers), _detours(0)
{
}

node_type request::src()
{
    return _src;
}

node_type request::dst()
{
    return _dst;
}

std::uint32_t request::passengers()
{
    return _passengers;
}

std::uint32_t request::detours()
{
    return _detours;
}


bool request::picked_up()
{
    return _picked_up;
}

void request::add_passengers(std::uint32_t passengers)
{
    _passengers += passengers;
}

void request::add_detours(std::uint32_t detours)
{
    _detours += detours;
}


void request::pick_up()
{
    _picked_up = true;
}