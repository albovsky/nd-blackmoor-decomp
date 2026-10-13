#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$project_dir/build"
output="$output_dir/libhis_pcm_quantize.dylib"
macos_min="${MACOSX_DEPLOYMENT_TARGET:-27.0}"
mkdir -p "$output_dir"

xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
    -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/his_pcm_quantize.c" \
    -o "$output"
printf 'Built native HIS PCM quantizer: %s\n' "$output"
