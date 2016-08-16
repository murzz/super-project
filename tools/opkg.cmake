include(ExternalProject)

set(OPKG_REPO_URL http://git.yoctoproject.org/git/opkg-utils)
set(OPKG_TAG "e022fd082ecdc3b7d993fcadd5f4625f5c1d97ea")

ExternalProject_Add(opkg-utils
    GIT_REPOSITORY ${OPKG_REPO_URL}
    GIT_TAG ${OPKG_TAG}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make -j
    INSTALL_COMMAND make -j install DESTDIR=${STAGING_ROOT}
    BUILD_IN_SOURCE 1
)
