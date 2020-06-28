#pragma once

#include <cstdint>
#include <vector>
#include <ostream>

using buffer = std::vector<uint8_t>;
using buffer_collection_size = std::uint32_t;

std::ostream& operator<<(std::ostream& stream, const buffer& buffer);
