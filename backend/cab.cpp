#include "cab.hpp"

#include <deque>
#include <queue>
#include <iostream>

#include <boost/uuid/uuid_generators.hpp>

std::ostream& operator<<(std::ostream& stream, node_id id)
{
    const std::array<std::string, 13> name = { "D", "P0", "I1", "P1", "I2", "P2", "I3", "P3", "I4", "P4", "P5", "P6", "P7"};
    stream << name[id - 1];
    return stream;
}

cab::cab(std::uint32_t id, std::shared_ptr<road_network> rnet):
    _id(id), _position(node_id::D), _rnet(rnet), s_pos(0), d_pos(0)
{
}

std::uint32_t cab::id() const
{
    return _id;
}

std::uint32_t cab::passengers()
{
    return _passengers;
}

std::uint32_t cab::passengers_at_node(node_id node)
{
    std::deque<node_id> queue;
    queue.push_back(node);
    while(!queue.empty())
    {
        node_id current = queue.front();
        queue.pop_front();

        if(_passengers_at_node.find(current) != _passengers_at_node.end())
        {
            // found a predecessor with a passenger count
            _passengers_at_node[node] = _passengers_at_node[current];
            return _passengers_at_node[current];
        }

        std::vector<node_id> vec = _rnet->get_predecessors(current);
        for(auto n : vec)
        {
            // add all predecessors to queue which are currently not in the queue
            auto it = std::find(queue.begin(), queue.end(), n);
            if(it == queue.end())
            {
                queue.push_back(n);
            }
        }

        // we are back at src
        if(current == node)
        {
            return 0;
        }       
    }
    return 0;
}

bool cab::route_contains(node_id node)
{
    auto it = std::find(_route.begin(), _route.end(), node);
    return it != _route.end();
}

std::uint32_t cab::calculate_costs(node_id src, node_id dst)
{
    auto sit = std::find(_route.begin(), _route.end(), src);
    auto dit = std::find(_route.begin(), _route.end(), dst);
    bool contains_src = sit != _route.end();
    bool contains_dst = dit != _route.end() && sit < dit;
    bool s_done = false, d_done = false;
    _route.insert(_route.begin(), _position);
    std::size_t i = 1;
    if(!contains_src)
    {
        for(; i < _route.size(); ++i)
        {
            node_id one = _route[i - 1];
            node_id two = _route[i];

            if(_rnet->in_between(two, one, src))
            {
                s_pos = i - 1;
                s_done = true;

                if(!contains_dst && _rnet->in_between(two, src, dst))
                {
                    d_pos = i;
                    d_done = true;
                    i = _route.size();
                }
                else
                {
                    i += 1;
                }
                
                break;
            }
        }
    }
    

    if(!contains_dst)
    {
        for(; i < _route.size(); ++i)
        {
            node_id one = _route[i - 1];
            node_id two = _route[i];

            if(_rnet->in_between(two, one, dst))
            {
                d_pos = i - 1;
                d_done = true;
                break;
            }
        }
    }

    if(!s_done)
    {
        s_pos = i - 1;
        d_pos = s_pos + 1;
    } 
    else if (!d_done)
    {
        d_pos = i;
    }
    _route.erase(_route.begin());

    // get the costs to get to every node without changing the value in _costs
    // if node is inner increase costs by 1, if node is outer increase costs by two
    std::uint32_t max = 0;
    for(i = s_pos; i < _route.size(); ++i)
    {
        std::uint32_t cost = 0;
        if(_costs.find(_route[i]) != _costs.end())
        {
            cost = _costs[_route[i]];
        }

        // only increase cost if src is not already in _route
        if(!contains_src)
        {
            bool is_inner = _rnet->is_inner(src);
            cost = is_inner ? cost + 1 : cost + 2;
        }

        // only increase cost if dst is not already in _route
        if(!contains_dst && i > d_pos - 2)
        {
            bool is_inner = _rnet->is_inner(dst);
            cost = is_inner ? cost + 1 : cost + 2;
        }
        
        max = cost > max ? cost : max;
    }

    return max;
}

void cab::add_request(node_id src, node_id dst, std::uint32_t passengers)
{
    _pickup.push_back(std::pair<node_id, std::uint32_t> {src, passengers});
    _deliver.push_back(std::pair<node_id, std::uint32_t> {dst, passengers});

    // set the costs to include the src, dst pair in _route
    for(std::size_t i = s_pos; i < _route.size(); ++i)
    {
        std::size_t cost = 0;
        if(_costs.find(_route[i]) != _costs.end())
        {
            cost = _costs[_route[i]];
        }

        bool is_inner = _rnet->is_inner(src);
        cost = is_inner ? cost + 1 : cost + 2;

        if(i > d_pos - 2)
        {
            is_inner = _rnet->is_inner(dst);
            cost = is_inner ? cost + 1 : cost + 2;
        }

        _costs[_route[i]] = cost;
    }

    // update the passenger count at every node between src and dst
    std::deque<node_id> queue;
    queue.push_back(dst);

    while(!queue.empty())
    {
        node_id current = queue.front();
        queue.pop_front();

        std::uint32_t n_pass = passengers_at_node(current);
        _passengers_at_node[current] = n_pass + passengers;

        std::vector<node_id> vec = _rnet->get_predecessors(current);
        for(auto n : vec)
        {
            // add all predecessors to queue which are currently not in the queue
            auto it = std::find(queue.begin(), queue.end(), n);
            if(it == queue.end())
            {
                queue.push_back(n);
            }
        }

        if(current == src)
        {
            break;
        }
    }

    // dst gets visited in loop above but the passenger count should not be increased
    _passengers_at_node[dst] = _passengers_at_node[dst] - passengers;
}

void cab::update_position(node_id position)
{
    // update passenger count
    // for ervery src, dst pair position is in between, reduce the passenger count of position
    for(std::size_t i = 0; i < _deliver.size(); ++i)
    {
        node_id d_tmp = _deliver[i].first;
        node_id s_tmp = _pickup[i].first;

        if(_rnet->in_between(d_tmp, s_tmp, position))
        {
            std::size_t n_pass = passengers_at_node(position);
            n_pass = n_pass > _deliver[i].second ? n_pass - _deliver[i].second : 0;
            _passengers_at_node[position] = n_pass;
        }
    }
    
    _position = position;

    // update cost
    std::size_t index = 0;
    for(; index < _deliver.size(); ++index)
    {
        if(_deliver[index].first == position)
        {
            break;
        }
    }

    // return when position is not a dst
    if(index == _deliver.size())
    {
        return;
    }

    node_id dst = position;
    node_id src = _pickup[index].first;

    for(std::size_t i = 0; i < index; ++i)
    {
        node_id d_tmp = _deliver[i].first;
        node_id s_tmp = _pickup[i].first;

        std::size_t cost = 0;
        if(_costs.find(d_tmp) != _costs.end())
        {
            cost = _costs[d_tmp];
        }

        if(_rnet->in_between(d_tmp, d_tmp, src))
        {
            _costs[d_tmp] = cost > 0 ? (_rnet->is_inner(src) ? cost - 1 : cost - 2) : 0;
        }

        if(_rnet->in_between(d_tmp, d_tmp, dst))
        {
            _costs[d_tmp] = cost > 0 ? (_rnet->is_inner(dst) ? cost - 1 : cost - 2) : 0;
        }

        cost = 0;
        if(_costs.find(s_tmp) != _costs.end())
        {
            cost = _costs[s_tmp];
        }

        if(_rnet->in_between(s_tmp, s_tmp, src))
        {
            _costs[s_tmp] = cost > 0 ? (_rnet->is_inner(src) ? cost - 1 : cost - 2) : 0;
        }

        if(_rnet->in_between(s_tmp, s_tmp, dst))
        {
            _costs[s_tmp] = cost > 0 ? (_rnet->is_inner(dst) ? cost - 1 : cost - 2) : 0;
        }
    }
}

void cab::update_route(std::vector<node_id> new_route)
{
    _route = new_route;
}

std::vector<node_id> cab::route()
{
    return _route;
}

int main(int argc, char **argv)
{
    road_network rnet;

    cab c(static_cast<std::uint32_t>(0), std::make_shared<road_network>(rnet));

    // c.add_request(node_id::P0, node_id::P4, 1);
    // c.add_request(node_id::P1, node_id::P2, 1);
    // c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, I4, P4});
    // c.update_position(node_id::P0);
    // c.update_position(node_id::I1);
    // c.update_position(node_id::P1);
    // c.update_position(node_id::I2);
    // c.update_position(node_id::P2);
    // std::cout << "P1: " << c.passengers_at_node(P1) << ", P3: " << c.passengers_at_node(P3) << '\n';

    std::size_t cost = c.calculate_costs(node_id::P0, node_id::P3);
    c.add_request(node_id::P0, node_id::P3, 1);
    std::cout << "cost: " << cost << std::endl;

    c.update_route(std::vector<node_id> {P0, I1, I2, I3, P3});

    cost = c.calculate_costs(node_id::P1, node_id::P2);
    c.add_request(node_id::P1, node_id::P2, 1);
    std::cout << "cost: " << cost << std::endl;

    c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3});

    cost = c.calculate_costs(node_id::P1, node_id::P4);
    c.add_request(node_id::P1, node_id::P4, 1);
    std::cout << "cost: " << cost << std::endl;

    c.update_route(std::vector<node_id> {P0, I1, P1, I2, P2, I3, P3, I4, P4});

    for(auto n : c.route())
    {
        std::cout << n << '\n';
    }
    
    // c.add_request(node_id::P2, node_id::P3);
    // c.add_request(node_id::P3, node_id::P1);
    return 0;
}