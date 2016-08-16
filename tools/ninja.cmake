include(ExternalProject)

set(NINJA_REPO_URL https://github.com/ninja-build/ninja.git)
set(NINJA_TAG v1.6.0)

ExternalProject_Add(ninja
    DEPENDS python
    GIT_REPOSITORY ${NINJA_REPO_URL}
    GIT_TAG ${NINJA_TAG}
    CONFIGURE_COMMAND python configure.py --bootstrap
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGING_ROOT}/bin
            COMMAND ${CMAKE_COMMAND} -E copy ninja.exe ${STAGING_ROOT}/bin
    BUILD_IN_SOURCE 1
)

set(CMAKE_GENERATOR_NEW Ninja PARENT_SCOPE)
#set(CMAKE_GENERATOR Ninja PARENT_SCOPE)

add_dependencies(tools ninja)
