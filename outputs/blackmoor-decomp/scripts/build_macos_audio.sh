#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$project_dir/build"
output="$output_dir/libmacos_audio.dylib"
macos_min="${MACOSX_DEPLOYMENT_TARGET:-27.0}"
mkdir -p "$output_dir"

xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min="$macos_min" \
    -std=c++17 -fobjc-arc -fblocks -Wall -Wextra -Wpedantic -Werror -O2 \
    -dynamiclib "$project_dir/src/macos_audio.mm" \
    -framework AVFAudio -framework Foundation \
    -o "$output"
printf 'Built native macOS PCM audio adapter: %s\n' "$output"
