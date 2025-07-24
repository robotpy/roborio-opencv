cmake_minimum_required(VERSION 3.1)
set(ARM_PREFIX aarch64-bookworm-linux-gnu)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
# set(CMAKE_SYSROOT /usr/local/arm-nilrt-linux-gnueabi)

set(CMAKE_C_COMPILER ${ARM_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${ARM_PREFIX}-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

include("${CMAKE_CURRENT_LIST_DIR}/opencv-4.10.0/platforms/linux/aarch64-gnu.toolchain.cmake")
