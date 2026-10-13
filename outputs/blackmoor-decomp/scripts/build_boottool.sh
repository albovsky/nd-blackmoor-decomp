#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="$project_dir/src"
build_dir="$project_dir/build"
mkdir -p "$build_dir"

set -- -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 \
    "$source_dir/hiff.c" "$source_dir/cif_archive.c" "$source_dir/cif_pixels.c" \
    "$source_dir/engine_boot.c" "$source_dir/cif_image.c"
xcrun --sdk macosx clang "$@" "$source_dir/boottool.c" \
    -o "$build_dir/boottool"
xcrun --sdk macosx clang "$@" -fPIC -dynamiclib \
    -o "$build_dir/libengineboot.dylib"

printf 'Built %s and %s (native arm64)\n' \
    "$build_dir/boottool" "$build_dir/libengineboot.dylib"
