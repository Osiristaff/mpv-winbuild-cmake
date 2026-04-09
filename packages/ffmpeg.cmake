ExternalProject_Add(ffmpeg
    DEPENDS
        amf-headers
        avisynth-headers
        nvcodec-headers
        bzip2
        lcms2
        openssl
        libssh
        libsrt
        libass
        libbluray
        libpng
        libwebp
        libzimg
        libmysofa
        fontconfig
        harfbuzz
        opus
        vorbis
        libxml2
        libvpl
        libjxl
        shaderc
        libplacebo
        libaribcaption
        aom
        svtav1
        dav1d
        vapoursynth
        rubberband
        libva
        openal-soft
        opencl
        vulkan
        game-music-emu
        liblc3
        libvidstab
        frei0r
        xz
        whisper
    GIT_REPOSITORY https://github.com/Osiristaff/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !tests/ref/fate"
    UPDATE_COMMAND ""
    CONFIGURE_ENVIRONMENT_MODIFICATION
        _IS_CONFIGURE=set:1
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw64
        --toolchain=llvm
        --pkg-config-flags=--static
        --disable-autodetect
        --enable-gpl
        --enable-version3
        --enable-w32threads
        --enable-cross-compile
        --enable-runtime-cpudetect
        --enable-amf
        --enable-avisynth
        --enable-bzlib
        --enable-cuda-llvm
        --enable-d3d11va
        --enable-d3d12va
        --enable-ffnvcodec
        --enable-frei0r
        --enable-iconv
        --enable-lcms2
        --enable-libaom
        --enable-libaribcaption
        --enable-libass
        --enable-libbluray
        --enable-libdav1d
        --enable-libfontconfig
        --enable-libfreetype
        --enable-libfribidi
        --enable-libgme
        --enable-libharfbuzz
        --enable-libjxl
        --enable-liblc3
        --enable-libmysofa
        --enable-libopus
        --enable-libplacebo
        --enable-librubberband
        --enable-libshaderc
        --enable-libsrt
        --enable-libssh
        --enable-libsvtav1
        --enable-libvidstab
        --enable-libvorbis
        --enable-libvpl
        --enable-libwebp
        --enable-libxml2
        --enable-libzimg
        --enable-lzma
        --enable-mediafoundation
        --enable-nvdec
        --enable-nvenc
        --enable-openal
        --enable-opencl
        --enable-opengl
        --enable-openssl
        --enable-vaapi
        --enable-vapoursynth
        --enable-vulkan
        --enable-whisper
        --enable-zlib
    ${novzeroupper} <SOURCE_DIR>/libavutil/x86/x86inc.asm
    ${trim_path} <BINARY_DIR>/config.h
    BUILD_ENVIRONMENT_MODIFICATION
        _PACKAGE_NAME=set:${package}
        _BINARY_DIR=set:<BINARY_DIR>
        _IS_EXCEPTIONS_ALLOWED=set:1
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-headers install-libs install-progs
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
