template <typename T, std::size_t N>
inline buffer_reader& buffer_reader::operator>>(std::array<T, N>& array)
{
    for(std::size_t i = 0; i < N; ++i)
    {
        *this >> array[i];
    }

    return *this;
}

template <std::size_t N>
inline buffer_reader& buffer_reader::operator>>(std::array<std::uint8_t, N>& array)
{
    for(std::size_t i = 0; i < N; ++i)
    {
        *this >> array[i];
    }

    return *this;
}

template <typename T>
inline buffer_reader& buffer_reader::operator>>(std::vector<T>& vector)
{
    buffer_collection_size size = 0;
    *this >> size;
    vector.resize(size);

    for(std::size_t i = 0; i < size; ++i)
    {
        *this >> vector[i];
    }

    return *this;
}
