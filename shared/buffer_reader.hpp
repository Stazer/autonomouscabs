#pragma once

#include "buffer.hpp"

class buffer_reader {
    public:
        buffer_reader(const ::buffer& buffer, ::buffer::const_iterator iterator);
        buffer_reader(const ::buffer& buffer);

        buffer_reader& operator>>(uint8_t& data);
        buffer_reader& operator>>(uint16_t& data);
        buffer_reader& operator>>(uint32_t& data);
        buffer_reader& operator>>(uint64_t& data);

    private:
        const ::buffer& buffer;
        std::size_t index = 0;
};

buffer_reader::buffer_reader(const ::buffer& buffer):
    buffer_reader(buffer, buffer.begin())
{
}

buffer_reader::buffer_reader(const ::buffer& buffer, ::buffer::const_iterator iterator):
    buffer(buffer),
    index(iterator - buffer.begin())
{
}

buffer_reader& buffer_reader::operator>>(uint8_t& data)
{
    data = buffer[index++];

    return *this;
}

buffer_reader& buffer_reader::operator>>(uint16_t& data)
{
    data = static_cast<uint16_t>(buffer[index++]);
    data |= static_cast<uint16_t>(buffer[index++]) << 8;

    return *this;
}

buffer_reader& buffer_reader::operator>>(uint32_t& data)
{
    data = static_cast<uint32_t>(buffer[index++]);
    data |= static_cast<uint32_t>(buffer[index++]) << 8;
    data |= static_cast<uint32_t>(buffer[index++]) << 16;
    data |= static_cast<uint32_t>(buffer[index++]) << 24;

    return *this;
}

buffer_reader& buffer_reader::operator>>(uint64_t& data)
{
    data = static_cast<uint64_t>(buffer[index++]);
    data |= static_cast<uint64_t>(buffer[index++]) << 8;
    data |= static_cast<uint64_t>(buffer[index++]) << 16;
    data |= static_cast<uint64_t>(buffer[index++]) << 24;
    data |= static_cast<uint64_t>(buffer[index++]) << 32;
    data |= static_cast<uint64_t>(buffer[index++]) << 40;
    data |= static_cast<uint64_t>(buffer[index++]) << 48;
    data |= static_cast<uint64_t>(buffer[index++]) << 56;

    return *this;
}
