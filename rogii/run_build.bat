git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
set PATH=%CD%\depot_tools;%PATH%


set DEPOT_TOOLS_WIN_TOOLCHAIN=0

python bin\fetch-gn
python tools\git-sync-deps

bin\gn gen out\release --args="is_official_build=true is_component_build=true is_debug=false skia_use_fontconfig=false skia_use_freetype=false skia_enable_tools=false  skia_use_system_libjpeg_turbo=false  skia_use_system_libwebp=false  skia_use_system_libpng=false  skia_use_system_icu=false  skia_use_system_harfbuzz=false"
ninja -C out\release skia
bin\gn gen out\debug --args="is_official_build=false is_component_build=true is_debug=true skia_use_fontconfig=false skia_use_freetype=false skia_enable_tools=false  skia_use_system_libjpeg_turbo=false  skia_use_system_libwebp=false  skia_use_system_libpng=false  skia_use_system_icu=false  skia_use_system_harfbuzz=false"
ninja -C out\debug skia

