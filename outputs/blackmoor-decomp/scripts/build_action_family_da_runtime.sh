#!/bin/sh
# RT-59: raw 0xda Bul puzzle runtime + session binding.
# Optional environment: BUILD_DIR, DA_RUNTIME_OUTPUT, DA_RUNTIME_CFLAGS,
# DA_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${DA_RUNTIME_SRC:-$project_dir/src}"
output="${DA_RUNTIME_OUTPUT:-$build_dir/libactionfamilyda_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${DA_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_da_runtime.c" "$source_dir/session_bindings_ada.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
