#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="$project_dir/src"
build_dir="$project_dir/build"
mkdir -p "$build_dir"

common_flags="-arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O2"
# Intentional word splitting here passes a fixed list of compiler flags.
# shellcheck disable=SC2086
xcrun --sdk macosx clang $common_flags \
    "$source_dir/hiff.c" "$source_dir/hifftool.c" \
    -o "$build_dir/hifftool"
# shellcheck disable=SC2086
xcrun --sdk macosx clang $common_flags -fPIC -dynamiclib \
    "$source_dir/hiff.c" \
    -o "$build_dir/libhiff.dylib"

printf 'Built %s and %s\n' \
    "$build_dir/hifftool" "$build_dir/libhiff.dylib"
