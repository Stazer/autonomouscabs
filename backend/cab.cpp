#include "cab.hpp"

#include <boost/uuid/uuid_generators.hpp>

cab::cab(id_type id):
    _id(id)
{
}

id_type cab::id() const
{
    return _id;
}
