#!/bin/sh
# RT-47: raw 0xf6 card puzzle runtime + session binding.
# Optional environment: BUILD_DIR, F6_RUNTIME_OUTPUT, F6_RUNTIME_CFLAGS,
# F6_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${F6_RUNTIME_SRC:-$project_dir/src}"
output="${F6_RUNTIME_OUTPUT:-$build_dir/libactionfamilyf6_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${F6_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_f6_runtime.c" "$source_dir/session_bindings_af6.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
