#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min=11.0 \
    -std=c++17 -fobjc-arc -Wall -Wextra -Wpedantic -Werror -O2 \
    -dynamiclib "$project_dir/src/macos_platform.mm" \
    -framework AppKit -framework Foundation -framework CoreGraphics \
    -o "$project_dir/build/libmacosplatform.dylib"
