#!/bin/sh
# RT-50: raw 0xd0 Piano Puzzle runtime + session binding.
# Optional environment: BUILD_DIR, AD0_RUNTIME_OUTPUT, AD0_RUNTIME_CFLAGS,
# AD0_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${AD0_RUNTIME_SRC:-$project_dir/src}"
output="${AD0_RUNTIME_OUTPUT:-$build_dir/libactionfamilyd0_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${AD0_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_d0_runtime.c" "$source_dir/session_bindings_ad0.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
