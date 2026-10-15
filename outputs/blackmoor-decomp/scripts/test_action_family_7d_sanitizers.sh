#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
run_dir="$(mktemp -d "${A7D_SCRATCH:-/private/tmp}/A-7D.1.sanitizer-XXXXXXXX")"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all \
    -I "$project_dir/src" "$project_dir/src/action_family_7d.c" \
    "$project_dir/tests/action_family_7d_sanitizer.c" -o "$run_dir/check"
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
    "$run_dir/check" > "$run_dir/report.json"
cat "$run_dir/report.json"
printf 'report=%s\n' "$run_dir/report.json"
