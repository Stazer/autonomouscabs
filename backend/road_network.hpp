#pragma once

#include <memory>
#include <vector>

#include <boost/graph/graph_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/property_map/property_map.hpp>

#include "node_type.hpp"

using graph = boost::adjacency_list<boost::listS, boost::vecS, 
        boost::directedS, node_type>;

class road_network
{
    public:
        road_network();

        std::vector<node_type> get_predecessors(node_type node);
        bool in_between(node_type start, node_type stop, node_type q);
        bool are_twins(node_type n1, node_type n2);
        bool is_inner(node_type n);
        bool is_pickup(node_type n);

        graph& get_graph();
    private:
        graph _g;
};
