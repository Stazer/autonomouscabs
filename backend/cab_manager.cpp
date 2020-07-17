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
    node_id pos = _cabs[id]->position();
    auto it = std::find_if(_cabs_at_node[pos].begin(), _cabs_at_node[pos].end(), 
        [&id](const std::weak_ptr<cab>& cab){
            auto shared = cab.lock();
            return shared->id() == id;
    });
    _cabs_at_node[pos].erase(it);
    _cabs.erase(id);
}

std::shared_ptr<cab> cab_manager::cab_provision(node_id src, node_id dst, std::uint32_t passengers)
{
    bool cycle = false;
    std::deque<node_id> queue;
    queue.push_back(src);

    while(!queue.empty())
    {
        node_id current = queue.front();
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

        std::vector<node_id> vec = _rnet.get_predecessors(current);
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

void cab_manager::update_cab(id_type id, node_id from, node_id to)
{
    auto it = std::find_if(_cabs_at_node[from].begin(), _cabs_at_node[from].end(), 
        [&id](const std::weak_ptr<cab>& cab){
            auto shared = cab.lock();
            return shared->id() == id;
    });
    _cabs_at_node[from].erase(it);
    _cabs_at_node[to].push_back(_cabs[id]);
}

std::vector<std::weak_ptr<cab>> cab_manager::cabs_at_node(node_id node)
{
    return _cabs_at_node[node];
}