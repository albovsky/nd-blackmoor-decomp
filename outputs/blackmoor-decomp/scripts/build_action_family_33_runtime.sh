#!/bin/sh
# RT-46: raw 0x33 secondary video runtime: the kernel and its session binding.
# Optional environment: BUILD_DIR, A33_OUTPUT, A33_CFLAGS, A33_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A33_SRC:-$project_dir/src}"
output="${A33_OUTPUT:-$build_dir/libactionfamily33runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A33_CFLAGS:-} \
    "$source_dir/session_bindings_a33.c" "$source_dir/action_family_33_runtime.c" "$source_dir/scene_resource.c" \
    "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
