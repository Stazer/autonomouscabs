#include "node_type.hpp"

#include <array>
#include <map>

std::ostream& operator<<(std::ostream& stream, node_type id)
{
    static const std::array<std::string, 13> name = { "D", "P0", "I1", "P1", "I2", "P2", "I3", "P3", "I4", "P4", "P5", "P6", "P7"};
    stream << name[id - 1];
    return stream;
}

std::pair<bool, node_type> string_to_node(std::string string)
{
    static std::map<std::string, node_type> table = {
        {"D", D},
        {"P0", P0},
        {"I1", I1},
        {"P1", P1},
        {"I2", I2},
        {"P2", P2},
        {"I3", I3},
        {"P3", P3},
        {"I4", I4},
        {"P4", P4},
        {"P5", P5},
        {"P6", P6},
        {"P7", P7},
    };
    std::pair<bool, node_type> pair;
    if(table.find(string) == table.end())
    {
        pair.first = false;
    }
    else
    {
        pair.first = true;
        pair.second = table[string];
    }
    return pair;
}