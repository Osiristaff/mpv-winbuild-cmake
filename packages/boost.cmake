ExternalProject_Add(boost
    URL https://github.com/boostorg/boost/releases/download/boost-1.91.0-1/boost-1.91.0-1-b2-nodocs.tar.xz
    URL_HASH SHA256=7334bb672b9c7aa135da88bcc3111a64a198be9a7d44eb5151d9248e7cfd43ef
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(boost install)
