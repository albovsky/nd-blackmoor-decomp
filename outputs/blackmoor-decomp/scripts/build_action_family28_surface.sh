#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/action_family_28.c" \
    "$project_dir/src/action_family28_surface.c" \
    -lm -o "$project_dir/build/libactionfamily28surface.dylib"
printf 'Built %s (native arm64)\n' "$project_dir/build/libactionfamily28surface.dylib"
