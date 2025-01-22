SETLOCAL EnableDelayedExpansion

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
set PATH=%CD%\depot_tools;%PATH%


set DEPOT_TOOLS_WIN_TOOLCHAIN=0

set win_vc=!VCINSTALLDIR:\=\\!
set win_toolchain_version=!VSCMD_ARG_VCVARS_VER!
set win_sdk=!WindowsSdkDir:\=\\!
set win_sdk_version=!VSCMD_ARG_winsdk!

RMDIR /Q /S out

python bin\fetch-gn
python tools\git-sync-deps

FOR  %%D IN (release debug) DO (
    ECHO Build %%D

    mkdir out\%%D
    (
    ECHO is_official_build=false
    ECHO is_component_build=true
    ECHO skia_use_fontconfig=false
    ECHO skia_use_freetype=true
    ECHO skia_enable_tools=false
    ECHO skia_use_system_libjpeg_turbo=false
    ECHO skia_use_system_libwebp=false
    ECHO skia_use_system_libpng=false
    ECHO skia_use_system_icu=false
    ECHO skia_use_system_harfbuzz=false
    ECHO win_vc = "%win_vc%"
    ECHO win_toolchain_version =  "%win_toolchain_version%"
    ECHO win_sdk = "%win_sdk%"
    ECHO win_sdk_version = "%win_sdk_version%"
    ) > out\%%D\args.gn

    IF "%%D" == "debug" (
        (
        ECHO is_debug=true
        ECHO extra_cflags=["/MDd"]
        ) >> out\%%D\args.gn
    ) ELSE (
        (
        ECHO is_debug=false
        ECHO extra_cflags=["/MD"]
        ) >> out\%%D\args.gn
    )

    bin\gn gen out\%%D
    ninja -C out\%%D skia
)
