#!/bin/sh
# Builds the AUTOTEXT writer (and the caption primitives it shares) as one
# shared library: libautotextwriter.dylib (arm64 macOS) or .so (elsewhere).
# SANITIZE=1 adds -fsanitize=address,undefined (no -O2); BUILD_DIR and
# OUTPUT override the locations; CC picks the compiler.
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
sources="$project_dir/src/autotext_writer.c $project_dir/src/caption_layout.c"
flags="-std=c11 -Wall -Wextra -Wpedantic -Werror -fPIC"
if [ "${SANITIZE:-0}" = "1" ]; then
    flags="$flags -O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=undefined"
else
    flags="$flags -O2"
fi
if [ "$(uname -s)" = "Darwin" ]; then
    out="${OUTPUT:-$build_dir/libautotextwriter.dylib}"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang -arch arm64 $flags -dynamiclib $sources -o "$out"
else
    out="${OUTPUT:-$build_dir/libautotextwriter.so}"
    # shellcheck disable=SC2086
    "${CC:-cc}" $flags -shared $sources -o "$out"
fi
printf '%s\n' "$out"
