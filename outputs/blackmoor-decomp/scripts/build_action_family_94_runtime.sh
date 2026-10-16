#!/bin/sh
# RT-32: raw 0x94 screen-file runtime: the pure encoder module and the session binding (the display, the front buffer and
# the file write belong to the host).
# Optional environment: BUILD_DIR, A94_OUTPUT, A94_CFLAGS, A94_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A94_SRC:-$project_dir/src}"
output="${A94_OUTPUT:-$build_dir/libactionfamily94runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A94_CFLAGS:-} \
    "$source_dir/session_bindings_a94.c" "$source_dir/action_family_94_runtime.c" -o "$output"
printf '%s\n' "$output"
