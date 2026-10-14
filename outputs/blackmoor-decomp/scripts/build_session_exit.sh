#!/bin/sh
# Builds the RT-5 scene-exit library (exit state machine, 0x28 binding, A-28
# kernel, caption lifecycle, scene session stack). Optional environment:
#   SESSION_EXIT_OUTPUT   output dylib (default build/libsessionexit.dylib)
#   SESSION_EXIT_CFLAGS   extra compiler flags (sanitizers)
#   SESSION_EXIT_SRC      source directory (mutation checks build a copy)
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output="${SESSION_EXIT_OUTPUT:-$project_dir/build/libsessionexit.dylib}"
source_dir="${SESSION_EXIT_SRC:-$project_dir/src}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g -fPIC -dynamiclib \
    ${SESSION_EXIT_CFLAGS:-} \
    "$source_dir/hiff.c" \
    "$source_dir/scene_resource.c" \
    "$source_dir/scene_conditions.c" \
    "$source_dir/action_core.c" \
    "$source_dir/action_family_64.c" \
    "$source_dir/world_clock.c" \
    "$source_dir/action_ui.c" \
    "$source_dir/scene_executor.c" \
    "$source_dir/scene_session.c" \
    "$source_dir/action_family_28.c" \
    "$source_dir/caption_lifecycle.c" \
    "$source_dir/session_exit.c" \
    "$source_dir/session_bindings_a28.c" \
    -o "$output"
printf 'Built %s (native arm64)\n' "$output"
