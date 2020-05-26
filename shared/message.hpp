#pragma once

#include <cstdint>

enum class message_id : std::uint32_t {
    NOP = 0,
    PING

    LAST,
};

typedef struct {
    std::uint32_t size;
    message_id id;
} message_header;
