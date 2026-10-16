#!/bin/sh
# RT-14: raw 0x36 static overlay runtime (COverlay) + session binding.
# Optional environment: BUILD_DIR, A36_RUNTIME_OUTPUT, A36_RUNTIME_CFLAGS,
# A36_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A36_RUNTIME_SRC:-$project_dir/src}"
output="${A36_RUNTIME_OUTPUT:-$build_dir/libactionfamily36_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A36_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_36.c" "$source_dir/action_family_37.c" \
    "$source_dir/action_family_38.c" \
    "$source_dir/action_family_36_runtime.c" \
    "$source_dir/session_bindings_a36.c" "$source_dir/scene_resource.c" \
    "$source_dir/hiff.c" "$source_dir/scene_session.c" \
    "$source_dir/scene_executor.c" "$source_dir/scene_conditions.c" \
    "$source_dir/action_core.c" "$source_dir/action_family_64.c" \
    "$source_dir/world_clock.c" "$source_dir/action_ui.c" \
    "$source_dir/session_input.c" "$source_dir/input_latch.c" \
    "$source_dir/input_consume.c" -o "$output"
printf '%s\n' "$output"
