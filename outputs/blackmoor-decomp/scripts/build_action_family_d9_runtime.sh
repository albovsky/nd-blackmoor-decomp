#!/bin/sh
# RT-24: raw 0xd9 Mouselight puzzle runtime + session binding.
# Optional environment: BUILD_DIR, D9_RUNTIME_OUTPUT, D9_RUNTIME_CFLAGS,
# D9_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${D9_RUNTIME_SRC:-$project_dir/src}"
output="${D9_RUNTIME_OUTPUT:-$build_dir/libactionfamilyd9_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${D9_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_d9_runtime.c" "$source_dir/session_bindings_ad9.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
