#include "buffer_writer.hpp"

buffer_writer::buffer_writer(::buffer& buffer):
    _buffer(buffer),
    _start(buffer.size())
{
}

std::size_t buffer_writer::written() const
{
    return _buffer.size() - _start;
}

buffer_writer& buffer_writer::operator<<(std::uint8_t data)
{
    _buffer.push_back(data);

    return *this;
}

buffer_writer& buffer_writer::operator<<(std::uint16_t data)
{
    *this << static_cast<std::uint8_t>(data)
          << static_cast<std::uint8_t>(data >> 8);

    return *this;
}

buffer_writer& buffer_writer::operator<<(std::uint32_t data)
{
    *this << static_cast<std::uint8_t>(data)
          << static_cast<std::uint8_t>(data >> 8)
          << static_cast<std::uint8_t>(data >> 16)
          << static_cast<std::uint8_t>(data >> 24);

    return *this;
}

buffer_writer& buffer_writer::operator<<(std::uint64_t data)
{
    *this << static_cast<std::uint8_t>(data)
          << static_cast<std::uint8_t>(data >> 8)
          << static_cast<std::uint8_t>(data >> 16)
          << static_cast<std::uint8_t>(data >> 24)
          << static_cast<std::uint8_t>(data >> 32)
          << static_cast<std::uint8_t>(data >> 40)
          << static_cast<std::uint8_t>(data >> 48)
          << static_cast<std::uint8_t>(data >> 56);

    return *this;
}

buffer_writer& buffer_writer::operator<<(double data)
{
    *this << *reinterpret_cast<std::uint64_t*>(&data);

    return *this;
}

/*
buffer_writer& buffer_writer::operator<<(const std::string& string)
{
    *this << string.size();
    for(auto element:string)
    {
        *this << element;
    }

    return *this;
}*/
