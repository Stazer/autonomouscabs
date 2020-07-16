#pragma once

#include <cstdint>
#include <memory>

#include <boost/uuid/uuid.hpp>

#include "id_type.hpp"

class cab_session;

class cab
{
    public:
        cab(std::weak_ptr<cab_session> cab_session, id_type id);

        id_type id() const;

    private:
        std::weak_ptr<cab_session> _cab_session;

        id_type _id = 0;
};
