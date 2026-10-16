#!/bin/sh
# RT-26: raw 0x95 Set Volume kernel + session binding + the sound_control kernel it drives.
# Optional environment: BUILD_DIR, A95_OUTPUT, A95_CFLAGS, A95_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A95_SRC:-$project_dir/src}"
output="${A95_OUTPUT:-$build_dir/libactionfamily95.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -ffp-contract=off -fPIC -dynamiclib \
    ${A95_CFLAGS:-} \
    "$source_dir/action_family_95.c" "$source_dir/session_bindings_a95.c" \
    "$source_dir/sound_control.c" -o "$output"
printf '%s\n' "$output"
