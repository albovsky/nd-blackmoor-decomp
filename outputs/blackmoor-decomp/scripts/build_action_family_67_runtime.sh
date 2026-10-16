#!/bin/sh
# RT-30: raw 0x67 start-flag runtime: the session binding (the flag itself belongs to the host).
# Optional environment: BUILD_DIR, A67_OUTPUT, A67_CFLAGS, A67_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A67_SRC:-$project_dir/src}"
output="${A67_OUTPUT:-$build_dir/libactionfamily67runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A67_CFLAGS:-} \
    "$source_dir/session_bindings_a67.c" -o "$output"
printf '%s\n' "$output"
