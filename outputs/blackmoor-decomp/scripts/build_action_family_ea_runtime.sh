#!/bin/sh
# RT-45: raw 0xea Onebuild puzzle runtime + session binding.
# Optional environment: BUILD_DIR, EA_RUNTIME_OUTPUT, EA_RUNTIME_CFLAGS,
# EA_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${EA_RUNTIME_SRC:-$project_dir/src}"
output="${EA_RUNTIME_OUTPUT:-$build_dir/libactionfamilyea_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${EA_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_ea_runtime.c" "$source_dir/session_bindings_aea.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
