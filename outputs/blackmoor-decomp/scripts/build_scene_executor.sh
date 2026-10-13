#!/bin/sh
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
if [ "${1-}" = "--test-hooks" ] && [ "$#" -eq 1 ]; then
    set -- -DSCENE_EXECUTOR_TEST_HOOKS
elif [ "$#" -ne 0 ]; then
    printf 'Usage: %s [--test-hooks]\n' "$0" >&2
    exit 2
fi
mkdir -p "$project_dir/build"
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    "$@" \
    "$project_dir/src/hiff.c" \
    "$project_dir/src/scene_resource.c" \
    "$project_dir/src/scene_conditions.c" \
    "$project_dir/src/action_core.c" \
    "$project_dir/src/scene_executor.c" \
    -o "$project_dir/build/libsceneexecutor.dylib"
printf 'Built %s (native arm64)\n' "$project_dir/build/libsceneexecutor.dylib"
