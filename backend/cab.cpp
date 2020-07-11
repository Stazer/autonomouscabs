#include "cab.hpp"

#include <boost/uuid/uuid_generators.hpp>

cab::cab(std::uint32_t id):
    _id(id)
{
}

std::uint32_t cab::id() const
{
    return _id;
}

std::uint32_t cab::passengers()
{
    return _passengers;
}

bool cab::in_route(node_id node)
{
    for(auto e: _route)
    {
        if(e == node)
        {
            return true;
        }
    }
    return false;
}

void cab::set_route(std::vector<node_id> new_route)
{
    _route = new_route;
}
