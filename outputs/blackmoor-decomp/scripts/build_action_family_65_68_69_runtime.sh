#!/bin/sh
# RT-37: raw 0x65 / 0x68 / 0x69 runtime: the session binding (the timer records and the save routine belong to the host).
# Optional environment: BUILD_DIR, A65_OUTPUT, A65_CFLAGS, A65_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A65_SRC:-$project_dir/src}"
output="${A65_OUTPUT:-$build_dir/libactionfamily656869runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A65_CFLAGS:-} \
    "$source_dir/session_bindings_a65_a68_a69.c" -o "$output"
printf '%s\n' "$output"
