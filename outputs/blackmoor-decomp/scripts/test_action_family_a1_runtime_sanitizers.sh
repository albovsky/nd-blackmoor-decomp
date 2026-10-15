#!/bin/sh
# RT-21: ASan/UBSan run of the raw 0xa1 constructor, the shared sound visit and the binding on
# bounded malformed input (exact-size heap inputs).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_97.c" "$project_dir/src/action_family_97_runtime.c" \
    "$project_dir/src/action_family_a1.c" "$project_dir/src/action_family_a1_runtime.c" \
    "$project_dir/src/session_bindings_aa1.c" "$project_dir/src/scene_resource.c" \
    "$project_dir/src/hiff.c" "$project_dir/tests/action_family_a1_runtime_sanitize.c" \
    -o "$build_dir/action_family_a1_runtime_sanitize"
"$build_dir/action_family_a1_runtime_sanitize"
