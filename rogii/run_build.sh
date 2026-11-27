#!/bin/bash
set -euo pipefail

# python3 and ninja come from the build image (consoledev); depot_tools is not needed on Linux
command -v python >/dev/null || ln -s "$(command -v python3)" /usr/local/bin/python

update-alternatives --install /bin/cc cc /usr/bin/gcc 100
update-alternatives --install /bin/c++ c++ /usr/bin/g++ 100

python3 ./bin/fetch-gn
python3 ./tools/git-sync-deps

bin/gn gen out/release --args="is_official_build=false is_component_build=true is_debug=false skia_use_fontconfig=false skia_use_freetype=false skia_enable_tools=false  skia_use_system_libjpeg_turbo=false  skia_use_system_libwebp=false  skia_use_system_libpng=false  skia_use_system_icu=false  skia_use_system_harfbuzz=false"
ninja -C out/release skia
bin/gn gen out/debug --args="is_official_build=false is_component_build=true is_debug=true skia_use_fontconfig=false skia_use_freetype=false skia_enable_tools=false  skia_use_system_libjpeg_turbo=false  skia_use_system_libwebp=false  skia_use_system_libpng=false  skia_use_system_icu=false  skia_use_system_harfbuzz=false"
ninja -C out/debug skia
