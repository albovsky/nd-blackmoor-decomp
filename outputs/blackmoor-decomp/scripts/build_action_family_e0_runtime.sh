#!/bin/sh
# RT-51: raw 0xd6 and 0xe0 keypad puzzle runtime + session binding.
# Optional environment: BUILD_DIR, E0_RUNTIME_OUTPUT, E0_RUNTIME_CFLAGS,
# E0_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${E0_RUNTIME_SRC:-$project_dir/src}"
output="${E0_RUNTIME_OUTPUT:-$build_dir/libactionfamilye0_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${E0_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_e0_runtime.c" "$source_dir/session_bindings_ae0.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
