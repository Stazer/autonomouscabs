#include "cab.hpp"

#include <deque>
#include <queue>
#include <iostream>

#include <boost/uuid/uuid_generators.hpp>

#include "cab_manager.hpp"
#include "cab_session.hpp"

cab::cab(std::weak_ptr<cab_session> cab_session, cab_manager& cab_manager, id_type id, road_network* rnet) :
    _cab_session(cab_session),
    _cab_manager(&cab_manager),
    _id(id),
    _costs(0),
    _rnet(rnet),
    _position(node_type::D)
{
}

id_type cab::id() const
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

node_type cab::position()
{
    return _position;
}

// passengers_at_node counts/calculates the current number of passengers at a specific node in the environment
std::uint32_t cab::passengers_at_node(node_type node)
{
    std::uint32_t passengers = 0;
    for(auto r : _requests)
    {
        // add to passengers either if r.src() -> node -> r.dst() and _position -> r.src() -> r.dst()
        // or r.src() -> _position -> r.dst() and cab has picked up passengers at position and _position -> node -> r.dst()
        if(_rnet->in_between(_position, r.dst(), r.src()) &&
                _rnet->in_between(r.src(), r.dst(), node))
        {
            passengers += r.passengers();
        }
        else if(_rnet->in_between(r.src(), r.dst(), _position) && r.picked_up() && _rnet->in_between(_position, r.dst(), node))
        { 
            passengers += r.passengers();
        }

        // if r.dst() == node it still gets counted above
        if(r.dst() == node)
        {
            passengers -= r.passengers();
        }
    }
    
    return passengers;
}

bool cab::route_contains(node_type node)
{
    auto it = std::find(_route.begin(), _route.end(), node);
    return it != _route.end();
}

// returns if route contins src and dst, if both elements in pair are true
// src and dst are in order
std::pair<bool, bool> cab::route_contains_ordered(node_type src, node_type dst)
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

std::int32_t cab::calculate_costs(node_type src, node_type dst)
{
    // check if the cab already has src and dst in that order in its requests
    std::pair<bool, bool> pair = route_contains_ordered(src, dst);
    bool found_src = pair.first;
    bool found_dst = pair.second;

    if(found_src && found_dst)
    {
        return _costs;
    }

    // calculate and return max detour costs
    std::uint32_t max = 0;
    for(auto r : _requests)
    {
        std::uint32_t cost = r.detours();
        bool is_inner = _rnet->is_inner(src); 
        // if cab stops at src before r.src() add 1 to r.detours() if src is on a inner edge
        // add 2 to r.detours() if src is on a outer edge
        // this accounts for the longer drive
        if(!found_src && (_rnet->in_between(_position, r.src(), src) || 
                _rnet->in_between(r.src(), r.dst(), src)))
        {
            cost = is_inner ? cost + 1 : cost + 2;
        }

        is_inner = _rnet->is_inner(dst); 
        // same as above but with dst
        if(!found_dst && (_rnet->in_between(_position, r.src(), dst) || 
                _rnet->in_between(r.src(), r.dst(), dst)))
        {
            cost = is_inner ? cost + 1 : cost + 2;
        }
        
        max = cost > max ? cost : max;
    }

    return max;
}

// adds a new passenger request to this cab
void cab::add_request(node_type src, node_type dst, std::uint32_t passengers)
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
    // does the sme as calculate costs
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

    // inform external controller
    if(auto shared = _cab_session.lock())
    {
        shared->send_request(_requests.back());
    }
}

// updates the postion and requests of the cab according to the detected node
void cab::update_position(node_type position)
{
    _cab_manager->update_cab(_id, _position, position);
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

void cab::update_route(std::vector<node_type> new_route)
{
    _route = new_route;
}

std::vector<node_type> cab::route()
{
    return _route;
}