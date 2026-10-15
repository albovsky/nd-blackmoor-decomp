#!/bin/sh
# Builds the RT-11.1 completed-channel restart test over the live audio
# provider and the RT-4 opcode-17 adapter.
#
#   build_live_audio_restart.sh fixture   build/live_audio_restart_test (default)
#   build_live_audio_restart.sh sanitize  build/sanitize-restart/live_audio_restart_test
#                                         with ASan + UBSan over every source
#
# LIVE_AUDIO_SOURCE / LIVE_AUDIO_ADAPTER_SOURCE override the provider and the
# adapter source (the mutation checks build altered copies);
# LIVE_AUDIO_RESTART_BUILD_DIR overrides the output directory.
set -eu

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${LIVE_AUDIO_RESTART_BUILD_DIR:-$project_dir/build}"
source_file="${LIVE_AUDIO_SOURCE:-$project_dir/src/live_audio.c}"
adapter_file="${LIVE_AUDIO_ADAPTER_SOURCE:-$project_dir/src/session_bindings_conditions_audio.c}"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
macos_min="${MACOSX_DEPLOYMENT_TARGET:-27.0}"
target="${1:-fixture}"
mkdir -p "$build_dir"

c_flags="-arch arm64 -mmacosx-version-min=$macos_min -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -ffp-contract=off"
include_flags="-I$project_dir/src"

build_fixture() {
    "$project_dir/scripts/build_macos_audio.sh" >/dev/null
    "$project_dir/scripts/build_his_audio.sh" >/dev/null
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags -fPIC -dynamiclib \
        "$source_file" "$project_dir/src/sound_control.c" \
        -L"$project_dir/build" -lmacos_audio -lhis_audio \
        -Wl,-rpath,"$project_dir/build" \
        -o "$build_dir/libliveaudio_restart.dylib"
    # Adapter: production flags (-Werror, -Wpedantic) on its own translation unit.
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags -c "$adapter_file" \
        -o "$build_dir/session_bindings_conditions_audio_restart.o"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=gnu17 -Wall -Wextra -Werror -O1 -g $include_flags \
        "$project_dir/tests/live_audio_restart_test.c" \
        "$build_dir/session_bindings_conditions_audio_restart.o" \
        -L"$build_dir" -lliveaudio_restart -L"$project_dir/build" -lmacos_audio -lhis_audio \
        -Wl,-rpath,"$project_dir/build" -Wl,-rpath,"$build_dir" \
        -o "$build_dir/live_audio_restart_test"
    printf 'Built live audio restart test: %s\n' "$build_dir/live_audio_restart_test"
    # Oracle driver: scripted scenarios, same provider build.
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=gnu17 -Wall -Wextra -Werror -O1 -g $include_flags \
        "$project_dir/tests/live_audio_restart_driver.c" \
        -L"$build_dir" -lliveaudio_restart -L"$project_dir/build" -lmacos_audio -lhis_audio \
        -Wl,-rpath,"$project_dir/build" -Wl,-rpath,"$build_dir" \
        -o "$build_dir/live_audio_restart_driver"
    printf 'Built live audio restart driver: %s\n' "$build_dir/live_audio_restart_driver"
}

build_sanitized() {
    sanitize_dir="$build_dir/sanitize-restart"
    mkdir -p "$sanitize_dir"
    san="-fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer -g -O1"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags $san -I"$ffmpeg_prefix/include" -c \
        "$source_file" -o "$sanitize_dir/live_audio.o"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags $san -c \
        "$project_dir/src/sound_control.c" -o "$sanitize_dir/sound_control.o"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags $san -c \
        "$adapter_file" -o "$sanitize_dir/adapter.o"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang $c_flags $include_flags $san -I"$ffmpeg_prefix/include" -c \
        "$project_dir/src/his_audio.c" -o "$sanitize_dir/his_audio.o"
    xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=c++17 -fobjc-arc -fblocks -Wall -Wextra -Wpedantic -Werror $san -c \
        "$project_dir/src/macos_audio.mm" -o "$sanitize_dir/macos_audio.o"
    # shellcheck disable=SC2086
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min="$macos_min" \
        -std=gnu17 -Wall -Wextra -Werror $include_flags $san -c \
        "$project_dir/tests/live_audio_restart_test.c" -o "$sanitize_dir/test.o"
    xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min="$macos_min" \
        $san "$sanitize_dir"/*.o \
        -framework AVFAudio -framework Foundation \
        -L"$ffmpeg_prefix/lib" -lavformat -lavcodec -lavutil -lswresample \
        -Wl,-rpath,"$ffmpeg_prefix/lib" \
        -o "$sanitize_dir/live_audio_restart_test"
    printf 'Built sanitized restart test: %s\n' "$sanitize_dir/live_audio_restart_test"
}

case "$target" in
    fixture) build_fixture ;;
    sanitize) build_sanitized ;;
    *) printf 'usage: %s [fixture|sanitize]\n' "$0" >&2; exit 2 ;;
esac
