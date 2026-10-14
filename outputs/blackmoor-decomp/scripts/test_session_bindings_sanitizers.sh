#!/bin/sh
# ASan + UBSan run of the RT-3 binding/hook fixtures on bounded malformed input.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build/sanitizers}"
mkdir -p "$build_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=undefined \
    "$project_dir/src/hiff.c" \
    "$project_dir/src/scene_resource.c" \
    "$project_dir/src/scene_conditions.c" \
    "$project_dir/src/action_core.c" \
    "$project_dir/src/action_family_64.c" \
    "$project_dir/src/world_clock.c" \
    "$project_dir/src/action_ui.c" \
    "$project_dir/src/scene_executor.c" \
    "$project_dir/src/scene_session.c" \
    "$project_dir/src/action_family_62.c" \
    "$project_dir/src/action_family_62_interaction.c" \
    "$project_dir/src/action_family_51.c" \
    "$project_dir/src/session_bindings_a62.c" \
    "$project_dir/src/session_bindings_a51.c" \
    "$project_dir/tests/session_bindings_sanitizer.c" \
    -o "$build_dir/test_session_bindings_sanitizer"
"$build_dir/test_session_bindings_sanitizer"
