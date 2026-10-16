#!/bin/sh
# RT-35: raw 0xd1 Turning Puzzle runtime + session binding.
# Optional environment: BUILD_DIR, D1_RUNTIME_OUTPUT, D1_RUNTIME_CFLAGS,
# D1_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${D1_RUNTIME_SRC:-$project_dir/src}"
output="${D1_RUNTIME_OUTPUT:-$build_dir/libactionfamilyd1_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${D1_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_d1_runtime.c" "$source_dir/session_bindings_ad1.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
