#!/bin/sh
set -eu

PROJECT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_DIR="$PROJECT_DIR/build"
CC=${CC:-clang}

mkdir -p "$BUILD_DIR"
"$CC" -std=c11 -Wall -Wextra -Werror -pedantic -fPIC -dynamiclib \
    "$PROJECT_DIR/src/action_family_62_interaction.c" \
    -o "$BUILD_DIR/libactionfamily62interaction.dylib"
