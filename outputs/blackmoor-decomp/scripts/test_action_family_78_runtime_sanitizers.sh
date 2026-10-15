#!/bin/sh
# RT-19: ASan/UBSan run of the raw 0x78 kernel and binding on bounded malformed input.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_79_runtime.c" "$project_dir/src/action_family_78_runtime.c" \
    "$project_dir/src/session_bindings_a78.c" "$project_dir/src/scene_resource.c" \
    "$project_dir/src/hiff.c" "$project_dir/tests/action_family_78_runtime_sanitize.c" \
    -o "$build_dir/action_family_78_runtime_sanitize"
"$build_dir/action_family_78_runtime_sanitize"
# session_a78_begin_scene's malformed-row rejection, unreachable through a real
# SceneResource (the parser refuses such rows first), against a scene double.
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_79_runtime.c" "$project_dir/src/action_family_78_runtime.c" \
    "$project_dir/src/session_bindings_a78.c" \
    "$project_dir/tests/action_family_79_binding_stub_scene.c" \
    "$project_dir/tests/action_family_78_binding_stub_sanitize.c" \
    -o "$build_dir/action_family_78_binding_stub_sanitize"
"$build_dir/action_family_78_binding_stub_sanitize"
