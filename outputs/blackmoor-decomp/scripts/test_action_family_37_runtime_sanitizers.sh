#!/bin/sh
# RT-18: ASan/UBSan run of the raw 0x37 image builder and the shared COverlay binding on bounded
# malformed input.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_36.c" "$project_dir/src/action_family_37.c" "$project_dir/src/action_family_38.c" \
    "$project_dir/src/action_family_36_runtime.c" "$project_dir/src/session_bindings_a36.c" \
    "$project_dir/src/scene_resource.c" "$project_dir/src/hiff.c" \
    "$project_dir/tests/action_family_37_runtime_sanitize.c" \
    -o "$build_dir/action_family_37_runtime_sanitize"
"$build_dir/action_family_37_runtime_sanitize"
