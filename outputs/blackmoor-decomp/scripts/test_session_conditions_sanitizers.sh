#!/bin/sh
# ASan + UBSan run of the RT-4 dependency-leaf path on bounded malformed input.
# SESSION_CONDITIONS_SRC / BUILD_DIR let the mutation check aim it at a copy.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="${SESSION_CONDITIONS_SRC:-$project_dir/src}"
build_dir="${BUILD_DIR:-$project_dir/build/sanitizers}"
mkdir -p "$build_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=undefined \
    -I "$source_dir" \
    "$source_dir/scene_conditions.c" \
    "$source_dir/condition_extra.c" \
    "$source_dir/session_bindings_conditions.c" \
    "$project_dir/tests/session_conditions_sanitizer.c" \
    -o "$build_dir/test_session_conditions_sanitizer"
"$build_dir/test_session_conditions_sanitizer"
