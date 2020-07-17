#pragma once

#include <cstdint>
#include <iostream>

using node_type_base = std::uint8_t;

enum node_type : node_type_base
{
    D = 1,
    P0,
    I1,
    P1,
    I2,
    P2,
    I3,
    P3,
    I4,
    P4,
    P5,
    P6,
    P7,
};

std::ostream& operator<<(std::ostream& stream, node_type id);