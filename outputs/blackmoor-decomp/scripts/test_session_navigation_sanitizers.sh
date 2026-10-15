#!/bin/sh
# RT-17: ASan/UBSan run of session_navigation (with session_input) on bounded malformed input.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer \
    -I "$project_dir/src" \
    "$project_dir/src/session_navigation.c" "$project_dir/src/session_input.c" \
    "$project_dir/src/input_latch.c" "$project_dir/src/input_consume.c" \
    "$project_dir/tests/session_navigation_sanitize.c" -o "$build_dir/session_navigation_sanitize"
"$build_dir/session_navigation_sanitize"
