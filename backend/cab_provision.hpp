#pragma once

#include <map>
#include <memory>
#include <vector>

#include <boost/graph/graph_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/property_map/property_map.hpp>

using node_id_base = std::uint8_t;

enum node_id : node_id_base
{
    D = 1,
    P0,
    I1,
    P1,
    I2,
    P2,
    I3,
    P3,
    I4,
    P4,
    P5,
    P6,
    P7,
};

using graph = boost::adjacency_list<boost::listS, boost::vecS, 
        boost::directedS, node_id>;
// using vertex_descriptor = boost::graph_traits<graph>::vertex_descriptor;

class road_network
{
    public:
        road_network();

        std::vector<node_id> get_predecessors(node_id node);
        bool in_between(node_id start, node_id stop, node_id q);
        bool are_twins(node_id n1, node_id n2);
        bool is_inner(node_id n);

        graph& get_graph();
        
        // void cab_provision(node_id src, node_id dest, std::map<node_id, std::vector<std::shared_ptr<cab>>> map);
    private:
        graph _g;
        
        std::map<node_id, std::vector<node_id>> _predecessors;
};