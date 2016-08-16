include(ExternalProject)

set(LIBMODBUS_REPO_URL https://github.com/stephane/libmodbus.git)
#set(LIBMODBUS_TAG caade94bf2b9cd8c2a8f10416b7d67ed0448a26f) # HEAD at the moment of creating a patch
#set(LIBMODBUS_TAG v3.1.2) # does not have custom rts callback yet

if (UNIX)
   set(LIBMODBUS_CONFIGURE_COMMAND
                CC=${CMAKE_C_COMPILER} ./autogen.sh &&
                CC=${CMAKE_C_COMPILER} ./configure
                ac_cv_func_malloc_0_nonnull=yes # fix for undefined reference to `rpl_malloc'
                --host=arm
                --enable-static
                --without-documentation
   )
   set(LIBMODBUS_BUILD_COMMAND make -j)
   set(LIBMODBUS_INSTALL_COMMAND make -j install DESTDIR=${STAGING_ROOT})
endif(UNIX)

if (WIN32)
   set(LIBMODBUS_CONFIGURE_COMMAND cscript src/win32/configure.js dry-run=yes)
   set(LIBMODBUS_BUILD_COMMAND msbuild src/win32/modbus-9.sln)
   #set(LIBMODBUS_INSTALL_COMMAND make -j install DESTDIR=${STAGING_ROOT})
endif(WIN32)

ExternalProject_Add( libmodbus
        GIT_REPOSITORY ${LIBMODBUS_REPO_URL}
        GIT_TAG ${LIBMODBUS_TAG}
#        PATCH_COMMAND ${LIBMODBUS_PATCH_COMMAND}
        CONFIGURE_COMMAND ${LIBMODBUS_CONFIGURE_COMMAND}
        BUILD_COMMAND ${LIBMODBUS_BUILD_COMMAND}
#        BUILD_IN_SOURCE TRUE
        INSTALL_COMMAND ${LIBMODBUS_INSTALL_COMMAND}
)

add_dependencies(libs libmodbus)
