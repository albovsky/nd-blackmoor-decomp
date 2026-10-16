#!/bin/sh
# RT-33: raw 0x2e random-movie control runtime: the session binding and the A-2E.1 decoder it reads the body with.
# Optional environment: BUILD_DIR, A2E_OUTPUT, A2E_CFLAGS, A2E_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A2E_SRC:-$project_dir/src}"
output="${A2E_OUTPUT:-$build_dir/libactionfamily2eruntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A2E_CFLAGS:-} \
    "$source_dir/session_bindings_a2e.c" "$source_dir/action_family_2e.c" -o "$output"
printf '%s\n' "$output"
