#include <boost/config.hpp>
#include <string>
#include <array>
#include <map>
#include <iterator>
#include <queue>
#include <memory>
#include <iostream>

#include "cab_provision.hpp"

const std::array<std::string, 14> name = {"null", "D", "P0", "I1", "P1", "I2", "P2", "I3", "P3", "I4", "P4", "P5", "P6", "P7"};
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

graph& road_network::get_graph()
{
    return _g;
}