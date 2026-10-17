#!/bin/sh
# RT-55: raw 0xf5 Typing Quiz Puzzle runtime + shared score / time display + session binding.
# Optional environment: BUILD_DIR, F5_RUNTIME_OUTPUT, F5_RUNTIME_CFLAGS,
# F5_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${F5_RUNTIME_SRC:-$project_dir/src}"
output="${F5_RUNTIME_OUTPUT:-$build_dir/libactionfamilyf5_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${F5_RUNTIME_CFLAGS:-} \
    "$source_dir/score_time_display.c" "$source_dir/action_family_f5_runtime.c" \
    "$source_dir/session_bindings_af5.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
