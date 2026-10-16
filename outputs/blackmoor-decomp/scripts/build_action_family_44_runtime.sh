#!/bin/sh
# RT-34: raw 0x44 scroll list entry runtime: the 0xd8 peephole view kernel, the 0x411b16 record builder, the session binding
# and the A-44.1 decoder / scene reader it uses.
# Optional environment: BUILD_DIR, A44_OUTPUT, A44_CFLAGS, A44_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A44_SRC:-$project_dir/src}"
output="${A44_OUTPUT:-$build_dir/libactionfamily44runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A44_CFLAGS:-} \
    "$source_dir/action_family_d8_runtime.c" "$source_dir/action_family_44_runtime.c" \
    "$source_dir/session_bindings_a44.c" "$source_dir/action_family_44.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
