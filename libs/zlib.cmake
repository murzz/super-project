include(ExternalProject)

set(ZLIB_REPO_URL https://github.com/madler/zlib.git)
set(ZLIB_TAG v1.2.8)

set(ZLIB_ARGS
   ${COMMON_CMAKE_ARGS}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX=${STAGING_ROOT}
    -DCMAKE_PREFIX_PATH=${STAGING_ROOT} ${CMAKE_PREFIX_PATH}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
)

ExternalProject_Add(zlib
        DEPENDS cmake
        GIT_REPOSITORY ${ZLIB_REPO_URL}
        GIT_TAG ${ZLIB_TAG}
        CMAKE_COMMAND ${CMAKE_COMMAND_NEW}
        CMAKE_GENERATOR ${CMAKE_GENERATOR_NEW}
        CMAKE_ARGS ${ZLIB_ARGS}
)

add_dependencies(libs zlib)
