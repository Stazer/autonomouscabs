#pragma once

#include "buffer.hpp"

class buffer_writer {
    public:
        buffer_writer(buffer& buffer);

        buffer_writer& operator<<(uint8_t data);
        buffer_writer& operator<<(uint16_t data);
        buffer_writer& operator<<(uint32_t data);
        buffer_writer& operator<<(uint64_t data);

    private:
        ::buffer& buffer;
};

buffer_writer::buffer_writer(::buffer& buffer):
    buffer(buffer)
{
}

buffer_writer& buffer_writer::operator<<(uint8_t data)
{
    buffer.push_back(data);

    return *this;
}

buffer_writer& buffer_writer::operator<<(uint16_t data)
{
    *this << static_cast<uint8_t>(data)
          << static_cast<uint8_t>(data >> 8);

    return *this;
}

buffer_writer& buffer_writer::operator<<(uint32_t data)
{
    *this << static_cast<uint8_t>(data)
          << static_cast<uint8_t>(data >> 8)
          << static_cast<uint8_t>(data >> 16)
          << static_cast<uint8_t>(data >> 24);

    return *this;
}

buffer_writer& buffer_writer::operator<<(uint64_t data)
{
    *this << static_cast<uint8_t>(data)
          << static_cast<uint8_t>(data >> 8)
          << static_cast<uint8_t>(data >> 16)
          << static_cast<uint8_t>(data >> 24)
          << static_cast<uint8_t>(data >> 32)
          << static_cast<uint8_t>(data >> 40)
          << static_cast<uint8_t>(data >> 48)
          << static_cast<uint8_t>(data >> 56);

    return *this;
}
