#pragma once

#include "cab.hpp"

using node_id_base = std::uint8_t;

enum node_id : node_id_base
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
    P7		
};


cab* cab_provision(node_id src, node_id dest);