#!/bin/sh
# RT-32: raw 0x43 AUTOTEXT runtime: the session binding (text render + conversion into a runtime-0x36 overlay row) with the
# overlay binding it hands the row to and the text writer (the surfaces, fonts and AUTOTEXT lookup belong to the host).
# Optional environment: BUILD_DIR, A43_OUTPUT, A43_CFLAGS, A43_SRC (mutation checks build a copy).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${A43_SRC:-$project_dir/src}"
output="${A43_OUTPUT:-$build_dir/libactionfamily43runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${A43_CFLAGS:-} \
    "$source_dir/session_bindings_a43.c" "$source_dir/session_bindings_a36.c" "$source_dir/action_family_43.c" \
    "$source_dir/action_family_37.c" "$source_dir/action_family_36.c" "$source_dir/action_family_38.c" \
    "$source_dir/action_family_36_runtime.c" "$source_dir/autotext_writer.c" "$source_dir/caption_layout.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" "$source_dir/action_core.c" -o "$output"
printf '%s\n' "$output"
