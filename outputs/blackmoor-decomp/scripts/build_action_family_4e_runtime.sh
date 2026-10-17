#!/bin/sh
# RT-44: raw 0x4e runtime: the session binding over the float value recomputation kernel.
# Optional environment: BUILD_DIR, A4E_OUTPUT, A4E_CFLAGS, A4E_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A4E_SRC:-$project_dir/src}"
output="${A4E_OUTPUT:-$build_dir/libactionfamily4eruntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A4E_CFLAGS:-} \
    "$source_dir/session_bindings_a4e.c" "$source_dir/action_family_4e_runtime.c" "$source_dir/action_family_4e.c" \
    "$source_dir/action_core.c" -o "$output"
printf '%s\n' "$output"
