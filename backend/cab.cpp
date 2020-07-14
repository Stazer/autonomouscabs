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
    _id(id), _position(node_id::D), _rnet(rnet), s_pos(0), d_pos(0)
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

std::uint32_t cab::passengers_at_node(node_id node)
{
    std::deque<node_id> queue;
    queue.push_back(node);
    while(!queue.empty())
    {
        node_id current = queue.front();
        queue.pop_front();

        if(_pasengers_at_node.find(current) == _pasengers_at_node.end())
        {
            std::vector<node_id> vec = _rnet->get_predecessors(current);
            for(auto n : vec)
            {
                auto it = std::find(queue.begin(), queue.end(), n);
                if(it == queue.end())
                {
                    queue.push_back(n);
                }
            }

            // we are back at src
            if(current == node)
            {
                return 0;
            }

            continue;
        }

        // found the predecessor with a pessenger count
        return _pasengers_at_node[current];
    }
    return 0;
}

bool cab::route_contains(node_id node)
{
    auto it = std::find(_route.begin(), _route.end(), node);
    return it != _route.end();
}

bool cab::pickup_contains(node_id node)
{
    auto it = std::find(_pickup.begin(), _pickup.end(), node);
    return it != _pickup.end();
}

bool cab::deliver_contains(node_id node)
{
    auto it = std::find(_deliver.begin(), _deliver.end(), node);
    return it != _deliver.end();
}

std::size_t cab::calculate_costs(node_id src, node_id dst)
{
    bool contains_src = route_contains(src);
    bool contains_dst = route_contains(dst);
    bool s_done = false, d_done = false;
    _route.insert(_route.begin(), _position);
    std::size_t i = 1;
    if(!contains_src)
    {
        for(; i < _route.size(); ++i)
        {
            node_id one = _route[i - 1];
            node_id two = _route[i];

            if(_rnet->in_between(two, one, src))
            {
                s_pos = i - 1;
                s_done = true;

                if(!contains_dst && _rnet->in_between(two, src, dst))
                {
                    d_pos = i;
                    d_done = true;
                    i = _route.size();
                }
                else
                {
                    i += 1;
                }
                
                break;
            }
        }
    }

    if(!contains_dst)
    {
        for(; i < _route.size(); ++i)
        {
            node_id one = _route[i - 1];
            node_id two = _route[i];

            if(_rnet->in_between(two, one, dst))
            {
                d_pos = i - 1;
                d_done = true;
                break;
            }
        }
    }

    if(!s_done)
    {
        s_pos = i - 1;
        d_pos = s_pos + 1;
    } 
    else if (!d_done)
    {
        d_pos = i;
    }
    _route.erase(_route.begin());

    // get the costs to get to every node without changing the value in _costs
    // if node is inner increase costs by 1, if node is outer increase costs by two
    i = s_pos;
    if(contains_src)
    {
        std::cout << "contains src" << '\n';
        i = d_pos - 1;
    }

    if(contains_dst)
    {
        std::cout << "contains dst" << '\n';
        i = _route.size();
    }
    std::size_t max = 0;
    for(; i < _route.size(); ++i)
    {
        std::cout << "i: " << i << '\n';
        std::size_t cost = 0;
        if(_costs.find(_route[i]) != _costs.end())
        {
            cost = _costs[_route[i]];
        }

        bool is_inner = _rnet->is_inner(src);
        cost = is_inner ? cost + 1 : cost + 2;

        if(i > d_pos - 2)
        {
            is_inner = _rnet->is_inner(dst);
            cost = is_inner ? cost + 1 : cost + 2;
        }
        
        max = cost > max ? cost : max;
    }

    return max;
}

void cab::add_request(node_id src, node_id dst)
{
    // set the costs to include the src, dst pair in _route
    for(std::size_t i = s_pos; i < _route.size(); ++i)
    {
        std::size_t cost = 0;
        if(_costs.find(_route[i]) != _costs.end())
        {
            cost = _costs[_route[i]];
        }

        bool is_inner = _rnet->is_inner(src);
        cost = is_inner ? cost + 1 : cost + 2;

        if(i > d_pos - 2)
        {
            is_inner = _rnet->is_inner(dst);
            cost = is_inner ? cost + 1 : cost + 2;
        }

        _costs[_route[i]] = cost;
    }

    // update the passenger count at every node between src and dst
    std::uint32_t n_pass = passengers_at_node(src);
    _pasengers_at_node[src] = n_pass + 1;

    std::deque<node_id> queue;
    std::vector<node_id> pre = _rnet->get_predecessors(dst);

    for(auto n : pre)
    {
        queue.push_back(n);
    }

    while(!queue.empty())
    {
        node_id current = queue.front();
        queue.pop_front();

        if(current != dst)
        {
            std::uint32_t n_pass = passengers_at_node(current);
            _pasengers_at_node[current] = n_pass + 1;
            std::vector<node_id> vec = _rnet->get_predecessors(current);
            for(auto n : vec)
            {
                auto it = std::find(queue.begin(), queue.end(), n);
                if(it == queue.end())
                {
                    queue.push_back(n);
                }
            }
        }

        if(queue.front() == src)
        {
            break;
        }
    }
    
}

void cab::set_route(std::vector<node_id> new_route)
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

    std::size_t cost = c.calculate_costs(node_id::P0, node_id::P3);
    c.add_request(node_id::P0, node_id::P3);
    std::cout << "cost: " << cost << std::endl;

    c.set_route(std::vector<node_id> {P0, I1, I2, I3, P3});

    cost = c.calculate_costs(node_id::P1, node_id::P2);
    c.add_request(node_id::P1, node_id::P2);
    std::cout << "cost: " << cost << std::endl;

    c.set_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3});

    cost = c.calculate_costs(node_id::P1, node_id::P4);
    c.add_request(node_id::P1, node_id::P4);
    std::cout << "cost: " << cost << std::endl;

    c.set_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3, I4, P4});

    for(auto n : c.route())
    {
        std::cout << n << '\n';
    }
    
    // c.add_request(node_id::P2, node_id::P3);
    // c.add_request(node_id::P3, node_id::P1);
    return 0;
}