ExternalProject_Add(mpv
    DEPENDS
        nvcodec-headers
        ffmpeg
        fribidi
        lcms2
        libarchive
        libass
        libiconv
        libjpeg
        libpng
        luajit
        rubberband
        uchardet
        mujs
        vulkan
        shaderc
        libplacebo
        spirv-cross
        vapoursynth
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --cross-file=${MESON_CROSS}
        -Db_lto=true
        -Dlua=luajit
        -Djavascript=enabled
        -Dlibarchive=enabled
        -Dlibbluray=enabled
        -Duchardet=enabled
        -Drubberband=enabled
        -Dlcms2=enabled
        -Dspirv-cross=enabled
        -Dvulkan=enabled
        -Dvapoursynth=enabled
        -Dwin32-subsystem=console
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES install
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.exe                 ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/etc/mpv-register.bat    ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv-register.bat
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/etc/mpv-unregister.bat  ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv-unregister.bat
    COMMENT "Copying mpv binaries and manual"
)

set(RENAME ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/rename.sh)
file(WRITE ${RENAME}
"#!/bin/bash
cd $1
GIT=$(git rev-parse --short=7 HEAD)
mv $2 $2-git-\${GIT}")

ExternalProject_Add_Step(mpv copy-package-dir
    DEPENDEES copy-binary
    COMMAND chmod 755 ${RENAME}
    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-package ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    LOG 1
)

force_rebuild_git(mpv)
force_meson_configure(mpv)
cleanup(mpv copy-package-dir)
