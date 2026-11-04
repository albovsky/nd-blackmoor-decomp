#!/bin/bash
# Build the private, self-contained ARM64 macOS package ("Blackmoor Recompiled" app inside a DMG).
#
#   GAME_EXE=/path/to/GAME.EXE script/package_macos.sh
#
# What it does, in order:
#   1. validates GAME_EXE against the owner's pinned SHA-256 before anything is built;
#   2. picks a working Xcode (DEVELOPER_DIR) and the project's pinned Python;
#   3. builds (or reuses) the minimal LGPL FFmpeg with script/build_ffmpeg_macos.sh;
#   4. runs recomp/build_macos.sh with MIN_MACOS, FFMPEG_PREFIX and BLACKMOOR_BUNDLE_PATH into a fresh
#      run directory under work/package/;
#   5. script/macos_bundle.py copies the non-system dependencies into the app, rewrites load paths,
#      rejects forbidden content, signs inside-out (hardened runtime, no entitlements), optionally
#      notarizes and staples, builds the DMG (app, Applications link, README.txt), then mounts the
#      DMG read-only and verifies the app inside it again.
#
# Signing: BLACKMOOR_SIGN_IDENTITY selects a Developer ID identity from the keychain and
# BLACKMOOR_NOTARY_PROFILE a notarytool keychain profile. Without an identity the result is an
# ad-hoc DMG whose file name and README say so; that is never reported as a trust success.
# Nothing is uploaded anywhere, and neither value is ever printed.
#
# Environment (all optional except GAME_EXE when the default path is absent):
#   GAME_EXE                  owned original executable (default <workspace>/work/original/GAME.EXE)
#   BLACKMOOR_GAME_DIR        folder whose files must not appear in the bundle (default: GAME_EXE's folder)
#   MIN_MACOS                 deployment floor (default 11.0)
#   FFMPEG_PREFIX             an existing build made by build_ffmpeg_macos.sh (default: build/reuse it)
#   BLACKMOOR_PACKAGE_OUT     parent of the fresh run directory (default <workspace>/work/package)
#   BLACKMOOR_PYTHON          Python to use (default <workspace>/work/tools/recomp-python/bin/python3)
#   BLACKMOOR_HARDENED_RUNTIME  auto|always|never (default auto: on for Developer ID, off for ad-hoc)
#   DEVELOPER_DIR, BUILD_DIR, CHUNKS, RELIFT, JOBS   passed through to the builds unchanged
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace="$(cd "$here/.." && pwd)"
expected_game_sha256="afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"

fail() {
    printf 'package_macos.sh: %s\n' "$1" >&2
    exit "${2:-1}"
}

# --- 1. the original must be the pinned one before any build starts
game_exe="${GAME_EXE:-$workspace/work/original/GAME.EXE}"
if [[ ! -f "$game_exe" ]]; then
    fail "GAME_EXE not found: $game_exe" 2
fi
game_sum="$(shasum -a 256 "$game_exe")"
game_sha256="${game_sum%% *}"
if [[ "$game_sha256" != "$expected_game_sha256" ]]; then
    fail "GAME_EXE hash $game_sha256 is not the owned original ($expected_game_sha256); refusing to build" 2
fi
game_dir="${BLACKMOOR_GAME_DIR:-$(dirname "$game_exe")}"

min_os="${MIN_MACOS:-11.0}"
hardened="${BLACKMOOR_HARDENED_RUNTIME:-auto}"
python_bin="${BLACKMOOR_PYTHON:-$workspace/work/tools/recomp-python/bin/python3}"
out_root="${BLACKMOOR_PACKAGE_OUT:-$workspace/work/package}"

if [[ ! -x "$python_bin" ]]; then
    fail "pinned Python not found: $python_bin (run script/setup_recomp_python.sh, or set BLACKMOOR_PYTHON)" 2
fi

# --- 2. a working Xcode: keep the active one when it can compile, otherwise pick an installed Xcode*.app
sdk_ok=0
if xcrun --sdk macosx --show-sdk-path >/dev/null 2>&1; then
    sdk_ok=1
fi
if [[ "$sdk_ok" -eq 0 ]]; then
    for candidate in /Applications/Xcode*.app/Contents/Developer; do
        if [[ -d "$candidate" ]]; then
            if DEVELOPER_DIR="$candidate" xcrun --sdk macosx --show-sdk-path >/dev/null 2>&1; then
                export DEVELOPER_DIR="$candidate"
                sdk_ok=1
                break
            fi
        fi
    done
fi
if [[ "$sdk_ok" -eq 0 ]]; then
    fail "no working Xcode found; install Xcode or set DEVELOPER_DIR" 2
fi

# --- 3. the shippable FFmpeg
export MIN_MACOS="$min_os"
if [[ -z "${FFMPEG_PREFIX:-}" ]]; then
    FFMPEG_PREFIX="$("$here/build_ffmpeg_macos.sh" --print-prefix)"
    "$here/build_ffmpeg_macos.sh"
fi
export FFMPEG_PREFIX
"$python_bin" -I "$here/macos_bundle.py" ffmpeg-check --prefix "$FFMPEG_PREFIX" --min-macos "$min_os"

# --- 4. a fresh run directory and the app build
mkdir -p "$out_root"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
run_dir="$out_root/package-$stamp-$$"
mkdir "$run_dir"
mkdir "$run_dir/build"
mkdir "$run_dir/package"

export GAME_EXE="$game_exe"
export BLACKMOOR_BUNDLE_PATH="$run_dir/build/Blackmoor Recompiled.app"
"$workspace/outputs/blackmoor-decomp/recomp/build_macos.sh"

# --- 5. bundle, sign, notarize, DMG, verify
"$python_bin" -I "$here/macos_bundle.py" package \
    --app "$BLACKMOOR_BUNDLE_PATH" \
    --out-dir "$run_dir/package" \
    --ffmpeg-prefix "$FFMPEG_PREFIX" \
    --min-macos "$min_os" \
    --game-dir "$game_dir" \
    --hardened-runtime "$hardened"
printf 'Run directory: %s\n' "$run_dir"
