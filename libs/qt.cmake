include(ExternalProject)

set(QT_REPO_URL https://code.qt.io/qt/qt5.git)
set(QT_TAG v5.7.0)

if (UNIX)
   set(QT_CONFIGURE_COMMAND
                CC=${CMAKE_C_COMPILER} ./autogen.sh &&
                CC=${CMAKE_C_COMPILER} ./configure
                ac_cv_func_malloc_0_nonnull=yes # fix for undefined reference to `rpl_malloc'
                --host=arm
                --enable-static
                --without-documentation
   )
   set(QT_BUILD_COMMAND JOM_TOOL -j)
   set(QT_INSTALL_COMMAND make -j install DESTDIR=${STAGING_ROOT})
endif(UNIX)

if (WIN32)
   #set(QT_CONFIGURE_COMMAND configure -opensource -confirm-license -mp -nomake examples -nomake tests -platform win32-msvc2012)
   #set(QT_CONFIGURE_COMMAND configure -opensource -confirm-license -mp -nomake examples -nomake tests -prefix "${STAGING_ROOT}" -make-tool jom)
   set(QT_CONFIGURE_COMMAND configure.bat -opensource -confirm-license -mp -nomake examples -nomake tests -prefix "${STAGING_ROOT}")
   set(QT_BUILD_COMMAND ${JOM_TOOL})
   set(QT_INSTALL_COMMAND ${JOM_TOOL} install)

   include(ProcessorCount)
   ProcessorCount(N)
   if(NOT N EQUAL 0)
      set(QT_BUILD_COMMAND ${QT_BUILD_COMMAND} /J ${N})
   endif(NOT N EQUAL 0)
endif(WIN32)

ExternalProject_Add(qt
        DEPENDS perl python jom
        GIT_REPOSITORY ${QT_REPO_URL}
        GIT_TAG ${QT_TAG}
        CONFIGURE_COMMAND ${QT_CONFIGURE_COMMAND}
        BUILD_COMMAND ${QT_BUILD_COMMAND}
        BUILD_IN_SOURCE TRUE
        INSTALL_COMMAND ${QT_INSTALL_COMMAND}
)

add_dependencies(libs qt)
