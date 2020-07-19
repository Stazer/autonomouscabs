#include <deque>
#include <iostream>

#include "cab_manager.hpp"

cab& cab_manager::create(std::weak_ptr<cab_session> cab_session)
{
    auto id = _counter++;
    _cabs[id] = std::make_unique<cab>(cab_session, *this, id, &_rnet);
    
    _cabs_at_node[_cabs[id]->position()].push_back(_cabs[id]);

    return *_cabs[id];
}

void cab_manager::remove(cab& cab)
{
    remove(cab.id());
}

void cab_manager::remove(id_type id)
{
    node_type pos = _cabs[id]->position();
    auto it = std::find_if(_cabs_at_node[pos].begin(), _cabs_at_node[pos].end(), 
        [&id](const std::weak_ptr<cab>& cab){
            auto shared = cab.lock();
            return shared->id() == id;
    });
    _cabs_at_node[pos].erase(it);
    _cabs.erase(id);
}

// walk through the graph backwards, begin at src
// loop through all cabs which are currently at the node
// for every cab calculate the costs for including the new request
// select the cab with the smallest cost increase
std::shared_ptr<cab> cab_manager::find_cab(node_type src, node_type dst, std::uint32_t passengers)
{
    bool cycle = false;
    std::deque<node_type> queue;
    queue.push_back(src);

    while(!queue.empty())
    {
        node_type current = queue.front();
        queue.pop_front();

        std::int32_t min = INT32_MAX;
        std::shared_ptr<cab> chosen = nullptr;
        if(_cabs_at_node.find(current) != _cabs_at_node.end())
        {
            std::vector<std::weak_ptr<cab>> cabs = _cabs_at_node[current];
            for(auto cab : cabs)
            {
                auto shared = cab.lock();
                if(shared->passengers_at_node(src) + passengers > 4)
                {
                    continue;
                }

                // calculate cost
                std::int32_t cost = shared->calculate_costs(src, dst);
                if((cost - shared->costs()) < min)
                {
                    min = cost - shared->costs();
                    chosen = shared;
                }
            }
        }

        if(min != INT32_MAX)
        {
            return chosen;
        }

        std::vector<node_type> vec = _rnet.get_predecessors(current);
        for(auto n : vec)
        {
            auto it = std::find(queue.begin(), queue.end(), n);
            if(it == queue.end())
            {
                queue.push_back(n);
            }
        }

        // break after two cycles due to edge case src = P4
        if(queue.front() == src && cycle)
        {
            break;
        }
        else if (queue.front() == src && !cycle)
        {
            cycle = true;
        }
        
    }
    return nullptr;
}

// changes the current cab location according to the detected node
void cab_manager::update_cab(id_type id, node_type from, node_type to)
{
    auto it = std::find_if(_cabs_at_node[from].begin(), _cabs_at_node[from].end(), 
        [&id](const std::weak_ptr<cab>& cab){
            auto shared = cab.lock();
            return shared->id() == id;
    });
    _cabs_at_node[from].erase(it);
    _cabs_at_node[to].push_back(_cabs[id]);
}

// try to assign a cab to a new passenger request
// if a cb is found inform that cab
void cab_manager::add_request(node_type src, node_type dst, std::uint32_t passengers)
{
    std::shared_ptr<cab> cab = find_cab(src, dst, passengers);
    if(cab == nullptr)
    {
        std::cout << "found no cab for request " << src << " --> " << dst << '\n';
        return;
    }

    std::cout << "found cab with id " << cab->id() << " for request " << src << " --> " << dst << '\n';
    cab->add_request(src, dst, passengers);
}

std::vector<std::weak_ptr<cab>> cab_manager::cabs_at_node(node_type node)
{
    return _cabs_at_node[node];
}