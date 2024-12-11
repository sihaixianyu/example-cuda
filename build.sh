#!/bin/bash

set -e

if [ $# -gt 0 ] && [ $1 = "-r" ]; then
    echo "[WARN] All previous built files will be removed!"
    rm -rf build
fi

cmake -S . -B build \
    -D CMAKE_CXX_COMPILER="clang++" \
    -D CMAKE_CUDA_COMPILER="clang++" \
    -D CMAKE_TOOLCHAIN_FILE="${VCPKG_HOME}/scripts/buildsystems/vcpkg.cmake" \
    -D CMAKE_EXPORT_COMPILE_COMMANDS=ON

cmake --build build
