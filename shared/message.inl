template <typename T, message_id U>
inline message_size basic_message<T, U>::size() const
{
    return sizeof(message_header) + body_size();
}

template <typename T, message_id U>
inline message_id basic_message<T, U>::id() const
{
    return U;
}

template <typename T, message_id U>
inline message_header basic_message<T, U>::header() const
{
    message_header header;
    header.size = size();
    header.id = id();

    return header;
}

template <typename T, message_id U>
inline message_size basic_message<T, U>::body_size() const
{
    // subtracting the size overhead of virtual functions
    return sizeof(T) - sizeof(basic_message<T, U>);
}

template <typename T, message_id U>
inline void basic_message<T, U>::write_body(buffer_writer& writer) const
{
    std::array<std::uint8_t, sizeof(T)> array;
    std::memcpy(array.data(), static_cast<const void*>(this), sizeof(T));
    writer << array;
}

template <typename T, message_id U>
inline void basic_message<T, U>::read_body(buffer_reader& reader)
{
    std::array<std::uint8_t, sizeof(T)> array;
    reader >> array;
    std::memcpy(static_cast<void*>(this), array.data(), sizeof(T));
}

template <typename T>
inline buffer_writer& operator<<(buffer_writer& writer, const T& message)
{
    writer << message.header();
    message.write_body(writer);

    return writer;
}

template <typename T>
inline buffer_reader& operator>>(buffer_reader& reader, T& message)
{
    std::size_t read = reader.read();
    message_header header;
    reader >> header;

    if(header.id != message.id())
    {
        reader.unwind(reader.read() - read);
        throw std::runtime_error("Message ids do not match");
    }

    message.read_body(reader);

    return reader;
}

template <message_id U>
inline void empty_message<U>::write_body(buffer_writer& writer) const
{
}

template <message_id U>
inline void empty_message<U>::read_body(buffer_reader& reader)
{
}

template <message_id U>
inline message_size empty_message<U>::body_size() const
{
    return 0;
}
