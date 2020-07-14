#include "cab.hpp"

#include <deque>
#include <queue>
#include <iostream>

#include <boost/uuid/uuid_generators.hpp>

cab::cab(std::uint32_t id, std::shared_ptr<road_network> rnet):
    _id(id), _rnet(rnet)
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
    for(auto e: _route)
    {
        if(e == node)
        {
            return true;
        }
    }
    return false;
}

<<<<<<< HEAD
=======
bool cab::pickup_contains(node_id node)
{
    for(auto e: _pickup)
    {
        if(e == node)
        {
            return true;
        }
    }
    return false;
}

bool cab::deliver_contains(node_id node)
{
    for(auto e: _deliver)
    {
        if(e == node)
        {
            return true;
        }
    }
    return false;
}

void cab::add_request(node_id src, node_id dst)
{
    _pickup.push_back(src);
    _deliver.push_back(dst);

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

>>>>>>> b4d8948ca89509bec218977a6eb5eb9a0eb14261
void cab::set_route(std::vector<node_id> new_route)
{
    _route = new_route;
}
<<<<<<< HEAD
=======

int main(int argc, char **argv)
{
    road_network rnet;

    cab c(static_cast<std::uint32_t>(0), std::make_shared<road_network>(rnet));

    c.add_request(node_id::P0, node_id::P4);
    c.add_request(node_id::P2, node_id::P3);
    c.add_request(node_id::P3, node_id::P1);

    std::cout << c.passengers_at_node(node_id::P1) << '\n' << 
        c.passengers_at_node(node_id::P3) << '\n';
    return 0;
}
>>>>>>> b4d8948ca89509bec218977a6eb5eb9a0eb14261
