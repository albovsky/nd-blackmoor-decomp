#!/bin/sh
# RT-38: raw 0x45 runtime: the session binding (the timer records and the loader word table belong to the host).
# Optional environment: BUILD_DIR, A45_OUTPUT, A45_CFLAGS, A45_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A45_SRC:-$project_dir/src}"
output="${A45_OUTPUT:-$build_dir/libactionfamily45runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A45_CFLAGS:-} \
    "$source_dir/session_bindings_a45.c" "$source_dir/session_bindings_a65_a68_a69.c" -o "$output"
printf '%s\n' "$output"
