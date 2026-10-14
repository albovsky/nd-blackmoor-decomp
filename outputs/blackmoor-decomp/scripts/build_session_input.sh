#!/bin/bash
set -euo pipefail
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun clang -std=c11 -O2 -Wall -Wextra -Wpedantic -Werror \
    -fno-stack-protector -dynamiclib \
    "$project_dir/src/session_input.c" \
    "$project_dir/src/input_latch.c" "$project_dir/src/input_consume.c" \
    -o "$project_dir/build/libsession_input.dylib"
