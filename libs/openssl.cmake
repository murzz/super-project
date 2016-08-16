include(ExternalProject)

set(OPENSSL_REPO_URL https://github.com/openssl/openssl.git)
#set(OPENSSL_TAG OpenSSL_1_0_1s)
set(OPENSSL_TAG OpenSSL_1_0_2h)

#option(OPENSSL_BUILD_STATIC "Build static versions of OpenSSL libraries" ON)
option(OPENSSL_BUILD_STATIC "Build static versions of OpenSSL libraries" OFF)

if (UNIX)
   set(OPENSSL_CONFIGURE_COMMAND configure )
   set(OPENSSL_BUILD_COMMAND make -j)
   set(OPENSSL_INSTALL_COMMAND make -j install DESTDIR=${STAGING_ROOT})
endif(UNIX)

if (WIN32)
   if ("$ENV{Platform}" STREQUAL "X64")
      message(STATUS openssl is 64bit)
      set(OPENSSL_PLATFORM "VC-WIN64A")
      set(OPENSSL_BOOTSTRAP COMMAND ms/do_win64a.bat)
   else ()
      message(STATUS openssl is 32bit)
      set(OPENSSL_PLATFORM "VC-WIN32")
      #set(OPENSSL_BOOTSTRAP COMMAND ms/do_ms.bat COMMAND ms/do_nasm.bat)
      set(OPENSSL_BOOTSTRAP no-asm COMMAND ms/do_ms.bat)
   endif()

   #message(STATUS "Configuring OpenSSL for ${OPENSSL_PLATFORM}")
   set(OPENSSL_CONFIGURE_COMMAND
      perl Configure ${OPENSSL_PLATFORM}
      --prefix=${STAGING_ROOT}
      zlib-dynamic
      #--with-zlib-lib=${STAGING_ROOT}/lib/zlibstatic.lib
      --with-zlib-lib=${STAGING_ROOT}/lib
      --with-zlib-include=${STAGING_ROOT}/include
      ${OPENSSL_BOOTSTRAP}
   )
   if (OPENSSL_BUILD_STATIC)
	  message(ERROR openssl is static)
      set(OPENSSL_BUILD_COMMAND nmake -f ms/nt.mak)
      set(OPENSSL_INSTALL_COMMAND nmake -f ms/nt.mak install)
   else()
      set(OPENSSL_BUILD_COMMAND nmake -f ms/ntdll.mak)
      set(OPENSSL_INSTALL_COMMAND nmake -f ms/ntdll.mak install)
   endif()
endif(WIN32)

ExternalProject_Add( openssl
        DEPENDS perl zlib
        GIT_REPOSITORY ${OPENSSL_REPO_URL}
        GIT_TAG ${OPENSSL_TAG}
        CONFIGURE_COMMAND ${OPENSSL_CONFIGURE_COMMAND}
        BUILD_COMMAND ${OPENSSL_BUILD_COMMAND}
        BUILD_IN_SOURCE TRUE
        INSTALL_COMMAND ${OPENSSL_INSTALL_COMMAND}
)

add_dependencies(libs openssl)
