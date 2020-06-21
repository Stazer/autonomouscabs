#pragma once

#include <cstdint>
#include <vector>
#include <ostream>

using buffer = std::vector<uint8_t>;
using buffer_collection_size = std::uint32_t;

std::ostream& operator<<(std::ostream& stream, const buffer& buffer)
{
    stream << "[" << std::hex;

    for(auto it = buffer.begin(); it != buffer.end(); ++it)
    {
        stream << static_cast<int>(*it);
        if(it != buffer.end() - 1)
        {
            stream << ", ";
        }
    }

    return stream << "]";
}
