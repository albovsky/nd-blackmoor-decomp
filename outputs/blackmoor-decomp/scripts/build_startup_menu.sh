#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="$project_dir/src"
build_dir="$project_dir/build"
mkdir -p "$build_dir"

xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$source_dir/hiff.c" "$source_dir/engine_boot.c" \
    "$source_dir/startup_menu.c" \
    -o "$build_dir/libstartupmenu.dylib"

printf 'Built %s (native arm64)\n' "$build_dir/libstartupmenu.dylib"
