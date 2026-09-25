ExternalProject_Add(mimalloc
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REPOSITORY https://github.com/microsoft/mimalloc.git
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main3
    CONFIGURE_ENVIRONMENT_MODIFICATION
        _IS_CONFIGURE=set:1
    CONFIGURE_COMMAND ${EXEC} sed -i [['s/haswell/znver4/g']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} sed -i [['/fno-builtin/d']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} sed -i [['/WIN32_WINNT/d']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DMI_BUILD_SHARED=ON
        -DMI_BUILD_STATIC=OFF
        -DMI_BUILD_OBJECT=OFF
        -DMI_BUILD_TESTS=OFF
        -DMI_INSTALL_TOPLEVEL=ON
        -DMI_OVERRIDE=ON
        -DMI_SKIP_COLLECT_ON_EXIT=ON
        -DMI_USE_CXX=ON
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_UNITY_BUILD=ON
        -DCMAKE_UNITY_BUILD_BATCH_SIZE=0
        -DCMAKE_SHARED_LIBRARY_PREFIX_CXX=''
        -DMI_EXTRA_CPPDEFS='MI_DEBUG=0;MI_DEFAULT_ALLOW_LARGE_OS_PAGES=1;MI_OPT_SIMD=1'
    BUILD_ENVIRONMENT_MODIFICATION
        _PACKAGE_NAME=set:${package}
        _BINARY_DIR=set:<BINARY_DIR>
        _LOCAL_EXEC_TLS=set:0
        _IS_EXCEPTIONS_ALLOWED=set:1
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mimalloc)
cleanup(mimalloc install)
