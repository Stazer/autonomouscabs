#pragma once

#include <cstdint>

#include <boost/uuid/uuid.hpp>

class cab
{
    public:
        cab(std::uint32_t id);

        std::uint32_t id() const;

    private:
        std::uint32_t _id = 0;
};
