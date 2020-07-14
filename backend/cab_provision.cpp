#include <boost/config.hpp>
#include <string>
#include <array>
#include <map>
#include <iterator>
#include <queue>
#include <memory>
#include <iostream>

#include "cab_provision.hpp"

typedef std::pair<node_id, node_id> Edge;
std::array<Edge, 17> edge_array{
    Edge(node_id::P0, node_id::D),
    
    Edge(node_id::P0, node_id::I4),
    Edge(node_id::P4, node_id::I4),

    Edge(node_id::I1, node_id::P0),
    Edge(node_id::I1, node_id::P4),

    Edge(node_id::P1, node_id::I1),
    Edge(node_id::P5, node_id::I1),

    Edge(node_id::I2, node_id::P1),
    Edge(node_id::I2, node_id::P5),

    Edge(node_id::P2, node_id::I2),
    Edge(node_id::P6, node_id::I2),

    Edge(node_id::I3, node_id::P2),
    Edge(node_id::I3, node_id::P6),

    Edge(node_id::P3, node_id::I3),
    Edge(node_id::P7, node_id::I3),

    Edge(node_id::I4, node_id::P3),
    Edge(node_id::I4, node_id::P7),
};

road_network::road_network() : 
    _g(edge_array.begin(), edge_array.end(), 13)
{
}

std::vector<node_id> road_network::get_predecessors(node_id node)
{
    std::vector<node_id> pre;
    graph::vertex_descriptor start = boost::vertex(node, _g);

    for (auto vd : boost::make_iterator_range(boost::adjacent_vertices(start, _g))) 
    {
        pre.push_back(static_cast<node_id>(vd));
    }
    return pre;
}


bool road_network::in_between(node_id start, node_id stop, node_id q)
{
    if(are_twins(start, q) || are_twins(stop, q) || are_twins(start, stop))
    {
        return false;
    }

    std::deque<node_id> queue;
    queue.push_back(start);

    while(!queue.empty())
    {
        node_id current = queue.front();
        queue.pop_front();

        if(current == stop || are_twins(current, stop))
        {
            break;
        }
        else if (current == q)
        {
            return true;
        }

        std::vector<node_id> vec = get_predecessors(current);
        for(auto n : vec)
        {
            queue.push_back(n);
        }
    }
    return false;
}

bool road_network::are_twins(node_id n1, node_id n2)
{
    switch (n1)
    {
        case node_id::P0:
            return n2 == node_id::P4;
        case node_id::P1:
            return n2 == node_id::P5;
        case node_id::P2:
            return n2 == node_id::P6;
        case node_id::P3:
            return n2 == node_id::P7;
        case node_id::P4:
            return n2 == node_id::P0;
        case node_id::P5:
            return n2 == node_id::P1;
        case node_id::P6:
            return n2 == node_id::P2;
        case node_id::P7:
            return n2 == node_id::P3;
        default:
            return false;
    }
}

bool road_network::is_inner(node_id n)
{
    switch (n)
    {
        case node_id::P0:
            return true;
        case node_id::P1:
            return true;
        case node_id::P2:
            return true;
        case node_id::P3:
            return true;
        default:
            return false;
    }
}

graph& road_network::get_graph()
{
    return _g;
}