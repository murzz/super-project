include(ExternalProject)

set(SOLANET_DESKTOP_REPO_URL git@bitbucket.org:solanet/desktop.git)
#set(SOLANET_DESKTOP_TAG 1.1.9)
set(SOLANET_DESKTOP_TAG devel)

set(SOLANET_DESKTOP_ARGS
   ${SOLANET_DESKTOP_ARGS}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT}
    -DCMAKE_PREFIX_PATH=${STAGING_ROOT} ${CMAKE_PREFIX_PATH}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DBOOST_ROOT=${STAGING_ROOT}
    #-DBOOST_INCLUDEDIR=${STAGING_ROOT}/include
    #-DBOOST_LIBRARYDIR=${STAGING_ROOT}/lib
	#-DWITH_STATIC_LIBSSH=ON
)

ExternalProject_Add(solanet-desktop
        DEPENDS cmake ninja libssh qt boost
        GIT_REPOSITORY ${SOLANET_DESKTOP_REPO_URL}
        GIT_TAG ${SOLANET_DESKTOP_TAG}
        SOURCE_DIR ${DEV_ROOT}/solanet-desktop
        CMAKE_COMMAND ${CMAKE_COMMAND_NEW}
        CMAKE_GENERATOR ${CMAKE_GENERATOR_NEW}
        CMAKE_ARGS ${SOLANET_DESKTOP_ARGS}
)

add_dependencies(apps solanet-desktop)
