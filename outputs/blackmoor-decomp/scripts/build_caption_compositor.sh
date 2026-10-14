#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
"$project_dir/scripts/build_caption_layout.sh"
"$project_dir/scripts/build_caption_lifecycle.sh"
"$project_dir/scripts/build_game_resources.sh"
"$project_dir/scripts/build_cifpixels.sh"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/caption_compositor.c" \
    -o "$project_dir/build/libcaptioncompositor.dylib"
echo "Built $project_dir/build/libcaptioncompositor.dylib"
