#!/bin/sh
# RT-39: raw 0x4b runtime: the session binding (the loader objects live in the binding; the caption writer and the AUTOTEXT
# lookup belong to the host).
# Optional environment: BUILD_DIR, A4B_OUTPUT, A4B_CFLAGS, A4B_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A4B_SRC:-$project_dir/src}"
output="${A4B_OUTPUT:-$build_dir/libactionfamily4bruntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A4B_CFLAGS:-} \
    "$source_dir/session_bindings_a4b.c" "$source_dir/action_family_4b.c" -o "$output"
printf '%s\n' "$output"
