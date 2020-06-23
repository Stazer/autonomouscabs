cmake_minimum_required(VERSION 3.16)
project(autonomouscabs)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Boost REQUIRED COMPONENTS system)

include_directories(${Boost_INCLUDE_DIR})

add_executable(backend.bin backend/main.cpp shared/buffer_reader.cpp shared/buffer_writer.cpp shared/buffer.cpp shared/message.cpp)
target_include_directories(backend.bin PRIVATE ${Boost_INCLUDE_DIR})
target_link_libraries(backend.bin ${Boost_LIBRARIES} pthread)

add_executable(test.bin test/main.cpp shared/buffer_reader.cpp shared/buffer_writer.cpp shared/buffer.cpp shared/message.cpp)
target_include_directories(test.bin PRIVATE ${Boost_INCLUDE_DIR})
target_link_libraries(test.bin ${Boost_LIBRARIES} pthread)
