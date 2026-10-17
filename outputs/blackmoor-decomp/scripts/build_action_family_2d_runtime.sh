#!/bin/sh
# RT-36: raw 0x2d random-movie set runtime: the kernel, its session binding and the parts of the raw 0x2e binding and the scene parser it reuses.
# Optional environment: BUILD_DIR, A2D_OUTPUT, A2D_CFLAGS, A2D_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A2D_SRC:-$project_dir/src}"
output="${A2D_OUTPUT:-$build_dir/libactionfamily2druntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A2D_CFLAGS:-} \
    "$source_dir/session_bindings_a2d.c" "$source_dir/action_family_2d_runtime.c" "$source_dir/session_bindings_a2e.c" "$source_dir/action_family_2e.c" "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
