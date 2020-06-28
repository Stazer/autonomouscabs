#include "buffer.hpp"

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
