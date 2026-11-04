#!/bin/bash
# Build "Blackmoor Recompiled.app": the recompiled GAME.EXE on the native ARM64 host, with the app's window, FFmpeg movie decoding and sound.
#   GAME_EXE=/path/to/GAME.EXE recomp/build_macos.sh
# Needs a Mac with Xcode command line tools, FFmpeg (Homebrew, FFMPEG_PREFIX), python3 with pefile and capstone, and the owner's GAME.EXE.
# The lifted C is generated from GAME.EXE here (it contains the game's code translated to C) and is never committed.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")"
pwd)"
project="$(cd "$here/.."
pwd)"
src="$project/src"
build="${BUILD_DIR:-$project/build/recomp-macos}"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
min_os="${MIN_MACOS:-11.0}"
jobs="${JOBS:-$(sysctl -n hw.ncpu)}"
mkdir -p "$build"
if ! xcrun --sdk macosx --show-sdk-path >/dev/null 2>&1; then
    if [[ -z "${DEVELOPER_DIR:-}" ]]; then
        if [[ -d /Applications/Xcode.app/Contents/Developer ]]; then
            export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
        fi
    fi
fi
export GAME_EXE="${GAME_EXE:-$project/../../work/original/GAME.EXE}"
# Validate the full generator-input fingerprint and expected output set before reuse.
python3 -I "$here/generation_cache.py" "$build" "${CHUNKS:-24}" "${RELIFT:-}"
cc=(xcrun --sdk macosx clang -arch arm64 "-mmacosx-version-min=$min_os" -Werror=unguarded-availability -Werror=unguarded-availability-new)
# the lifted functions: one compile each, in parallel, skipped when the object is newer than its source and than every header it includes
python3 -I - "$build" "$src" "$here" "$jobs" "${cc[@]}" <<'PYTHON'
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import json
import subprocess
import sys

build, src, here = map(Path, sys.argv[1:4])
jobs = int(sys.argv[4])
command = sys.argv[5:] + ['-O1', '-w', '-I'+str(src), '-I'+str(here), '-I'+str(build)]
headers = [src/'original_methods_fl41.h', src/'original_methods_fl41_x87.h',
           here/'rc_lift_prelude.h', here/'rc_fl57_helpers.h', here/'rc.h']
newest = max(p.stat().st_mtime_ns for p in headers)
sdk = subprocess.check_output(['xcrun', '--sdk', 'macosx', '--show-sdk-path'], text=True).strip()
compiler = subprocess.check_output(['xcrun', 'clang', '--version'], text=True)
fingerprint = json.dumps([command, sdk, compiler])
stamp = build/'lifted-compile-target.json'
force = not stamp.exists() or stamp.read_text() != fingerprint
def compile_one(source):
    obj = source.with_suffix('.o')
    if force or not obj.exists() or obj.stat().st_mtime_ns < max(newest, source.stat().st_mtime_ns):
        subprocess.run(command + ['-c', str(source), '-o', str(obj)], check=True)
with ThreadPoolExecutor(max_workers=jobs) as pool:
    list(pool.map(compile_one, sorted(build.glob('rc_lifted_*.c'))))
stamp.write_text(fingerprint)
PYTHON
objects=("$build"/rc_lifted_*.o)
for f in rc_generated rc_core rc_threads rc_win32 rc_ddraw rc_dsound rc_bink rc_main rc_unlifted rc_input_script; do
    s="$here/$f.c"
    if [[ ! -f "$s" ]]; then
        s="$build/$f.c"
    fi
    "${cc[@]}" -std=gnu11 -O2 -Wall -Wextra -Wno-unused-parameter -I"$src" -I"$here" -I"$build" -c "$s" -o "$build/$f.o"
    objects+=("$build/$f.o")
done
for f in bink_adapter bink_player bink_audio native_display_geometry; do
    "${cc[@]}" -std=c11 -O2 -Wall -Wextra -I"$ffmpeg_prefix/include" -c "$src/$f.c" -o "$build/$f.o"
    objects+=("$build/$f.o")
done
bundle="${BLACKMOOR_BUNDLE_PATH:-$project/Blackmoor Recompiled.app}"
if [[ "$bundle" != *.app ]]; then
    printf 'Bundle target must end in .app: %s\n' "$bundle" >&2
    exit 1
fi
stage="$(mktemp -d /private/tmp/blackmoor-recomp-build.XXXXXX)"
mkdir -p "$stage/Blackmoor Recompiled.app/Contents/MacOS"
xcrun --sdk macosx clang++ -arch arm64 "-mmacosx-version-min=$min_os" -std=c++17 -fobjc-arc -Wall -Wextra -O2 \
    -Werror=unguarded-availability -Werror=unguarded-availability-new \
    -I"$src" -I"$here" \
    "$here/macos_recomp.mm" "$here/macos_game_data.mm" "$here/audio_capture.cpp" "$src/macos_platform.mm" "${objects[@]}" \
    -framework AppKit -framework Foundation -framework CoreGraphics -framework AVFAudio -framework Carbon \
    -L"$ffmpeg_prefix/lib" -lavformat -lavcodec -lavutil -lswscale -lswresample \
    -Wl,-headerpad_max_install_names -Wl,-rpath,@executable_path/../Frameworks -Wl,-rpath,"$ffmpeg_prefix/lib" \
    -o "$stage/Blackmoor Recompiled.app/Contents/MacOS/BlackmoorRecompiled"
cat > "$stage/Blackmoor Recompiled.app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>BlackmoorRecompiled</string>
<key>CFBundleIdentifier</key><string>com.blackmoor.recompiled</string>
<key>CFBundleName</key><string>Blackmoor Recompiled</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleVersion</key><string>0.1</string>
<key>LSMinimumSystemVersion</key><string>11.0</string>
<key>NSPrincipalClass</key><string>NSApplication</string>
</dict></plist>
PLIST
/usr/libexec/PlistBuddy -c "Set :LSMinimumSystemVersion $min_os" "$stage/Blackmoor Recompiled.app/Contents/Info.plist"
source_commit="$(git -C "$here" rev-parse HEAD)"
/usr/libexec/PlistBuddy -c "Add :BlackmoorSourceCommit string $source_commit" "$stage/Blackmoor Recompiled.app/Contents/Info.plist"
/usr/bin/codesign --force --sign - "$stage/Blackmoor Recompiled.app"
/usr/bin/codesign --verify --strict "$stage/Blackmoor Recompiled.app"
if [ -L "$bundle" ]; then
    printf 'Refusing to replace a symlink at %s\n' "$bundle" >&2
    exit 1
fi
/usr/bin/ditto --noextattr --norsrc "$stage/Blackmoor Recompiled.app" "$bundle"
printf 'Built %s\n' "$bundle"
