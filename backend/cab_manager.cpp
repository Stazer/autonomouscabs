#include "cab_manager.hpp"

cab& cab_manager::create()
{
    auto id = _counter++;
    _cabs[id] = std::make_unique<cab>(id);

    return *_cabs[id];
}

void cab_manager::remove(cab& cab)
{
    remove(cab.id());
}

void cab_manager::remove(id_type id)
{
    _cabs.erase(id);
}
