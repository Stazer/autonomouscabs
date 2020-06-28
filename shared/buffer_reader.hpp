#pragma once

#include <string>
#include <array>

#include "buffer.hpp"

class buffer_reader
{
    public:
        buffer_reader(const ::buffer& buffer, ::buffer::const_iterator iterator);
        buffer_reader(const ::buffer& buffer);

        std::size_t available() const;
        std::size_t read() const;

        void unwind(std::size_t bytes);

        buffer_reader& operator>>(std::uint8_t& data);
        buffer_reader& operator>>(std::uint16_t& data);
        buffer_reader& operator>>(std::uint32_t& data);
        buffer_reader& operator>>(std::uint64_t& data);

        buffer_reader& operator>>(double& data);

        buffer_reader& operator>>(std::string& string);

        template <typename T, std::size_t N>
        buffer_reader& operator>>(std::array<T, N>& array);

        template <std::size_t N>
        buffer_reader& operator>>(std::array<std::uint8_t, N>& array);

        template <typename T>
        buffer_reader& operator>>(std::vector<T>& vector);

    private:
        const ::buffer& _buffer;
        std::size_t _start = 0;
        std::size_t _index = 0;
};

#include "buffer_reader.inl"
