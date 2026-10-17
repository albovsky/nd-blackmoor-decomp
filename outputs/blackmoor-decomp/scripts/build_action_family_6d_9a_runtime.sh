#!/bin/sh
# RT-57: raw 0x6d and 0x9a runtimes: the session bindings over the two kernels.
# Optional environment: BUILD_DIR, A6D9A_OUTPUT, A6D9A_CFLAGS, A6D9A_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A6D9A_SRC:-$project_dir/src}"
output="${A6D9A_OUTPUT:-$build_dir/libactionfamily6d9aruntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A6D9A_CFLAGS:-} \
    "$source_dir/session_bindings_a6d_a9a.c" "$source_dir/action_family_6d_runtime.c" \
    "$source_dir/action_family_9a_runtime.c" \
    "$source_dir/action_family_6d.c" "$source_dir/action_family_9a.c" -o "$output"
printf '%s\n' "$output"
