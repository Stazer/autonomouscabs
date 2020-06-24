template <typename T, message_id U>
inline message_size basic_message<T, U>::size() const
{
    return sizeof(message_header) + static_cast<const T*>(this)->body_size();
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
    return sizeof(T);
}

template <typename T, message_id U>
inline void basic_message<T, U>::write_body(buffer_writer& writer) const
{
    const auto size = static_cast<const T*>(this)->body_size();
    for(std::size_t i = 0; i < size; ++i)
    {
        writer << *(reinterpret_cast<const std::uint8_t*>(this) + i);
    }
}

template <typename T, message_id U>
inline void basic_message<T, U>::read_body(buffer_reader& reader)
{
    const auto size = static_cast<T*>(this)->body_size();
    for(std::size_t i = 0; i < size; ++i)
    {
        reader >> *(reinterpret_cast<std::uint8_t*>(this) + i);
    }
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
        std::stringstream stream;
        stream << "Message ids do not match"
               << " (" << std::hex << static_cast<int>(header.id) << " instead of " << std::hex << static_cast<int>(message.id()) << ")";

        throw std::runtime_error(stream.str());
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
