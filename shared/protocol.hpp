#pragma once

#include <cstdint>

#include "buffer_reader.hpp"
#include "buffer_writer.hpp"

typedef struct {
    std::uint32_t size;
    std::uint32_t id;
} message_header;
