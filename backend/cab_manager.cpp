#include "cab_manager.hpp"

#include <deque>
#include <iostream>

cab& cab_manager::create()
{
    _cabs.push_back(std::make_shared<cab>(_cabs.size(), std::make_shared<road_network>(_rnet)));
    _cabs_at_node[_cabs.back()->position()].push_back(_cabs.back());
    return *_cabs.back();
}

std::shared_ptr<cab> cab_manager::cab_provision(node_id src, node_id dst, std::uint32_t passengers)
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

    std::deque<node_id> queue;
    queue.push_back(src);

    while(!queue.empty())
    {
        node_id current = queue.front();
        queue.pop_front();

        // std::cout << current << '\n';

        std::int32_t min = INT32_MAX;
        std::shared_ptr<cab> choosen = nullptr;
        if(_cabs_at_node.find(current) != _cabs_at_node.end())
        {
            std::vector<std::shared_ptr<cab>> cabs = _cabs_at_node[current];
            for(auto cab : cabs)
            {
                if(cab->passengers_at_node(src) + passengers > 4)
                {
                    continue;
                }

                // calculate cost
                std::int32_t cost = cab->calculate_costs(src, dst);
                if((cost - cab->costs()) < min)
                {
                    min = cost - cab->costs();
                    choosen = cab;
                }
            }
        }

        if(min != INT32_MAX)
        {
            return choosen;
        }

        std::vector<node_id> vec = _rnet.get_predecessors(current);
        for(auto n : vec)
        {
            auto it = std::find(queue.begin(), queue.end(), n);
            if(it == queue.end())
            {
                queue.push_back(n);
            }
        }
       /*  if(queue.front() == src)
        {
            break;
        } */
    }
    return nullptr;
}

void cab_manager::update_cab(std::uint32_t id, node_id node)
{
    std::shared_ptr<cab> c = _cabs[id];
    node_id pos = c->position();
    auto it = std::find(_cabs_at_node[pos].begin(), _cabs_at_node[pos].end(), c);
    _cabs_at_node[pos].erase(it);
    c->update_position(node);
    _cabs_at_node[node].push_back(c);
}

std::vector<std::shared_ptr<cab>> cab_manager::cabs_at_node(node_id node)
{
    return _cabs_at_node[node];
}

/* int main(int argc, char **argv)
{
    cab_manager manager;

    manager.create();

    std::shared_ptr<cab> c = manager.cab_provision(node_id::P0, node_id::P3, 4);
    c->add_request(node_id::P0, node_id::P3, 4);
    manager.update_cab(0, node_id::P0);
    manager.update_cab(0, node_id::I1);
    manager.update_cab(0, node_id::I2);

    std::cout << c->passengers_at_node(node_id::P2) <<std::endl;

    // c.add_request(node_id::P0, node_id::P4, 3);
    // c.add_request(node_id::P1, node_id::P2, 4);
    // c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, I4, P4});
    // c.update_position(node_id::P0);
    // c.update_position(node_id::I1);
    // c.update_position(node_id::P1);
    // c.update_position(node_id::I2);
    // c.update_position(node_id::P2);
    // std::cout << "P1: " << c.passengers_at_node(P1) << ", P3: " << c.passengers_at_node(P3) << '\n';

    // std::size_t cost = c.calculate_costs(node_id::P0, node_id::P3);
    // c.add_request(node_id::P0, node_id::P3, 1);
    // std::cout << "cost: " << cost << std::endl;

    // c.update_route(std::vector<node_id> {P0, I1, I2, I3, P3});

    // cost = c.calculate_costs(node_id::P1, node_id::P2);
    // c.add_request(node_id::P1, node_id::P2, 1);
    // std::cout << "cost: " << cost << std::endl;

    // c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3});

    // cost = c.calculate_costs(node_id::P1, node_id::P4);
    // c.add_request(node_id::P1, node_id::P4, 1);
    // std::cout << "cost: " << cost << std::endl;

    // c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3, I4, P4});

    // cost = c.calculate_costs(node_id::P2, node_id::P4);
    // c.add_request(node_id::P2, node_id::P4, 1);
    // std::cout << "cost: " << cost << std::endl;
    
    // c.add_request(node_id::P2, node_id::P3);
    // c.add_request(node_id::P3, node_id::P1);
    return 0;
} */