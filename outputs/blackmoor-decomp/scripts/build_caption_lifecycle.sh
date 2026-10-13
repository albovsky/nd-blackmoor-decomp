#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/caption_lifecycle.c" \
    -o "$project_dir/build/libcaptionlifecycle.dylib"
echo "Built $project_dir/build/libcaptionlifecycle.dylib"
