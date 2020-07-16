#include "cab.hpp"

#include <boost/uuid/uuid_generators.hpp>

cab::cab(std::weak_ptr<cab_session> cab_session, id_type id):
    _cab_session(cab_session),
    _id(id)
{
}

id_type cab::id() const
{
    return _id;
}
