cmake_minimum_required(VERSION 3.14)
project(unix_environment_programming)

include_directories(./include)

add_executable(seek fileio/seek.cpp)
add_executable(hole fileio/hole.cpp)
add_executable(mycat fileio/mycat.cpp)
add_executable(fileflags fileio/fileflags.cpp)
# add_executable(setfl fileio/setfl.cpp)