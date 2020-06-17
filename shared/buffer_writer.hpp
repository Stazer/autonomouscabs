#pragma once

#include <string>
#include <array>

#include "buffer.hpp"

class buffer_writer
{
  public:
    buffer_writer(::buffer& buffer);

    std::size_t written() const;

    buffer_writer& operator<<(std::uint8_t data);
    buffer_writer& operator<<(std::uint16_t data);
    buffer_writer& operator<<(std::uint32_t data);
    buffer_writer& operator<<(std::uint64_t data);

    buffer_writer& operator<<(double data);

    buffer_writer& operator<<(const std::string& string);

    template <typename T, std::size_t N>
    buffer_writer& operator<<(const std::array<T, N>& array);

    template <std::size_t N>
    buffer_writer& operator<<(std::array<std::uint8_t, N>& array);

    template <typename T>
    buffer_writer& operator<<(const std::vector<T>& vector);

  private:
    ::buffer& buffer;
    std::size_t start = 0;
};

buffer_writer::buffer_writer(::buffer& buffer):
    buffer(buffer),
    start(buffer.size())
{
}

std::size_t buffer_writer::written() const
{
    return buffer.size() - start;
}

buffer_writer& buffer_writer::operator<<(std::uint8_t data)
{
    buffer.push_back(data);

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

buffer_writer& buffer_writer::operator<<(const std::string& string)
{
    *this << string.size();
    for(auto element:string)
    {
        //*this << element;
    }

    return *this;
}

template <typename T, std::size_t N>
buffer_writer& buffer_writer::operator<<(const std::array<T, N>& array)
{
    for(std::size_t i = 0; i < N; ++i)
    {
        *this << array[i];
    }

    return *this;
}

template <std::size_t N>
buffer_writer& buffer_writer::operator<<(std::array<std::uint8_t, N>& array)
{
    for(auto& element:array)
    {
        *this << element;
    }

    return *this;
}

template <typename T>
buffer_writer& buffer_writer::operator<<(const std::vector<T>& vector)
{
    *this << vector.size();
    for(auto element:vector)
    {
        *this << element;
    }

    return *this;
}
