cmake_minimum_required(VERSION 3.5)
project (AllegroProject)

find_package(Threads REQUIRED)

find_package(SDL2 REQUIRED)
include_directories(${SDL2_INCLUDE_DIRS})
link_libraries(${SDL2_LIBRARIES})

add_executable(app main.c)
