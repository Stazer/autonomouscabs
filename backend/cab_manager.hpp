#pragma once

#include <unordered_map>
#include <memory>

#include "cab.hpp"
#include "cab_session.hpp"

class cab_manager
{
    public:
        cab& create(std::weak_ptr<cab_session> cab_session);

        void remove(cab& cab);
        void remove(id_type id);

    private:
        std::unordered_map<id_type, std::unique_ptr<cab>> _cabs;
        id_type _counter = 0;
};
