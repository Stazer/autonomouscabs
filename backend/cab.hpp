#pragma once

#include <cstdint>

#include <boost/uuid/uuid.hpp>

#include "id_type.hpp"

class cab
{
    public:
        cab(id_type id);

        id_type id() const;

    private:
        id_type _id = 0;
};
