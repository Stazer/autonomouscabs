#include <boost/config.hpp>
#include <iostream>
#include <fstream>
#include <string>
#include <array>

#include <boost/graph/graph_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/dijkstra_shortest_paths.hpp>
#include <boost/property_map/property_map.hpp>

#include "cab.hpp"
#include "cab_provision.hpp"

cab* cab_provision(node_id src, node_id dest)
{
    // typedef boost::adjacency_list<boost::setS, boost::vecS,
    //     boost::undirectedS> graph;
    // graph g;

    // boost::add_edge(node_id::D, node_id::P0, g);


    typedef boost::adjacency_list<boost::listS, boost::vecS, boost::directedS, boost::no_property,
        boost::property<boost::edge_weight_t, int>>
        graph_t;
    typedef boost::graph_traits<graph_t>::vertex_descriptor vertex_descriptor;
    typedef std::pair<node_id, node_id> Edge;

    const int num_nodes = 13;
    
    std::string name[] = { "null", "D", "P0",
    "I1",
    "P1",
    "I2",
    "P2",
    "I3",
    "P3",
    "I4",
    "P4",
    "P5",
    "P6",
    "P7"};

    // std::array<Edge, 22> edge_array = {
    //     Edge(node_id::D, node_id::P0),
    //     Edge(node_id::P0, node_id::D),
    //     Edge(node_id::P0, node_id::I1),
    //     Edge(node_id::I1, node_id::P1),
    //     Edge(node_id::I1, node_id::P5),
    //     Edge(node_id::P1, node_id::I2),
    //     Edge(node_id::P5, node_id::I2),
    //     Edge(node_id::I2, node_id::P2),
    //     Edge(node_id::I2, node_id::P6),
    //     Edge(node_id::P2, node_id::I3),
    //     Edge(node_id::P6, node_id::I3),
    //     Edge(node_id::I3, node_id::P3),
    //     Edge(node_id::I3, node_id::P7),
    //     Edge(node_id::P3, node_id::I4),
    //     Edge(node_id::P7, node_id::I4),
    //     Edge(node_id::I4, node_id::P0),
    //     Edge(node_id::I4, node_id::P4),
    //     Edge(node_id::P4, node_id::I1)
    // };

    std::array<Edge, 22> edge_array = {
        Edge(node_id::D, node_id::P0),
        Edge(node_id::P0, node_id::D),
        Edge(node_id::I1, node_id::P0),
        Edge(node_id::P1, node_id::I1),
        Edge(node_id::P5, node_id::I1),
        Edge(node_id::I2, node_id::P1),
        Edge(node_id::I2, node_id::P5),
        Edge(node_id::P2, node_id::I1),
        Edge(node_id::P6, node_id::I2),
        Edge(node_id::I3, node_id::P2),
        Edge(node_id::I3, node_id::P6),
        Edge(node_id::P3, node_id::I3),
        Edge(node_id::P7, node_id::I3),
        Edge(node_id::I4, node_id::P3),
        Edge(node_id::I4, node_id::P7),
        Edge(node_id::P0, node_id::I4),
        Edge(node_id::P4, node_id::I4),
        Edge(node_id::I1, node_id::P4)
    };

    const int edge_weight_inner = 10;
    const int edge_weight_outer = 15;
    const int edge_weight_intersections = 2 * edge_weight_inner;
    const int edge_weight_depot = 11;

    std::array<int,22> weights = { 
        edge_weight_depot,
        edge_weight_depot,
        edge_weight_inner,
        };

    int num_arcs = sizeof(edge_array) / sizeof(Edge);
    graph_t g(edge_array.data(), edge_array.data() + num_arcs, weights, num_nodes);
    boost::property_map<graph_t, boost::edge_weight_t>::type weightmap
        = get(boost::edge_weight, g);
    std::vector< vertex_descriptor > p(num_vertices(g));
    std::vector< int > d(num_vertices(g));
    vertex_descriptor s = boost::vertex(static_cast<std::size_t>(src), g);

    dijkstra_shortest_paths(g, s,
        predecessor_map(boost::make_iterator_property_map(
                            p.begin(), get(boost::vertex_index, g)))
            .distance_map(boost::make_iterator_property_map(
                d.begin(), get(boost::vertex_index, g))));

    std::cout << "distances and parents:" << std::endl;
    boost::graph_traits< graph_t >::vertex_iterator vi, vend;
    for (boost::tie(vi, vend) = vertices(g); vi != vend; ++vi)
    {
        std::cout << "distance(" << name[*vi] << ") = " << d[*vi] << ", ";
        std::cout << "parent(" << name[*vi] << ") = " << name[p[*vi]]
                  << std::endl;
    }
    std::cout << std::endl;

    std::ofstream dot_file("figs/dijkstra-eg.dot");

    dot_file << "digraph D {\n"
             << "  rankdir=LR\n"
             << "  size=\"4,3\"\n"
             << "  ratio=\"fill\"\n"
             << "  edge[style=\"bold\"]\n"
             << "  node[shape=\"circle\"]\n";

    boost::graph_traits<graph_t>::edge_iterator ei, ei_end;
    for (boost::tie(ei, ei_end) = edges(g); ei != ei_end; ++ei)
    {
        boost::graph_traits<graph_t>::edge_descriptor e = *ei;
        boost::graph_traits<graph_t>::vertex_descriptor u = source(e, g),
                                                   v = target(e, g);
        dot_file << name[u] << " -> " << name[v] << "[label=\""
                 << get(weightmap, e) << "\"";
        if (p[v] == u)
            dot_file << ", color=\"black\"";
        else
            dot_file << ", color=\"grey\"";
        dot_file << "]";
    }
    dot_file << "}";
    return NULL;
}