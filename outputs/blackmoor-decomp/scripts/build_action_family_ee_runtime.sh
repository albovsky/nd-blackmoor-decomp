#!/bin/sh
# RT-60: raw 0xee Memory puzzle runtime + session binding.
# Optional environment: BUILD_DIR, AEE_RUNTIME_OUTPUT, AEE_RUNTIME_CFLAGS,
# AEE_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${AEE_RUNTIME_SRC:-$project_dir/src}"
output="${AEE_RUNTIME_OUTPUT:-$build_dir/libactionfamilyee_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${AEE_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_ee_runtime.c" "$source_dir/session_bindings_aee.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
