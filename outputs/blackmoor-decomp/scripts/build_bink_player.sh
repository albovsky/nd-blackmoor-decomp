#!/bin/sh
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$project_dir/build"
output="$output_dir/libbink_player.dylib"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
macos_min="${MACOSX_DEPLOYMENT_TARGET:-27.0}"
test_define=
if [ "${BINK_PLAYER_TESTING:-0}" = "1" ]; then
    test_define=-DBINK_PLAYER_TESTING=1
fi
mkdir -p "$output_dir"

xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
    -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -fPIC -dynamiclib \
    $test_define \
    -I"$project_dir/src" -I"$ffmpeg_prefix/include" \
    "$project_dir/src/bink_player.c" \
    "$project_dir/src/bink_adapter.c" \
    -L"$ffmpeg_prefix/lib" \
    -lavformat -lavcodec -lavutil -lswscale \
    -Wl,-rpath,"$ffmpeg_prefix/lib" \
    -o "$output"
printf 'Built native timed Bink player: %s\n' "$output"
