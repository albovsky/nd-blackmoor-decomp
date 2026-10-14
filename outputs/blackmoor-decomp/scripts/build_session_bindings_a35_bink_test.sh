#!/bin/sh
set -eu
base="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
mkdir -p "$base/build"
xcrun clang -arch arm64 -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g \
    -fsanitize=address,undefined -fno-omit-frame-pointer \
    -I"$base/src" -I/opt/homebrew/include \
    "$base/src/session_bindings_a35_bink.c" "$base/tests/session_bindings_a35_bink_test.c" \
    -L/opt/homebrew/lib -lavutil -o "$base/build/session_bindings_a35_bink_test"
