#!/bin/sh
# RT-40: raw 0x1b runtime: the session binding over the kernel and the A-1B.1 decoder.
# Optional environment: BUILD_DIR, A1B_RT_OUTPUT, A1B_RT_CFLAGS, A1B_RT_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A1B_RT_SRC:-$project_dir/src}"
output="${A1B_RT_OUTPUT:-$build_dir/libactionfamily1bruntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A1B_RT_CFLAGS:-} \
    "$source_dir/session_bindings_a1b.c" "$source_dir/action_family_1b_runtime.c" "$source_dir/action_family_1b.c" -o "$output"
printf '%s\n' "$output"
