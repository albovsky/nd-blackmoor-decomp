#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Wconversion -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/avf_decoder.c" \
    -o "$project_dir/build/libavfdecoder.dylib"
echo "Built $project_dir/build/libavfdecoder.dylib"
