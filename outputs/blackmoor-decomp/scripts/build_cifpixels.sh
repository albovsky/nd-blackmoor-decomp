#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="$project_dir/src"
build_dir="$project_dir/build"
mkdir -p "$build_dir"

common_flags="-arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O2"
# Intentional word splitting here passes a fixed list of compiler flags.
# shellcheck disable=SC2086
xcrun --sdk macosx clang $common_flags -fPIC -dynamiclib \
    "$source_dir/cif_pixels.c" \
    -o "$build_dir/libcifpixels.dylib"

printf 'Built %s\n' "$build_dir/libcifpixels.dylib"
