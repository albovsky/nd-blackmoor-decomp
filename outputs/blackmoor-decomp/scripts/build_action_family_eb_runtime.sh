#!/bin/sh
# RT-56: raw 0xeb Multibuild puzzle runtime + session binding.
# Optional environment: BUILD_DIR, EB_RUNTIME_OUTPUT, EB_RUNTIME_CFLAGS,
# EB_RUNTIME_SRC (mutation checks build a copy of the sources).
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
source_dir="${EB_RUNTIME_SRC:-$project_dir/src}"
output="${EB_RUNTIME_OUTPUT:-$build_dir/libactionfamilyeb_runtime.dylib}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -g -fPIC -dynamiclib \
    ${EB_RUNTIME_CFLAGS:-} \
    "$source_dir/action_family_eb_runtime.c" "$source_dir/session_bindings_aeb.c" \
    "$source_dir/scene_resource.c" "$source_dir/hiff.c" -o "$output"
printf '%s\n' "$output"
