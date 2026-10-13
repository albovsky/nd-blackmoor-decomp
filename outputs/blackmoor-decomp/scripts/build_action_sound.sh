#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"

xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$project_dir/src/action_sound.c" \
    -o "$project_dir/build/libactionsound.dylib"

printf 'Built %s (native arm64)\n' "$project_dir/build/libactionsound.dylib"
