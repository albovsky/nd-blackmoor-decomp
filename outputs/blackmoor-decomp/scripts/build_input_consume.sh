#!/bin/bash
set -euo pipefail
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun clang -std=c11 -O2 -Wall -Wextra -Werror -fno-stack-protector \
    -dynamiclib "$project_dir/src/input_consume.c" \
    -o "$project_dir/build/libinput_consume.dylib"
