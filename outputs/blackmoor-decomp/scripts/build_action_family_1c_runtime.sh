#!/bin/sh
# RT-57: raw 0x1c runtime: the session binding over the kernel.
# Optional environment: BUILD_DIR, A1C_OUTPUT, A1C_CFLAGS, A1C_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A1C_SRC:-$project_dir/src}"
output="${A1C_OUTPUT:-$build_dir/libactionfamily1cruntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A1C_CFLAGS:-} \
    "$source_dir/session_bindings_a1c.c" "$source_dir/action_family_1c_runtime.c" \
    "$source_dir/action_family_1c.c" -o "$output"
printf '%s\n' "$output"
