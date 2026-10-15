#!/bin/sh
# RT-13: ASan/UBSan run of the raw 0x79 kernel and binding on bounded malformed input.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_79.c" "$project_dir/src/action_family_79_runtime.c" \
    "$project_dir/src/session_bindings_a79.c" "$project_dir/src/scene_resource.c" \
    "$project_dir/src/hiff.c" "$project_dir/tests/action_family_79_runtime_sanitize.c" \
    -o "$build_dir/action_family_79_runtime_sanitize"
"$build_dir/action_family_79_runtime_sanitize"
