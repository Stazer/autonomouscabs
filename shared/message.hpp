#pragma once

#include <cstdint>
#include <exception>

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
    EXTERNAL_LAST,

    WEBOTS_FIRST = 0x80,
    WEBOTS_VELOCITY,
    WEBOTS_LAST,

    BACKEND_FIRST = 0xC0,
    BACKEND_LAST,

    LAST,
};

std::ostream& operator<<(std::ostream& stream, message_id id)
{
    stream << static_cast<message_id_base>(id);

    return stream;
}

buffer_writer& operator<<(buffer_writer& writer, message_id id)
{
    writer << static_cast<message_id_base>(id);

    return writer;
}

buffer_reader& operator>>(buffer_reader& reader, message_id& id)
{
    reader >> *reinterpret_cast<message_id_base*>(&id);

    return reader;
}

#pragma pack(push, 1)
struct message_header
{
    message_size size;
    message_id id;
};
#pragma pack(pop)

buffer_writer& operator<<(buffer_writer& writer, const message_header& header)
{
    writer << header.size << header.id;

    return writer;
}

buffer_reader& operator>>(buffer_reader& reader, message_header& header)
{
    reader >> header.size >> header.id;

    return reader;
}

template <typename T, message_id U>
struct basic_message
{
    virtual ~basic_message() = default;

    message_size size() const;
    message_id id() const;

    message_header header() const;

    virtual message_size body_size() const;

    virtual void write_body(buffer_writer& writer) const;
    virtual void read_body(buffer_reader& reader);
};

template <typename T, message_id U>
message_size basic_message<T, U>::size() const
{
    return sizeof(message_header) + body_size();
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
message_size basic_message<T, U>::body_size() const
{
    // subtracting the size overhead of virtual functions
    return sizeof(T) - sizeof(basic_message<T, U>);
}

template <typename T, message_id U>
void basic_message<T, U>::write_body(buffer_writer& writer) const
{
    std::array<std::uint8_t, sizeof(T)> array;
    std::memcpy(array.data(), static_cast<const void*>(this), sizeof(T));
    writer << array;
}

template <typename T, message_id U>
void basic_message<T, U>::read_body(buffer_reader& reader)
{
    std::array<std::uint8_t, sizeof(T)> array;
    reader >> array;
    std::memcpy(static_cast<void*>(this), array.data(), sizeof(T));
}

template <typename T>
buffer_writer& operator<<(buffer_writer& writer, const T& message)
{
    writer << message.header();
    message.write_body(writer);

    return writer;
}

template <typename T>
buffer_reader& operator>>(buffer_reader& reader, T& message)
{
    std::size_t read = reader.read();
    message_header header;
    reader >> header;

    if(header.id != message.id())
    {
        reader.unwind(reader.read() - read);
        std::string error = "Message ids do not match. Expected: ";
        error.append(std::to_string(static_cast<std::uint32_t>(message.id())));
        error.append(", got: ");
        error.append(std::to_string(static_cast<std::uint32_t>(header.id)));
        throw std::runtime_error(error);
    }

    message.read_body(reader);

    return reader;
}

template <message_id U>
struct empty_message : public basic_message<empty_message<U>, U>
{
    virtual message_size body_size() const final;
    virtual void write_body(buffer_writer& writer) const final;
    virtual void read_body(buffer_reader& reader) final;
};

template <message_id U>
message_size empty_message<U>::body_size() const
{
    return 0;
}

template <message_id U>
void empty_message<U>::write_body(buffer_writer& writer) const
{
}

template <message_id U>
void empty_message<U>::read_body(buffer_reader& reader)
{
}

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

#pragma pack(pop)
