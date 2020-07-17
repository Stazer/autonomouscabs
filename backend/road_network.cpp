#include <boost/config.hpp>
#include <string>
#include <array>
#include <map>
#include <iterator>
#include <queue>
#include <memory>
#include <iostream>

#include "road_network.hpp"

typedef std::pair<node_type, node_type> Edge;
std::array<Edge, 17> edge_array{
    Edge(node_type::P0, node_type::I4),
    
    Edge(node_type::P0, node_type::D),
    Edge(node_type::P4, node_type::I4),

    Edge(node_type::I1, node_type::P0),
    Edge(node_type::I1, node_type::P4),

    Edge(node_type::P1, node_type::I1),
    Edge(node_type::P5, node_type::I1),

    Edge(node_type::I2, node_type::P1),
    Edge(node_type::I2, node_type::P5),

    Edge(node_type::P2, node_type::I2),
    Edge(node_type::P6, node_type::I2),

    Edge(node_type::I3, node_type::P2),
    Edge(node_type::I3, node_type::P6),

    Edge(node_type::P3, node_type::I3),
    Edge(node_type::P7, node_type::I3),

    Edge(node_type::I4, node_type::P3),
    Edge(node_type::I4, node_type::P7),
};

road_network::road_network() : 
    _g(edge_array.begin(), edge_array.end(), 13)
{
}

std::vector<node_type> road_network::get_predecessors(node_type node)
{
    std::vector<node_type> pre;
    graph::vertex_descriptor start = boost::vertex(node, _g);

    for (auto vd : boost::make_iterator_range(boost::adjacent_vertices(start, _g))) 
    {
        pre.push_back(static_cast<node_type>(vd));
    }
    return pre;
}


bool road_network::in_between(node_type start, node_type stop, node_type q)
{
    if(are_twins(start, q) || are_twins(stop, q))
    {
        return false;
    }

    /* if((start == node_type::D && q == node_type::P4) || (start == node_type::P4 && q == node_type::D))
    {
        return false;
    } */

    if(are_twins(start, stop) || start == q || stop == q)
    {
        return true;
    }

    std::deque<node_type> queue;
    queue.push_back(stop);

    while(!queue.empty())
    {
        node_type current = queue.front();
        queue.pop_front();

        if (current == q)
        {
            return true;
        }

        std::vector<node_type> vec = get_predecessors(current);
        for(auto n : vec)
        {
            queue.push_back(n);
        }

        if (queue.front() == start || are_twins(queue.front(), start))
        {
            break;
        }
    }
    return false;
}

bool road_network::are_twins(node_type n1, node_type n2)
{
    switch (n1)
    {
        case node_type::P0:
            return n2 == node_type::P4;
        case node_type::P1:
            return n2 == node_type::P5;
        case node_type::P2:
            return n2 == node_type::P6;
        case node_type::P3:
            return n2 == node_type::P7;
        case node_type::P4:
            return n2 == node_type::P0;
        case node_type::P5:
            return n2 == node_type::P1;
        case node_type::P6:
            return n2 == node_type::P2;
        case node_type::P7:
            return n2 == node_type::P3;
        default:
            return false;
    }
}

bool road_network::is_inner(node_type n)
{
    switch (n)
    {
        case node_type::P0:
            return true;
        case node_type::P1:
            return true;
        case node_type::P2:
            return true;
        case node_type::P3:
            return true;
        default:
            return false;
    }
}


bool road_network::is_pickup(node_type n)
{
    switch(n)
    {
        case node_type::P0:
            return true;
        case node_type::P1:
            return true;
        case node_type::P2:
            return true;
        case node_type::P3:
            return true;
        case node_type::P4:
            return true;
        case node_type::P5:
            return true;
        case node_type::P6:
            return true;
        case node_type::P7:
            return true;
        default:
            return false;
    }
}

graph& road_network::get_graph()
{
    return _g;
}