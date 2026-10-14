#!/bin/sh
# Builds the RT-3 session-binding library (scene session + reviewed kernels +
# the new binding modules). Optional environment:
#   SESSION_BINDINGS_OUTPUT   output dylib (default build/libsessionbindings.dylib)
#   SESSION_BINDINGS_CFLAGS   extra compiler flags (sanitizers)
#   SESSION_BINDINGS_SRC      source directory (mutation checks build a copy)
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output="${SESSION_BINDINGS_OUTPUT:-$project_dir/build/libsessionbindings.dylib}"
source_dir="${SESSION_BINDINGS_SRC:-$project_dir/src}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g -fPIC -dynamiclib \
    ${SESSION_BINDINGS_CFLAGS:-} \
    "$source_dir/hiff.c" \
    "$source_dir/scene_resource.c" \
    "$source_dir/scene_conditions.c" \
    "$source_dir/action_core.c" \
    "$source_dir/action_family_64.c" \
    "$source_dir/world_clock.c" \
    "$source_dir/action_ui.c" \
    "$source_dir/scene_executor.c" \
    "$source_dir/scene_session.c" \
    "$source_dir/action_family_62.c" \
    "$source_dir/action_family_62_interaction.c" \
    "$source_dir/action_family_51.c" \
    "$source_dir/session_bindings_a62.c" \
    "$source_dir/session_bindings_a51.c" \
    -o "$output"
printf 'Built %s (native arm64)\n' "$output"
