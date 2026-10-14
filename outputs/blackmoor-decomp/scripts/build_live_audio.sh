#!/bin/sh
# Builds the RT-1 live audio channel provider and its fixture executables.
#
#   build_live_audio.sh            library + fixture (default)
#   build_live_audio.sh lib        libliveaudio.dylib only
#   build_live_audio.sh fixture    library + build/live_audio_fixture
#   build_live_audio.sh sanitize   build/sanitize/live_audio_fixture compiled
#                                  with ASan + UBSan over every adapter source
#
# LIVE_AUDIO_SOURCE overrides the provider source (the mutation check builds
# altered copies); LIVE_AUDIO_BUILD_DIR overrides the output directory.
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${LIVE_AUDIO_BUILD_DIR:-$project_dir/build}"
source_file="${LIVE_AUDIO_SOURCE:-$project_dir/src/live_audio.c}"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
macos_min="${MACOSX_DEPLOYMENT_TARGET:-27.0}"
target="${1:-fixture}"
mkdir -p "$build_dir"

# Same warning policy as the other module scripts.
c_flags="-arch arm64 -mmacosx-version-min=$macos_min -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -ffp-contract=off"
include_flags="-I$project_dir/src"

build_library() {
    # The provider links the reviewed host pieces; build them in the default
    # build directory first (they are read-only, unmodified inputs).
    "$project_dir/scripts/build_macos_audio.sh" >/dev/null
    "$project_dir/scripts/build_his_audio.sh" >/dev/null
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags -fPIC -dynamiclib \
        "$source_file" "$project_dir/src/sound_control.c" \
        -L"$project_dir/build" -lmacos_audio -lhis_audio \
        -Wl,-rpath,"$project_dir/build" \
        -o "$build_dir/libliveaudio.dylib"
    printf 'Built native live audio channel provider: %s\n' "$build_dir/libliveaudio.dylib"
}

build_fixture() {
    build_dir_rpath=""
    if [ "$build_dir" != "$project_dir/build" ]; then build_dir_rpath="-Wl,-rpath,$build_dir"; fi
    # The fixture is test code: -Wpedantic is dropped because its CHECK macro
    # takes an optional printf tail; every other warning is still an error.
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=gnu17 -Wall -Wextra -Werror -O1 -g $include_flags \
        "$project_dir/tests/live_audio_fixture.c" \
        -L"$build_dir" -lliveaudio -L"$project_dir/build" -lmacos_audio -lhis_audio \
        -Wl,-rpath,"$project_dir/build" ${build_dir_rpath} \
        -o "$build_dir/live_audio_fixture"
    printf 'Built live audio fixture: %s\n' "$build_dir/live_audio_fixture"
}

build_sanitized() {
    sanitize_dir="$build_dir/sanitize"
    mkdir -p "$sanitize_dir"
    san="-fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer -g -O1"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags $san -I"$ffmpeg_prefix/include" -c \
        "$source_file" -o "$sanitize_dir/live_audio.o"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags $san -c \
        "$project_dir/src/sound_control.c" -o "$sanitize_dir/sound_control.o"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags $san -I"$ffmpeg_prefix/include" -c \
        "$project_dir/src/his_audio.c" -o "$sanitize_dir/his_audio.o"
    xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=c++17 -fobjc-arc -fblocks -Wall -Wextra -Wpedantic -Werror $san -c \
        "$project_dir/src/macos_audio.mm" -o "$sanitize_dir/macos_audio.o"
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=gnu17 -Wall -Wextra -Werror $include_flags $san -c \
        "$project_dir/tests/live_audio_fixture.c" -o "$sanitize_dir/fixture.o"
    xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min="$macos_min" \
        $san "$sanitize_dir"/*.o \
        -framework AVFAudio -framework Foundation \
        -L"$ffmpeg_prefix/lib" -lavformat -lavcodec -lavutil -lswresample \
        -Wl,-rpath,"$ffmpeg_prefix/lib" \
        -o "$sanitize_dir/live_audio_fixture"
    printf 'Built sanitized live audio fixture: %s\n' "$sanitize_dir/live_audio_fixture"
}

case "$target" in
    lib) build_library ;;
    fixture) build_library; build_fixture ;;
    sanitize) build_sanitized ;;
    *) printf 'usage: %s [lib|fixture|sanitize]\n' "$0" >&2; exit 2 ;;
esac
