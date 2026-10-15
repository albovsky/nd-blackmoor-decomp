#!/bin/sh
# RT-16: ASan/UBSan run of the raw 0x0b loader, kernel and binding on bounded malformed input.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_0b_runtime.c" "$project_dir/src/action_family_17_runtime.c" \
    "$project_dir/src/session_bindings_a0b.c" "$project_dir/src/scene_resource.c" \
    "$project_dir/src/hiff.c" "$project_dir/tests/action_family_0b_runtime_sanitize.c" \
    -o "$build_dir/action_family_0b_runtime_sanitize"
"$build_dir/action_family_0b_runtime_sanitize"
# A failing begin_scene is unreachable through the parser: run it against a stub scene resource.
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_0b_runtime.c" "$project_dir/src/action_family_17_runtime.c" \
    "$project_dir/src/session_bindings_a0b.c" \
    "$project_dir/tests/session_bindings_a0b_stub_scene.c" \
    -o "$build_dir/session_bindings_a0b_stub_scene"
"$build_dir/session_bindings_a0b_stub_scene"
