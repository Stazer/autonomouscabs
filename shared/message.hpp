#pragma once

#include <cstdint>

enum class message_id : std::uint32_t
{
    NOP = 0,
    PING,

    EXTERNAL_LIGHT_SENSOR,
    EXTERNAL_DISTANCE_SENSOR,
    EXTERNAL_IMAGE_DATA,

    WEBOTS_STEERING,
    WEBOTS_VELOCITY,

    LAST,
};

std::ostream& operator<<(std::ostream& stream, message_id id)
{
    stream << static_cast<std::uint32_t>(id);

    return stream;
}

struct message_header
{
    std::uint32_t size;
    message_id id;
};
