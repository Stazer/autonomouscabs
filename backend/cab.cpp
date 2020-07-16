#include "cab.hpp"

#include <deque>
#include <queue>
#include <iostream>

#include <boost/uuid/uuid_generators.hpp>

cab::cab(std::uint32_t id, std::shared_ptr<road_network> rnet):
    _id(id), _position(node_id::D), _rnet(rnet), _costs(0)
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


std::uint32_t cab::costs()
{
    return _costs;
}

node_id cab::position()
{
    return _position;
}

std::uint32_t cab::passengers_at_node(node_id node)
{
    std::uint32_t passengers = 0;
    for(auto r : _requests)
    {
        if(_rnet->in_between(_position, r.dst(), r.src()) &&
                _rnet->in_between(r.src(), r.dst(), node))
        {
            std::cout << "if\n";
            passengers += r.passengers();
        }
        else if(_rnet->in_between(r.src(), r.dst(), _position) && r.picked_up() && _rnet->in_between(_position, r.dst(), node))
        {
            std::cout << "else\n";
            passengers += r.passengers();
        }
    }
    
    return passengers;
}

bool cab::route_contains(node_id node)
{
    auto it = std::find(_route.begin(), _route.end(), node);
    return it != _route.end();
}

std::pair<bool, bool> cab::route_contains_ordered(node_id src, node_id dst)
{
    bool found_src = false, found_dst = false;
    for(auto n : _route)
    {
        found_src = src == n || found_src;
        found_dst = dst == n && found_src || found_dst;

        if(found_src && found_dst)
        {
            break;
        }
    }

    return std::pair<bool, bool> (found_src, found_dst);
}

std::int32_t cab::calculate_costs(node_id src, node_id dst)
{
    // check if the cab already has src and dst in that order in its requests
    std::pair<bool, bool> pair = route_contains_ordered(src, dst);
    bool found_src = pair.first;
    bool found_dst = pair.second;

    if(found_src && found_dst)
    {
        return _costs;
    }

    // calculate max detour costs and return the difference between max and current _costs
    std::uint32_t max = 0;
    for(auto r : _requests)
    {
        std::uint32_t cost = r.detours();
        bool is_inner = _rnet->is_inner(src); 
        if(!found_src && (_rnet->in_between(_position, r.src(), src) || 
                _rnet->in_between(r.src(), r.dst(), src)))
        {
            cost = is_inner ? cost + 1 : cost + 2;
        }

        is_inner = _rnet->is_inner(dst); 
        if(!found_dst && (_rnet->in_between(_position, r.src(), dst) || 
                _rnet->in_between(r.src(), r.dst(), dst)))
        {
            cost = is_inner ? cost + 1 : cost + 2;
        }
        
        max = cost > max ? cost : max;
    }

    return max;
}

void cab::add_request(node_id src, node_id dst, std::uint32_t passengers)
{
    for(std::size_t i = 0; i < _requests.size(); ++i)
    {   
        if(_requests[i].src() == src && _requests[i].dst() == dst)
        {
            _requests[i].add_passengers(passengers);
            return;
        }
    }

    std::pair<bool, bool> pair = route_contains_ordered(src, dst);
    bool found_src = pair.first;
    bool found_dst = pair.second;

    // add detours to all requests
    std::uint32_t max = 0;
    for(std::size_t i = 0; i < _requests.size(); ++i)
    {
        bool is_inner = _rnet->is_inner(src); 
        if(!found_src && (_rnet->in_between(_position, _requests[i].src(), src) || 
                _rnet->in_between(_requests[i].src(), _requests[i].dst(), src)))
        {
            std::uint32_t cost = is_inner ? 1 : 2;
            _requests[i].add_detours(cost);
        }

        is_inner = _rnet->is_inner(dst); 
        if(!found_dst && (_rnet->in_between(_position, _requests[i].src(), dst) || 
                _rnet->in_between(_requests[i].src(), _requests[i].dst(), dst)))
        {
            std::uint32_t cost = is_inner ? 1 : 2;
            _requests[i].add_detours(cost);
        }
        
        max = _requests[i].detours() > max ? _requests[i].detours() : max;
    }
    _costs = max > _costs ? max : _costs; 

    _requests.push_back(request(src, dst, passengers));
}

void cab::update_position(node_id position)
{
    _position = position;
    for(std::size_t i = 0; i < _requests.size(); ++i)
    {
        if(_requests[i].src() == position)
        {
            _passengers += _requests[i].passengers();
            _requests[i].pick_up();
        }

        if(_requests[i].dst() == position)
        {
            _passengers -= _requests[i].passengers();
            _requests.erase(_requests.begin() + i);
        }
    }
}

void cab::update_route(std::vector<node_id> new_route)
{
    _route = new_route;
}

std::vector<node_id> cab::route()
{
    return _route;
}