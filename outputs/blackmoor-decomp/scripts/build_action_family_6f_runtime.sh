#!/bin/sh
# RT-29: raw 0x6f return-to-the-saved-scene runtime: the pop (scene_stack) + session binding.
# Optional environment: BUILD_DIR, A6F_OUTPUT, A6F_CFLAGS, A6F_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A6F_SRC:-$project_dir/src}"
output="${A6F_OUTPUT:-$build_dir/libactionfamily6f.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A6F_CFLAGS:-} \
    "$source_dir/scene_stack.c" "$source_dir/session_bindings_a6f.c" \
    "$source_dir/action_core.c" -o "$output"
printf '%s\n' "$output"
