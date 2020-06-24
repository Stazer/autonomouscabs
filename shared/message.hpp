#pragma once

#include <cstring>
#include <cstdint>
#include <exception>
#include <sstream>

#include "buffer_reader.hpp"
#include "buffer_writer.hpp"

#pragma pack(push, 1)

using message_size = std::uint32_t;
using message_id_base = std::uint8_t;

enum class message_id : message_id_base
{
    FIRST = 0x0,

    GENERAL_FIRST = 0x0,
    UNDEFINED,
    NOP,
    PING,
    GENERAL_LAST,

    EXTERNAL_FIRST = 0x40,
    EXTERNAL_LIGHT_SENSOR,
    EXTERNAL_DISTANCE_SENSOR,
    EXTERNAL_IMAGE_DATA,
    EXTERNAL_JOIN_SUCCESS,
    EXTERNAL_LAST,

    WEBOTS_FIRST = 0x80,
    WEBOTS_VELOCITY,
    WEBOTS_LAST,

    BACKEND_FIRST = 0xC0,
    BACKEND_JOIN_CHALLENGE,
    BACKEND_LAST,

    LAST,
};

std::ostream& operator<<(std::ostream& stream, message_id id);
buffer_writer& operator<<(buffer_writer& writer, message_id id);
buffer_reader& operator>>(buffer_reader& reader, message_id& id);

struct message_header
{
    message_size size;
    message_id id;
};

buffer_writer& operator<<(buffer_writer& writer, const message_header& header);
buffer_reader& operator>>(buffer_reader& reader, message_header& header);

template <typename T, message_id U>
struct basic_message
{
    //~basic_message() = default;

    message_size size() const;
    message_id id() const;

    message_header header() const;

    message_size body_size() const;

    void write_body(buffer_writer& writer) const;
    void read_body(buffer_reader& reader);
};

template <message_id U>
struct empty_message : public basic_message<empty_message<U>, U>
{
    message_size body_size() const;

    void write_body(buffer_writer& writer) const;
    void read_body(buffer_reader& reader);
};

struct nop_message final : public empty_message<message_id::NOP>
{
};

struct ping_message final : public empty_message<message_id::PING>
{
};

struct webots_velocity_message final : public basic_message<webots_velocity_message, message_id::WEBOTS_VELOCITY>
{
    double left_speed;
    double right_speed;
};

struct external_distance_sensor_message final : public basic_message<external_distance_sensor_message, message_id::EXTERNAL_DISTANCE_SENSOR>
{
    std::array<double, 9> data;
};

struct external_light_sensor_message final : public basic_message<external_light_sensor_message, message_id::EXTERNAL_LIGHT_SENSOR>
{
    std::array<double, 1> data;
};

struct external_image_data_message final : public basic_message<external_image_data_message, message_id::EXTERNAL_IMAGE_DATA>
{
    std::vector<std::uint8_t> pixel;

    message_size body_size() const
    {
        return sizeof(buffer_collection_size) + pixel.size() * sizeof(std::uint8_t);
    }

    void write_body(buffer_writer& writer) const
    {
        writer << pixel;
    }

    void read_body(buffer_reader& reader)
    {
        reader >> pixel;
    }
};

struct backend_join_challenge_message final : public empty_message<message_id::BACKEND_JOIN_CHALLENGE>
{
};

struct external_join_success_message final : public basic_message<external_join_success_message, message_id::EXTERNAL_JOIN_SUCCESS>
{
    std::string uuid;

    message_size body_size() const
    {
        return sizeof(buffer_collection_size) + uuid.size() * sizeof(std::string::value_type);
    }

    void write_body(buffer_writer& writer) const
    {
        writer << uuid;
    }

    void read_body(buffer_reader& reader)
    {
        reader >> uuid;
    }
};

#include "message.inl"

#pragma pack(pop)
