#!/bin/sh
# RT-49: raw 0x77 Ordering Puzzle runtime + session binding.
# Optional environment: BUILD_DIR, A77_RUNTIME_OUTPUT, A77_RUNTIME_CFLAGS,
# A77_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A77_RUNTIME_SRC:-$project_dir/src}"
output="${A77_RUNTIME_OUTPUT:-$build_dir/libactionfamily77_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A77_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_77_runtime.c" "$source_dir/session_bindings_a77.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
