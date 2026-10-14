#!/bin/sh
set -euC
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
private_dir="$project_dir/../../work/analysis/slices"
build_dir="$(mktemp -d "$private_dir/A-94.1.sanitizer-XXXXXXXX")"
result="${1:-$build_dir/result.json}"
if [ -e "$result" ]; then
    printf '%s\n' 'result path must be unique' >&2
    exit 1
fi
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer \
    -I "$project_dir/src" "$project_dir/src/action_family_94.c" \
    "$project_dir/tests/action_family_94_sanitizer.c" -o "$build_dir/sanitizer"
ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 \
    "$build_dir/sanitizer" > "$result"
cat "$result"
printf 'sanitizer binary: %s\n' "$build_dir/sanitizer"
