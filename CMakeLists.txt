cmake_minimum_required(VERSION 3.17)
project(autonomouscabs)

find_package(Boost)

if(Boost_FOUND)
  include_directories(${Boost_INCLUDE_DIR})

  add_executable(backend.bin backend/main.cpp)
  target_include_directories(backend.bin PRIVATE ${Boost_INCLUDE_DIR})
  target_link_libraries(backend.bin ${Boost_LIBRARIES} pthread)

  add_executable(test.bin test/main.cpp)
  target_include_directories(test.bin PRIVATE ${Boost_INCLUDE_DIR})
  target_link_libraries(test.bin ${Boost_LIBRARIES} pthread)
endif()
