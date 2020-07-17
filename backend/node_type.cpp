#include "node_type.hpp"

#include <array>
#include <string>

std::ostream& operator<<(std::ostream& stream, node_type id)
{
    const std::array<std::string, 13> name = { "D", "P0", "I1", "P1", "I2", "P2", "I3", "P3", "I4", "P4", "P5", "P6", "P7"};
    stream << name[id - 1];
    return stream;
}