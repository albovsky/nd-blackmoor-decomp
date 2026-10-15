#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
root_dir="$(cd "$project_dir/../.." && pwd)"
run_dir="$(mktemp -d "$root_dir/work/analysis/slices/A-16.1.sanitizers-XXXXXX")"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g -fno-omit-frame-pointer \
    -fsanitize=address,undefined -I "$project_dir/src" \
    "$project_dir/src/action_family_16.c" "$project_dir/src/action_family_17.c" \
    "$project_dir/tests/action_family_16_sanitizer.c" \
    -o "$run_dir/action_family_16_sanitizer"
ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 \
    "$run_dir/action_family_16_sanitizer" > "$run_dir/result.json"
cat "$run_dir/result.json"
printf '%s\n' "$run_dir"
