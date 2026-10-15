#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
xcrun --sdk macosx clang -arch arm64 -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined \
    -Wall -Wextra -Wpedantic -Werror \
    "$project_dir/tests/inventory_button_runtime_sanitize.c" "$project_dir/src/inventory_button_runtime.c" \
    -o "$build_dir/inventory_button_runtime_sanitize"
"$build_dir/inventory_button_runtime_sanitize"
