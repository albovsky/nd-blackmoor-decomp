#!/bin/sh
# ASan + UBSan run of the RT-5 exit module and 0x28 binding on bounded malformed input.
# SESSION_EXIT_SRC selects a source copy (the mutation checks use it to prove the
# fixture is sensitive).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build/sanitizers}"
source_dir="${SESSION_EXIT_SRC:-$project_dir/src}"
mkdir -p "$build_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=undefined \
    -I"$source_dir" \
    "$source_dir/action_family_28.c" \
    "$source_dir/action_core.c" \
    "$source_dir/caption_lifecycle.c" \
    "$source_dir/session_exit.c" \
    "$source_dir/session_bindings_a28.c" \
    "$project_dir/tests/session_exit_sanitizer.c" \
    -o "$build_dir/test_session_exit_sanitizer"
"$build_dir/test_session_exit_sanitizer"
