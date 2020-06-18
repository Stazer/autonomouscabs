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
    const double wdouble = 3.1415;

    uint8_t ruint8 = 0;
    uint16_t ruint16 = 0;
    uint32_t ruint32 = 0;
    uint64_t ruint64 = 0;
    double rdouble = 0;
    auto total = sizeof(uint8_t) + sizeof(uint16_t) + sizeof(uint32_t) + sizeof(uint64_t) + sizeof(double);

    buffer buffer;

    buffer_writer writer(buffer);
    writer << wuint8 << wuint16 << wuint32 << wuint64 << wdouble;

    buffer_reader reader(buffer);
    reader >> ruint8 >> ruint16 >> ruint32 >> ruint64 >> rdouble;

    BOOST_TEST(ruint8 != 0);
    BOOST_TEST(ruint16 != 0);
    BOOST_TEST(ruint32 != 0);
    BOOST_TEST(ruint64 != 0);
    BOOST_TEST(rdouble != 0);

    BOOST_TEST(wuint8 == ruint8);
    BOOST_TEST(wuint16 == ruint16);
    BOOST_TEST(wuint32 == ruint32);
    BOOST_TEST(wuint64 == ruint64);
    BOOST_TEST(wdouble == rdouble);

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

    //BOOST_TEST(wstring == rstring);
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
    const message_size size = 0xFF55;
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

BOOST_AUTO_TEST_CASE(empty_messages_empty)
{
    ping_message ping;
    nop_message nop;

    BOOST_TEST(nop.body_size() == 0);
    BOOST_TEST(ping.body_size() == 0);
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

BOOST_AUTO_TEST_CASE(message_unmatching_ids)
{
    buffer buffer;

    buffer_writer writer(buffer);
    writer << ping_message();

    ping_message ping;
    nop_message nop;
    buffer_reader reader(buffer);

    BOOST_CHECK_THROW(reader >> nop, std::runtime_error);
    BOOST_CHECK_NO_THROW(reader >> ping);
}

BOOST_AUTO_TEST_CASE(message_header_size)
{
    BOOST_TEST(sizeof(message_header) == 5);
}

BOOST_AUTO_TEST_CASE(empty_message_size)
{
    BOOST_TEST((empty_message<message_id::UNDEFINED>{}).body_size() == 0);
}

BOOST_AUTO_TEST_CASE(test_message_sizes)
{
    DEFINE_MESSAGE(test_message, message_id::UNDEFINED)
    {
    };

    const auto msg = test_message{};

    BOOST_TEST(msg.body_size() == 0);
    BOOST_TEST(msg.size() == sizeof(message_header));
}

BOOST_AUTO_TEST_CASE(test_message2_sizes)
{
    DEFINE_MESSAGE(test_message2, message_id::UNDEFINED)
    {
        std::uint8_t a;
        uint32_t b;
        uint8_t c;
        float d;
        std::array<uint8_t, 27> e;
        double f;
        uint8_t g;
        std::array<uint32_t, 3> h;
    };

    const auto size = sizeof(test_message2::a)
        + sizeof(test_message2::b)
        + sizeof(test_message2::c)
        + sizeof(test_message2::d)
        + sizeof(test_message2::e)
        + sizeof(test_message2::f)
        + sizeof(test_message2::g)
        + sizeof(test_message2::h);

    const auto msg = test_message2{};

    BOOST_TEST(msg.body_size() == size);
    BOOST_TEST(msg.size() == sizeof(message_header) + size);
}
