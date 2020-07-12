#include "cab_manager.hpp"

#include <deque>

cab& cab_manager::create()
{
    _cabs.push_back(std::make_unique<cab>(_cabs.size(), std::make_shared<road_network>(_rnet)));
    return *_cabs.back();
}

std::shared_ptr<cab> cab_manager::cab_provision(node_id src, node_id dst)
{
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
    graph::vertex_descriptor start = boost::vertex(src, _rnet.get_graph());

    std::deque<graph::vertex_descriptor> queue;
    queue.push_back(start);
    while(!queue.empty())
    {
        graph::vertex_descriptor vertex = queue.front();
        queue.pop_front();

        for (auto vd : boost::make_iterator_range(boost::adjacent_vertices(vertex, _rnet.get_graph()))) 
        {
            queue.push_back(vd);
            node_id id = static_cast<node_id>(vd);
            if(_cabs_at_node.find(id) == _cabs_at_node.end())
            {
                continue;
            }

            std::vector<std::shared_ptr<cab>> cabs = _cabs_at_node[id];
            for(auto cab : cabs)
            {
                if(cab->passengers_at_node(src) == 4)
                {
                    continue;
                }

                if(cab->route_contains(src))
                {
                    return cab;
                }

                // calculate cost
            }
        }

    }
    return nullptr;
}
