#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min=11.0 \
    -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -fPIC \
    -c "$project_dir/src/native_display_geometry.c" \
    -o "$project_dir/build/native-display-geometry-platform.o"
xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min=11.0 \
    -std=c++17 -fobjc-arc -Wall -Wextra -Wpedantic -Werror -O2 \
    -dynamiclib "$project_dir/src/macos_platform.mm" "$project_dir/build/native-display-geometry-platform.o" \
    -framework AppKit -framework Foundation -framework CoreGraphics \
    -o "$project_dir/build/libmacosplatform.dylib"
