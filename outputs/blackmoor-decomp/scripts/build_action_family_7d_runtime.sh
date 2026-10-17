#!/bin/sh
# RT-41: raw 0x7d return-from-the-examined-item runtime: the second saved-scene record pop + item re-add (RT-19 add step) + session binding.
# Optional environment: BUILD_DIR, A7D_OUTPUT, A7D_CFLAGS, A7D_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A7D_SRC:-$project_dir/src}"
output="${A7D_OUTPUT:-$build_dir/libactionfamily7druntime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A7D_CFLAGS:-} \
    "$source_dir/scene_stack.c" "$source_dir/action_family_7d_runtime.c" "$source_dir/session_bindings_a7d.c" \
    "$source_dir/action_family_78_runtime.c" "$source_dir/action_family_79_runtime.c" \
    "$source_dir/action_core.c" -o "$output"
printf '%s\n' "$output"
