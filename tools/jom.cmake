option(WITH_JOM_FROM_SOURCE "Build JOM frmo source" OFF)

if (WITH_JOM_FROM_SOURCE)
   include(ExternalProject)

   set(JOM_REPO_URL git://code.qt.io/qt-labs/jom.git)
   set(JOM_TAG v1.1.0)

   ExternalProject_Add(jom
       DEPENDS ninja qt4
       GIT_REPOSITORY ${JOM_REPO_URL}
       GIT_TAG ${JOM_TAG}
       INSTALL_DIR ${STAGING_ROOT}
       CMAKE_GENERATOR ${CMAKE_GENERATOR_NINJA}
   )
else(WITH_JOM_FROM_SOURCE)
   include(ExternalProject)

   set(JOM_URL https://download.qt.io/official_releases/jom/jom_1_1_0.zip)
   set(JOM_URL_HASH SHA256=30c38dc105e883cb055ee53cc5db9110ac9d3152c59a1392b53aa664f3be04a0 )

   ExternalProject_Add(jom
       DEPENDS cmake
       URL ${JOM_URL}
       URL_HASH ${JOM_URL_HASH}
       #CMAKE_COMMAND ${CMAKE_COMMAND_NEW}
       INSTALL_DIR ${STAGING_ROOT}
       CONFIGURE_COMMAND ""
       BUILD_COMMAND ""
       INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGING_ROOT}/bin
               COMMAND ${CMAKE_COMMAND} -E copy jom.exe ${STAGING_ROOT}/bin
       BUILD_IN_SOURCE 1
   )
endif(WITH_JOM_FROM_SOURCE)



set(JOM_TOOL ${STAGING_ROOT}/bin/jom.exe PARENT_SCOPE)

add_dependencies(tools jom)
