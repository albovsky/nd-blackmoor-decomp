#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${BUILD_DIR:-$project_dir/build}"
mkdir -p "$build_dir"
case "${1:-}" in
    --test-driver)
        name=libactionfamily35_runtime_test.dylib
        set -- -fPIC -dynamiclib "$project_dir/tests/action_family_35_runtime_driver.c" ;;
    --sanitize)
        name=action_family_35_runtime_sanitize
        set -- -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer \
            "$project_dir/tests/action_family_35_runtime_driver.c" \
            "$project_dir/tests/action_family_35_runtime_sanitize.c" ;;
    "") name=libactionfamily35_runtime.dylib; set -- -fPIC -dynamiclib ;;
    *) printf 'Usage: %s [--test-driver|--sanitize]\n' "$0" >&2; exit 2 ;;
esac
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 \
    -I"$project_dir/src" "$project_dir/src/action_family_35_runtime.c" \
    "$project_dir/src/action_family_35.c" "$project_dir/src/avf_player.c" \
    "$project_dir/src/avf_decoder.c" "$project_dir/src/session_bindings_a35.c" \
    "$project_dir/src/scene_resource.c" "$project_dir/src/hiff.c" \
    "$@" -o "$build_dir/$name"
printf '%s\n' "$build_dir/$name"
