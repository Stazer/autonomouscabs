cmake_minimum_required(VERSION 3.10)
project(autonomouscabs)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Boost REQUIRED COMPONENTS system program_options)

include_directories(${Boost_INCLUDE_DIR})

add_executable(
    backend.bin backend/main.cpp backend/application.cpp backend/cab_server.cpp 
    backend/cab_session.cpp backend/cab.cpp backend/cab_manager.cpp 
    backend/request.cpp backend/road_network.cpp backend/node_type.cpp
    shared/buffer_reader.cpp shared/buffer_writer.cpp shared/buffer.cpp shared/message.cpp)
    
target_include_directories(backend.bin PRIVATE ${Boost_INCLUDE_DIR})
target_link_libraries(backend.bin ${Boost_LIBRARIES} pthread)

add_executable(
    test.bin test/cpp/main.cpp 
    backend/cab_manager.cpp backend/cab.cpp backend/road_network.cpp
    backend/node_type.cpp backend/request.cpp backend/cab_session.cpp
    backend/application.cpp backend/cab_server.cpp 
    shared/buffer_reader.cpp shared/buffer_writer.cpp shared/buffer.cpp shared/message.cpp)

target_include_directories(test.bin PRIVATE ${Boost_INCLUDE_DIR})
target_link_libraries(test.bin ${Boost_LIBRARIES} pthread)
