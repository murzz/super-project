cmake_minimum_required( VERSION 2.8 )

project(super-project NONE)

set(STAGING_ROOT ${CMAKE_BINARY_DIR}/_staging)
set(INSTALL_ROOT ${CMAKE_BINARY_DIR}/_install)
#set(CMAKE_PREFIX_PATH ${STAGING_ROOT})
set(DEV_ROOT ${CMAKE_BINARY_DIR}/_devlab)

include(mk/compiler.cmake)

add_subdirectory(tools)
add_subdirectory(libs)
add_subdirectory(apps)
