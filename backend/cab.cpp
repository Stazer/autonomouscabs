#include "cab.hpp"

#include <deque>
#include <queue>
#include <iostream>

#include <boost/uuid/uuid_generators.hpp>

std::ostream& operator<<(std::ostream& stream, node_id id)
{
    const std::array<std::string, 13> name = { "D", "P0", "I1", "P1", "I2", "P2", "I3", "P3", "I4", "P4", "P5", "P6", "P7"};
    stream << name[id - 1];
    return stream;
}

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

std::uint32_t cab::passengers_at_node(node_id node)
{
    std::uint32_t passengers = 0;
    for(auto r : _requests)
    {
        if(_rnet->in_between(_position, r.dst(), r.src()) &&
                _rnet->in_between(r.src(), r.dst(), node))
        {
            passengers += r.passengers();
        }
        else if(_rnet->in_between(r.src(), r.dst(), _position) && r.picked_up() && _rnet->in_between(_position, r.dst(), node))
        {
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

std::int32_t cab::calculate_costs(node_id src, node_id dst)
{
    // check if the cab already has src and dst in that order in its requests
    bool found_src = false, found_dst = false;
    for(auto r : _requests)
    {
        found_src = (r.src() == src || r.dst() == src) || found_src;
        found_dst = ((r.src() == dst || r.dst() == dst) && found_src) || found_dst;
        if(found_src && found_dst)
        {
            return 0;
        }
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

    return max - _costs;
}

void cab::add_request(node_id src, node_id dst, std::uint32_t passengers)
{
    bool found_src = false, found_dst = false;
    for(std::size_t i = 0; i < _requests.size(); ++i)
    {   
        if(_requests[i].src() == src && _requests[i].dst() == dst)
        {
            _requests[i].add_passengers(passengers);
            return;
        }

        request r = _requests[i];
        found_src = (r.src() == src || r.dst() == src) || found_src;
        found_dst = ((r.src() == dst || r.dst() == dst) && found_src) || found_dst;
        if(found_src && found_dst)
        {
            break;
        }
    }

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

int main(int argc, char **argv)
{
    road_network rnet;

    cab c(static_cast<std::uint32_t>(0), std::make_shared<road_network>(rnet));

    // c.add_request(node_id::P0, node_id::P4, 3);
    // c.add_request(node_id::P1, node_id::P2, 4);
    // c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, I4, P4});
    // c.update_position(node_id::P0);
    // c.update_position(node_id::I1);
    // c.update_position(node_id::P1);
    // c.update_position(node_id::I2);
    // c.update_position(node_id::P2);
    // std::cout << "P1: " << c.passengers_at_node(P1) << ", P3: " << c.passengers_at_node(P3) << '\n';

    std::size_t cost = c.calculate_costs(node_id::P0, node_id::P3);
    c.add_request(node_id::P0, node_id::P3, 1);
    std::cout << "cost: " << cost << std::endl;

    c.update_route(std::vector<node_id> {P0, I1, I2, I3, P3});

    cost = c.calculate_costs(node_id::P1, node_id::P2);
    c.add_request(node_id::P1, node_id::P2, 1);
    std::cout << "cost: " << cost << std::endl;

    c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3});

    cost = c.calculate_costs(node_id::P1, node_id::P4);
    c.add_request(node_id::P1, node_id::P4, 1);
    std::cout << "cost: " << cost << std::endl;

    c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3, I4, P4});

    cost = c.calculate_costs(node_id::P2, node_id::P4);
    c.add_request(node_id::P2, node_id::P4, 1);
    std::cout << "cost: " << cost << std::endl;
    
    // c.add_request(node_id::P2, node_id::P3);
    // c.add_request(node_id::P3, node_id::P1);
    return 0;
}
