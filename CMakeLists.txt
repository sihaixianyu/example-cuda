cmake_minimum_required(VERSION 3.30 FATAL_ERROR)

project(example-cuda LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(vec)
