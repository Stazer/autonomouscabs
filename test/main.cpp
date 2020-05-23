#define BOOST_TEST_MODULE Test
#include <boost/test/included/unit_test.hpp>

#include "../shared/buffer_reader.hpp"
#include "../shared/buffer_writer.hpp"

BOOST_AUTO_TEST_CASE(buffer_write_read)
{
    const uint8_t wuint8 = 0xFF - 1;
    const uint16_t wuint16 = 0xFFFF - 1;
    const uint32_t wuint32 = 0xFFFFFFFF - 1;
    const uint64_t wuint64 = 0xFFFFFFFFFFFFFFFF - 1;

    uint8_t ruint8 = 0;
    uint16_t ruint16 = 0;
    uint32_t ruint32 = 0;
    uint64_t ruint64 = 0;

    buffer buffer;
    buffer_writer writer(buffer);
    writer << wuint8 << wuint16 << wuint32 << wuint64;

    buffer_reader reader(buffer);
    reader >> ruint8 >> ruint16 >> ruint32 >> ruint64;

    BOOST_TEST(wuint8 == ruint8);
    BOOST_TEST(wuint16 == ruint16);
    BOOST_TEST(wuint32 == ruint32);
    BOOST_TEST(wuint64 == ruint64);
}
