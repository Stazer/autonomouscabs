#pragma once

<<<<<<< HEAD
#include "cab.hpp"
=======
#include <map>
#include <memory>
#include <vector>

#include <boost/graph/graph_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/property_map/property_map.hpp>
>>>>>>> b4d8948ca89509bec218977a6eb5eb9a0eb14261

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
<<<<<<< HEAD
    P7		
};


cab* cab_provision(node_id src, node_id dest);
=======
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

        graph& get_graph();
        
        // void cab_provision(node_id src, node_id dest, std::map<node_id, std::vector<std::shared_ptr<cab>>> map);
    private:
        graph _g;
        
        std::map<node_id, std::vector<node_id>> _predecessors;
};
>>>>>>> b4d8948ca89509bec218977a6eb5eb9a0eb14261
