#define BOOST_TEST_MODULE Test
#include <iostream>

#include <boost/test/included/unit_test.hpp>

#include "../shared/buffer_reader.hpp"
#include "../shared/buffer_writer.hpp"
#include "../shared/message.hpp"

BOOST_AUTO_TEST_CASE(buffer_write_read_integer)
{
    const uint8_t wuint8 = 0xFF - 1;
    const uint16_t wuint16 = 0xFFFF - 1;
    const uint32_t wuint32 = 0xFFFFFFFF - 1;
    const uint64_t wuint64 = 0xFFFFFFFFFFFFFFFF - 1;

    uint8_t ruint8 = 0;
    uint16_t ruint16 = 0;
    uint32_t ruint32 = 0;
    uint64_t ruint64 = 0;
    auto total = sizeof(uint8_t) + sizeof(uint16_t) + sizeof(uint32_t) + sizeof(uint64_t);

    buffer buffer;

    buffer_writer writer(buffer);
    writer << wuint8 << wuint16 << wuint32 << wuint64;

    buffer_reader reader(buffer);
    reader >> ruint8 >> ruint16 >> ruint32 >> ruint64;

    BOOST_TEST(ruint8 != 0);
    BOOST_TEST(ruint16 != 0);
    BOOST_TEST(ruint32 != 0);
    BOOST_TEST(ruint64 != 0);

    BOOST_TEST(wuint8 == ruint8);
    BOOST_TEST(wuint16 == ruint16);
    BOOST_TEST(wuint32 == ruint32);
    BOOST_TEST(wuint64 == ruint64);

    BOOST_TEST(writer.written() == total);
    BOOST_TEST(reader.read() == total);
}

BOOST_AUTO_TEST_CASE(buffer_write_read_string)
{
    buffer buffer;

    std::string wstring = "Hello World";
    buffer_writer writer(buffer);
    writer << wstring;

    std::string rstring;
    buffer_reader reader(buffer);
    reader >> rstring;

    BOOST_TEST(wstring == rstring);
}

BOOST_AUTO_TEST_CASE(buffer_write_read_array)
{
    buffer buffer;

    std::array<uint32_t, 10> warray = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    buffer_writer writer(buffer);
    writer << warray;

    std::array<uint32_t, 10> rarray;
    buffer_reader reader(buffer);
    reader >> rarray;

    BOOST_TEST(warray == rarray);
}

BOOST_AUTO_TEST_CASE(buffer_write_read_vector)
{
    buffer buffer;

    std::vector<uint32_t> wvector = {0, 2, 4, 6, 8};
    buffer_writer writer(buffer);
    writer << wvector;

    std::vector<uint32_t> rvector;
    buffer_reader reader(buffer);
    reader >> rvector;

    BOOST_TEST(wvector == rvector);
}

BOOST_AUTO_TEST_CASE(message_header_write_read)
{
    const uint32_t size = 0xFF55;
    const message_id id = message_id::PING;
    buffer buffer;

    message_header write_header;
    write_header.size = size;
    write_header.id = id;

    buffer_writer writer(buffer);
    writer << write_header;

    buffer_reader reader(buffer);
    message_header read_header;
    reader >> read_header;

    BOOST_TEST(read_header.id == id);
    BOOST_TEST(read_header.size == size);
}

BOOST_AUTO_TEST_CASE(webots_velocity_message_write_read)
{
    webots_velocity_message write_msg;
    write_msg.left_speed = 2.5;
    write_msg.right_speed = 3.0;

    buffer buffer;

    buffer_writer writer(buffer);
    writer << write_msg;

    webots_velocity_message read_msg;
    buffer_reader reader(buffer);
    reader >> read_msg;

    BOOST_TEST(read_msg.left_speed == write_msg.left_speed);
    BOOST_TEST(read_msg.right_speed == write_msg.right_speed);
}
