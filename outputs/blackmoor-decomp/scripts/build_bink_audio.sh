#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$project_dir/build"
output="$output_dir/libbink_audio.dylib"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
macos_min="${MACOSX_DEPLOYMENT_TARGET:-27.0}"
mkdir -p "$output_dir"

xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
    -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    -I"$ffmpeg_prefix/include" \
    "$project_dir/src/bink_audio.c" \
    -L"$ffmpeg_prefix/lib" \
    -lavformat -lavcodec -lavutil -lswresample \
    -Wl,-rpath,"$ffmpeg_prefix/lib" \
    -o "$output"
printf 'Built native Bink audio adapter: %s\n' "$output"
