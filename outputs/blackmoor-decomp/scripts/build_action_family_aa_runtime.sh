#!/bin/sh
# RT-52: raw 0xaa Alarm Clock runtime + session binding.
# Optional environment: BUILD_DIR, AA_RUNTIME_OUTPUT, AA_RUNTIME_CFLAGS,
# AA_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${AA_RUNTIME_SRC:-$project_dir/src}"
output="${AA_RUNTIME_OUTPUT:-$build_dir/libactionfamilyaa_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${AA_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_aa_runtime.c" "$source_dir/session_bindings_aaa.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
