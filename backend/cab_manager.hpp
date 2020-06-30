#pragma once

#include <vector>
#include <memory>

#include "cab.hpp"

class cab_manager
{
    public:
        cab& create();

    private:
        std::vector<std::unique_ptr<cab>> _cabs;
};
