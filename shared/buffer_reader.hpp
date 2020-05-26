#pragma once

#include "buffer.hpp"

class buffer_reader {
    public:
        buffer_reader(const ::buffer& buffer, ::buffer::const_iterator iterator);
        buffer_reader(const ::buffer& buffer);

        std::size_t available() const;
        std::size_t read() const;

        buffer_reader& operator>>(std::uint8_t& data);
        buffer_reader& operator>>(std::uint16_t& data);
        buffer_reader& operator>>(std::uint32_t& data);
        buffer_reader& operator>>(std::uint64_t& data);

        template <typename T>
        buffer_reader& operator>>(T& data);

    private:
        const ::buffer& buffer;
        std::size_t start = 0;
        std::size_t index = 0;
};

buffer_reader::buffer_reader(const ::buffer& buffer):
    buffer_reader(buffer, buffer.begin())
{
}

buffer_reader::buffer_reader(const ::buffer& buffer, ::buffer::const_iterator iterator):
    buffer(buffer),
    index(iterator - buffer.begin()),
    start(iterator - buffer.begin())
{
}

std::size_t buffer_reader::available() const
{
    return buffer.size () - index;
}

std::size_t buffer_reader::read() const
{
    return index - start;
}

buffer_reader& buffer_reader::operator>>(std::uint8_t& data)
{
    data = buffer[index++];

    return *this;
}

buffer_reader& buffer_reader::operator>>(std::uint16_t& data)
{
    data = static_cast<std::uint16_t>(buffer[index++]);
    data |= static_cast<std::uint16_t>(buffer[index++]) << 8;

    return *this;
}

buffer_reader& buffer_reader::operator>>(std::uint32_t& data)
{
    data = static_cast<std::uint32_t>(buffer[index++]);
    data |= static_cast<std::uint32_t>(buffer[index++]) << 8;
    data |= static_cast<std::uint32_t>(buffer[index++]) << 16;
    data |= static_cast<std::uint32_t>(buffer[index++]) << 24;

    return *this;
}

buffer_reader& buffer_reader::operator>>(std::uint64_t& data)
{
    data = static_cast<std::uint64_t>(buffer[index++]);
    data |= static_cast<std::uint64_t>(buffer[index++]) << 8;
    data |= static_cast<std::uint64_t>(buffer[index++]) << 16;
    data |= static_cast<std::uint64_t>(buffer[index++]) << 24;
    data |= static_cast<std::uint64_t>(buffer[index++]) << 32;
    data |= static_cast<std::uint64_t>(buffer[index++]) << 40;
    data |= static_cast<std::uint64_t>(buffer[index++]) << 48;
    data |= static_cast<std::uint64_t>(buffer[index++]) << 56;

    return *this;
}

template <typename T>
buffer_reader& buffer_reader::operator>>(T& data)
{
    for(std::size_t i = 0; i < sizeof(data); ++i)
    {
        *this >> *(reinterpret_cast<std::uint8_t*>(&data) + i);
    }

    return *this;
}
