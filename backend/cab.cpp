#include "cab.hpp"

#include <boost/uuid/uuid_generators.hpp>

cab::cab(std::uint32_t id):
    _id(id)
{
}

std::uint32_t cab::id() const
{
    return _id;
}
