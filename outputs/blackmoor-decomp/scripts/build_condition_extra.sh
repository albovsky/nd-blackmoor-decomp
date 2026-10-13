#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    -I "$project_dir/src" \
    "$project_dir/src/condition_extra.c" \
    -o "$project_dir/build/libconditionextra.dylib"
