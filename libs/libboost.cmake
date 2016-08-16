set(BOOST_REPO_URL https://github.com/boostorg/boost.git)
set(BOOST_TAG boost-1.61.0)
#set(BOOST_SUBMODULES system thread log log_setup chrono regex date_time filesystem)

# na etom uirovne net kompiljatora
#if("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
#   set(BOOST_TOOLSET gcc)
#elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
#   set(BOOST_TOOLSET clang)
#elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
#   set(BOOST_TOOLSET msvc)
#endif()

if (WIN32)
   set(BOOST_TOOLSET msvc)
endif()

if(CMAKE_CROSSCOMPILING)
    #set(BOOST_TOOLSET_TARGET arm)
    set(BOOST_TOOLSET ${BOOST_TOOLSET}-arm)
else()
    #set(BOOST_TOOLSET_TARGET x86_64)
endif()

#set(BOOST_TOOLSET_TARGET ${CMAKE_SYSTEM_PROCESSOR})
#set(BOOST_JAM_TOOLCHAIN
#    "using ${BOOST_TOOLSET} : ${BOOST_TOOLSET_TARGET} : ${CMAKE_CXX_COMPILER}" # terminator ';' is printed via hex code below
#)
#MESSAGE(STATUS ${BOOST_JAM_TOOLCHAIN})
set(BOOST_CONFIGURE_PARAMS
#    --without-libraries=python
#    --without-libraries=iostreams
#    --without-libraries=context
#    --without-libraries=coroutine
#    --without-libraries=coroutine2
#    --without-libraries=mpi
)

set(BOOST_BUILD_PARAMS
   toolset=${BOOST_TOOLSET}
   define=BOOST_USE_WINAPI_VERSION=0x0601
   headers
   #--build-type=complete
   --layout=system
#   -d0 # silent
#    link=static,shared
    link=static
    variant=release
#    threading=single
    runtime-link=shared
#    --without-coroutine
#    --without-coroutine2
#    --without-context
#    --without-iostreams
    --without-python
    --without-mpi
    --without-graph
    --without-graph_parallel
 )

include(ProcessorCount)
ProcessorCount(N)
if(NOT N EQUAL 0)
  set(BOOST_BUILD_PARAMS ${BOOST_BUILD_PARAMS} -j${N})
endif()

if (UNIX)
   set(BOOST_ADD_CUSTOM_TOOLCHAIN_CMD "&& /bin/echo -e ${BOOST_JAM_TOOLCHAIN} \\x3b >> project-config.jam")
   set(BOOST_CONFIGURE_CMD ./bootstrap.sh ${BOOST_CONFIGURE_PARAMS} ${BOOST_ADD_CUSTOM_TOOLCHAIN_CMD})
   set(BOOST_BUILD_CMD ./b2 ${BOOST_BUILD_PARAMS})
   #set(BOOST_INSTALL_CMD ./b2 ${BOOST_BUILD_PARAMS} --stagedir=${STAGING_ROOT} stage)
   # yes, we are abusing prefix here, but I failed to find analogy to DESTDIR
   set(BOOST_INSTALL_CMD ./b2 ${BOOST_BUILD_PARAMS} --prefix=${STAGING_ROOT} install)
endif (UNIX)
if(WIN32)
   if("$ENV{Platform}" STREQUAL "X64")
      #message(STATUS "Configuring boost for x86_64")
      #set(BOOST_BUILD_PARAMS ${BOOST_BUILD_PARAMS} architecture=x86 address-model=64)
      set(BOOST_BUILD_PARAMS ${BOOST_BUILD_PARAMS} address-model=64)
   else("$ENV{Platform}" STREQUAL "X64")
      #message(STATUS "Configuring boost for x86")
   endif("$ENV{Platform}" STREQUAL "X64")

   #if (MSVC)
   #   set(BOOST_BUILD_PARAMS ${BOOST_BUILD_PARAMS} --toolset=msvc-12.0)
#endif(MSVC)
   set(BOOST_CONFIGURE_CMD bootstrap.bat ${BOOST_CONFIGURE_PARAMS})
   set(BOOST_BUILD_CMD b2 ${BOOST_BUILD_PARAMS})
   #set(BOOST_INSTALL_CMD ./b2 ${BOOST_BUILD_PARAMS} --stagedir=${STAGING_ROOT} stage)
   # yes, we are abusing prefix here, but I failed to find analogy to DESTDIR
   set(BOOST_INSTALL_CMD b2 ${BOOST_BUILD_PARAMS} --prefix=${STAGING_ROOT} install)
endif(WIN32)

include(ExternalProject)
ExternalProject_Add(boost
#    URL ${BOOST_URL}
#    URL_HASH ${BOOST_URL_HASH}
    GIT_REPOSITORY ${BOOST_REPO_URL}
    GIT_TAG ${BOOST_TAG}
    GIT_SUBMODULES ${BOOST_SUBMODULES}
    CONFIGURE_COMMAND ${BOOST_CONFIGURE_CMD}
    BUILD_COMMAND ${BOOST_BUILD_CMD}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ${BOOST_INSTALL_CMD}
)

add_dependencies(libs boost)
