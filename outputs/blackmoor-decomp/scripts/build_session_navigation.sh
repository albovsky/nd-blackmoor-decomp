#!/bin/sh
# RT-17: view-navigation producer (edge/arrow zones, tick step, cascade pipeline).
# Optional environment: BUILD_DIR, NAV_OUTPUT, NAV_CFLAGS, NAV_SRC (mutation
# checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${NAV_SRC:-$project_dir/src}"
output="${NAV_OUTPUT:-$build_dir/libsession_navigation.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${NAV_CFLAGS:-} -I "$project_dir/src" \
    "$source_dir/session_navigation.c" \
    "$project_dir/src/session_input.c" "$project_dir/src/input_latch.c" \
    "$project_dir/src/input_consume.c" -o "$output"
printf '%s\n' "$output"
