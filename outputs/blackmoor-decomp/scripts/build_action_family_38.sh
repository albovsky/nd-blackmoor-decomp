#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/action_family_38.c" \
    -o "$build_dir/libactionfamily38.dylib"
printf '%s\n' "$build_dir/libactionfamily38.dylib"
