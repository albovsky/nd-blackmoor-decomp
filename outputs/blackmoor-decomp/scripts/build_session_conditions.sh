#!/bin/sh
# Builds the RT-4 session-conditions library: the scene condition tree, the
# reviewed leaf kernel (condition_extra) and the app-side binding. Optional
# environment:
#   SESSION_CONDITIONS_OUTPUT  output dylib (default build/libsessionconditions.dylib)
#   SESSION_CONDITIONS_CFLAGS  extra compiler flags (sanitizers)
#   SESSION_CONDITIONS_SRC     source directory (mutation checks build a copy)
#
#   build_session_conditions.sh           libsessionconditions.dylib (default)
#   build_session_conditions.sh fixture   library + build/session_conditions_audio_fixture
#                                         (opcode 17 against the real offline audio host)
set -eu
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output="${SESSION_CONDITIONS_OUTPUT:-$project_dir/build/libsessionconditions.dylib}"
source_dir="${SESSION_CONDITIONS_SRC:-$project_dir/src}"
mkdir -p "$(dirname "$output")"
# shellcheck disable=SC2086
xcrun --sdk macosx clang -arch arm64 -std=c11 \
    -Wall -Wextra -Wpedantic -Werror -O1 -g -fPIC -dynamiclib \
    ${SESSION_CONDITIONS_CFLAGS:-} \
    -I "$source_dir" \
    "$source_dir/scene_conditions.c" \
    "$source_dir/condition_extra.c" \
    "$source_dir/session_bindings_conditions.c" \
    -o "$output"
printf 'Built %s (native arm64)\n' "$output"
if [ "${1-}" = "fixture" ]; then
    macos_min="${MACOSX_DEPLOYMENT_TARGET:-27.0}"
    ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
    "$project_dir/scripts/build_live_audio.sh" lib >/dev/null
    # The fixture is test code: -Wpedantic is dropped for the CHECK macro.
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=gnu17 -Wall -Wextra -Werror -O1 -g -I "$source_dir" \
        "$project_dir/tests/session_conditions_audio_fixture.c" \
        "$source_dir/scene_conditions.c" "$source_dir/condition_extra.c" \
        "$source_dir/session_bindings_conditions.c" \
        "$source_dir/session_bindings_conditions_audio.c" \
        -L"$project_dir/build" -lliveaudio -lmacos_audio -lhis_audio \
        -Wl,-rpath,"$project_dir/build" -Wl,-rpath,"$ffmpeg_prefix/lib" \
        -o "$project_dir/build/session_conditions_audio_fixture"
    printf 'Built %s\n' "$project_dir/build/session_conditions_audio_fixture"
fi
