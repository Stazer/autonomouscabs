#pragma once

#include <cstdint>
#include "buffer_reader.hpp"
#include "buffer_writer.hpp"

using message_size = std::uint32_t;

enum class message_id : std::uint8_t
{
    FIRST = 0x0,

    GENERAL_FIRST = 0x0,
    NOP,
    PING,
    GENERAL_LAST,

    EXTERNAL_FIRST = 0x40,
    EXTERNAL_LIGHT_SENSOR,
    EXTERNAL_DISTANCE_SENSOR,
    EXTERNAL_IMAGE_DATA,
    EXTERNAL_LAST,

    WEBOTS_FIRST = 0x80,
    WEBOTS_STEERING,
    WEBOTS_VELOCITY,
    WEBOTS_LAST,

    BACKEND_FIRST = 0xC0,
    BACKEND_LAST,

    LAST,
};

std::ostream& operator<<(std::ostream& stream, message_id id)
{
    stream << static_cast<std::uint8_t>(id);

    return stream;
}

struct message_header
{
    message_size size;
    message_id id;
};

template <typename T, message_id U>
struct basic_message
{
    virtual ~basic_message() = default;

    virtual std::size_t size() const;
    message_id id() const;

    message_header header() const;
};

template <typename T, message_id U>
std::size_t basic_message<T, U>::size() const
{
    return sizeof(T) + sizeof(message_id);
}

template <typename T, message_id U>
message_id basic_message<T, U>::id() const
{
    return U;
}

template <typename T, message_id U>
message_header basic_message<T, U>::header() const
{
    message_header header;
    header.size = size();
    header.id = id();

    return header;
}

template <typename T, message_id U>
buffer_writer& operator<<(buffer_writer& writer, const basic_message<T, U>& message)
{
    writer << message.header() << U << message;

    return writer;
}

template <typename T, message_id U>
buffer_reader& operator>>(buffer_reader& reader, const basic_message<T, U>& message)
{
    message_header header;
    reader >> header >> message;

    return reader;
}

struct nop_message : public basic_message<nop_message, message_id::NOP>
{
};

struct ping_message : public basic_message<ping_message, message_id::PING>
{
};

struct webots_velocity_message : public basic_message<webots_velocity_message, message_id::WEBOTS_VELOCITY>
{
    double left_speed;
    double right_speed;
};

struct webots_steering_message : public basic_message<webots_steering_message, message_id::WEBOTS_STEERING>
{
    double left_speed;
    double right_speed;
};

struct external_distance_sensor_message : public basic_message<external_distance_sensor_message, message_id::EXTERNAL_DISTANCE_SENSOR>
{
};

struct external_light_sensor_message : public basic_message<external_light_sensor_message, message_id::EXTERNAL_LIGHT_SENSOR>
{
};

struct external_image_data_message : public basic_message<external_image_data_message, message_id::EXTERNAL_IMAGE_DATA>
{
};
