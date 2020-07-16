#pragma once

#include <unordered_map>
#include <memory>

#include "cab.hpp"

class cab_manager
{
    public:
        cab& create();
        void remove(id_type id);

    private:
        std::unordered_map<id_type, std::unique_ptr<cab>> _cabs;
        id_type _counter = 0;
};
