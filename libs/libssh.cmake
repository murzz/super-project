include(ExternalProject)

#set(LIBSSH_REPO_URL http://git.libssh.org/projects/libssh.git)
set(LIBSSH_REPO_URL git://git.libssh.org/projects/libssh.git)
set(LIBSSH_TAG libssh-0.7.3)

set(LIBSSH_BUILD_ARGS
    ${COMMON_CMAKE_ARGS}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX=${STAGING_ROOT}
    -DCMAKE_PREFIX_PATH=${STAGING_ROOT} ${CMAKE_PREFIX_PATH}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DWITH_STATIC_LIB=ON
)

ExternalProject_Add(libssh
        DEPENDS cmake zlib openssl
        GIT_REPOSITORY ${LIBSSH_REPO_URL}
        GIT_TAG ${LIBSSH_TAG}
#        INSTALL_DIR ${STAGING_ROOT}
#        CMAKE_COMMAND ${CMAKE_COMMAND_NEW}
        CMAKE_GENERATOR ${CMAKE_GENERATOR_NEW}
        CMAKE_ARGS ${LIBSSH_BUILD_ARGS}
)

add_dependencies(libs libssh)
