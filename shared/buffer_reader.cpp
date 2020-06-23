#include "buffer_reader.hpp"

buffer_reader::buffer_reader(const ::buffer& buffer):
    buffer_reader(buffer, buffer.begin())
{
}

buffer_reader::buffer_reader(const ::buffer& buffer, ::buffer::const_iterator iterator):
    buffer(buffer),
    start(iterator - buffer.begin()),
    index(iterator - buffer.begin())
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

void buffer_reader::unwind(std::size_t bytes)
{
    index -= bytes;
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

buffer_reader& buffer_reader::operator>>(double& data)
{
    *this >> *reinterpret_cast<std::uint64_t*>(&data);

    return *this;
}

buffer_reader& buffer_reader::operator>>(std::string& string)
{
    std::size_t size = 0;
    *this >> size;
    string.resize(size);

    for(std::size_t i = 0; i < size; ++i)
    {
        //*this >> string[i];
    }

    return *this;
}
