#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/action_family_97.c" "$project_dir/src/action_family_97_runtime.c" \
    "$project_dir/src/session_bindings_a97.c" "$project_dir/src/scene_resource.c" \
    "$project_dir/src/hiff.c" "$project_dir/src/scene_session.c" \
    "$project_dir/src/scene_executor.c" "$project_dir/src/scene_conditions.c" \
    "$project_dir/src/action_core.c" "$project_dir/src/action_family_64.c" \
    "$project_dir/src/world_clock.c" "$project_dir/src/action_ui.c" \
    "$project_dir/src/session_input.c" "$project_dir/src/input_latch.c" \
    "$project_dir/src/input_consume.c" -o "$build_dir/libactionfamily97_runtime.dylib"
printf '%s\n' "$build_dir/libactionfamily97_runtime.dylib"
