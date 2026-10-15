#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
private_dir="$project_dir/../../work/analysis/slices"
run_dir="$(mktemp -d "$private_dir/A-68.1.sanitizer-XXXXXXXX")"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all \
    -I "$project_dir/src" "$project_dir/src/action_family_68.c" \
    "$project_dir/tests/action_family_68_sanitizer.c" -o "$run_dir/check"
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
    "$run_dir/check" > "$run_dir/report.json"
cat "$run_dir/report.json"
printf 'report=%s\n' "$run_dir/report.json"
