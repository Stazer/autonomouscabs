#include "cab_manager.hpp"

cab& cab_manager::create()
{
    _cabs.push_back(std::make_unique<cab>(_cabs.size()));
    return *_cabs.back();
}
