cmake_minimum_required(VERSION 3.14)
project(MovieEdit)

set(CMAKE_CXX_STANDARD 17)
add_library(preview STATIC src/preview.cpp)
add_executable(MovieEdit main.cpp)

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(MovieEdit ${OpenCV_LIBS} preview)