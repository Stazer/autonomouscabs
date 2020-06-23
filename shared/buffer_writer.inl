template <typename T, std::size_t N>
inline buffer_writer& buffer_writer::operator<<(const std::array<T, N>& array)
{
    for(std::size_t i = 0; i < N; ++i)
    {
        *this << array[i];
    }

    return *this;
}

template <std::size_t N>
inline buffer_writer& buffer_writer::operator<<(std::array<std::uint8_t, N>& array)
{
    for(auto& element:array)
    {
        *this << element;
    }

    return *this;
}

template <typename T>
inline buffer_writer& buffer_writer::operator<<(const std::vector<T>& vector)
{
    *this << buffer_collection_size(vector.size());
    for(auto element:vector)
    {
        *this << element;
    }

    return *this;
}
