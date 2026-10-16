#!/bin/sh
# RT-27: raw 0x4f compare-and-set-event-flag kernel + session binding (+ the action_core world type it reads).
# Optional environment: BUILD_DIR, A4F_OUTPUT, A4F_CFLAGS, A4F_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A4F_SRC:-$project_dir/src}"
output="${A4F_OUTPUT:-$build_dir/libactionfamily4f.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -ffp-contract=off -fPIC -dynamiclib \
    ${A4F_CFLAGS:-} \
    "$source_dir/action_family_4f.c" "$source_dir/session_bindings_a4f.c" \
    "$source_dir/action_core.c" -o "$output"
printf '%s\n' "$output"
