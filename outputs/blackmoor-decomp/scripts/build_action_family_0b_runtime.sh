#!/bin/sh
# RT-16: raw 0x0b scene-change hotspot runtime + session binding (built on the RT-15 cell types).
# The RT-15 binding is linked too so the oracle can mix raw 0x17 decoy rows into 0x0b scenes.
# Optional environment: BUILD_DIR, A0B_RUNTIME_OUTPUT, A0B_RUNTIME_CFLAGS,
# A0B_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A0B_RUNTIME_SRC:-$project_dir/src}"
output="${A0B_RUNTIME_OUTPUT:-$build_dir/libactionfamily0b_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A0B_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_0b_runtime.c" "$source_dir/action_family_17_runtime.c" \
    "$source_dir/session_bindings_a0b.c" "$source_dir/session_bindings_a17.c" "$source_dir/scene_resource.c" \
    "$source_dir/hiff.c" "$source_dir/scene_session.c" \
    "$source_dir/scene_executor.c" "$source_dir/scene_conditions.c" \
    "$source_dir/action_core.c" "$source_dir/action_family_64.c" \
    "$source_dir/world_clock.c" "$source_dir/action_ui.c" \
    "$source_dir/session_input.c" "$source_dir/input_latch.c" \
    "$source_dir/input_consume.c" -o "$output"
printf '%s\n' "$output"
