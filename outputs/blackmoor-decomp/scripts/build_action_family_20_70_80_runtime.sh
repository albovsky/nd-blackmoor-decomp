#!/bin/sh
# RT-48: raw 0x20, 0x70 and 0x80 runtimes: the session bindings over the three small kernels.
# Optional environment: BUILD_DIR, A207080_OUTPUT, A207080_CFLAGS, A207080_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A207080_SRC:-$project_dir/src}"
output="${A207080_OUTPUT:-$build_dir/libactionfamily207080runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A207080_CFLAGS:-} \
    "$source_dir/session_bindings_a20_a70_a80.c" "$source_dir/action_family_20_runtime.c" \
    "$source_dir/action_family_70_runtime.c" "$source_dir/action_family_80_runtime.c" \
    "$source_dir/action_family_20.c" "$source_dir/action_family_70.c" "$source_dir/action_family_80.c" -o "$output"
printf '%s\n' "$output"
