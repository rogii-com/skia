#!/bin/bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="${PWD}/depot_tools:${PATH}"


./tools/install_dependencies.sh --yes
python bin/fetch-gn
python tools/git-sync-deps

bin/gn gen out/release --args='is_component_build=true is_debug=false '
ninja -C out/release skia
bin/gn gen out/debug --args="is_component_build=true is_debug=true" 
ninja -C out/debug skia