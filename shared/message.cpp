#include "message.hpp"

std::ostream& operator<<(std::ostream& stream, message_id id)
{
    stream << static_cast<message_id_base>(id);

    return stream;
}

buffer_writer& operator<<(buffer_writer& writer, message_id id)
{
    writer << static_cast<message_id_base>(id);

    return writer;
}

buffer_reader& operator>>(buffer_reader& reader, message_id& id)
{
    reader >> *reinterpret_cast<message_id_base*>(&id);

    return reader;
}

buffer_writer& operator<<(buffer_writer& writer, const message_header& header)
{
    writer << header.size << header.id;

    return writer;
}

buffer_reader& operator>>(buffer_reader& reader, message_header& header)
{
    reader >> header.size >> header.id;

    return reader;
}
