#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/game_resources.c" "$project_dir/src/cif_archive.c" \
    "$project_dir/src/cif_image.c" "$project_dir/src/cif_pixels.c" \
    -o "$project_dir/build/libgameresources.dylib"
