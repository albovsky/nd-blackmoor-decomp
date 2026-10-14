#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build/sanitizers}"
mkdir -p "$build_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fno-omit-frame-pointer -fsanitize=address,undefined \
    "$project_dir/src/action_family_37.c" \
    "$project_dir/tests/action_family_37_sanitizer.c" \
    -o "$build_dir/test_action_family_37_sanitizer"
"$build_dir/test_action_family_37_sanitizer"
