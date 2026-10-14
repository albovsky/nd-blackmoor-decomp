#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
evidence_dir="$project_dir/../../work/analysis/slices"
mkdir -p "$evidence_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 -g -O1 \
    -Wall -Wextra -Wpedantic -Werror -fsanitize=address,undefined \
    -fno-omit-frame-pointer -I "$project_dir/src" \
    "$project_dir/src/action_family_35.c" "$project_dir/tests/action_family_35_sanitizer.c" \
    -o "$evidence_dir/A-35.1.sanitizer"
ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 \
    "$evidence_dir/A-35.1.sanitizer"
