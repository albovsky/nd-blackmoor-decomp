#!/bin/sh
# RT-28: raw 0x6e save-the-running-scene runtime: the saved scene record (scene_stack) + session binding.
# Optional environment: BUILD_DIR, A6E_OUTPUT, A6E_CFLAGS, A6E_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A6E_SRC:-$project_dir/src}"
output="${A6E_OUTPUT:-$build_dir/libactionfamily6e.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A6E_CFLAGS:-} \
    "$source_dir/scene_stack.c" "$source_dir/session_bindings_a6e.c" \
    "$source_dir/action_core.c" -o "$output"
printf '%s\n' "$output"
