#!/bin/sh
# RT-42: raw 0x47 runtime: the session binding over the journal entry kernel (the AUTOTEXT lookup belongs to the host).
# Optional environment: BUILD_DIR, A47_OUTPUT, A47_CFLAGS, A47_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A47_SRC:-$project_dir/src}"
output="${A47_OUTPUT:-$build_dir/libactionfamily47runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A47_CFLAGS:-} \
    "$source_dir/session_bindings_a47.c" "$source_dir/action_family_47_runtime.c" -o "$output"
printf '%s\n' "$output"
