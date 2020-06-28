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
    ::buffer& _buffer;
    std::size_t _start = 0;
};

#include "buffer_writer.inl"
