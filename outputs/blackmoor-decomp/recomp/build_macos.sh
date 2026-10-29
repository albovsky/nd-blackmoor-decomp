#!/bin/bash
# Build "Blackmoor Recompiled.app": the recompiled GAME.EXE on the native ARM64 host, with the app's window, FFmpeg movie decoding and sound.
#   GAME_EXE=/path/to/GAME.EXE recomp/build_macos.sh
# Needs a Mac with Xcode command line tools, FFmpeg (Homebrew, FFMPEG_PREFIX), python3 with pefile and capstone, and the owner's GAME.EXE.
# The lifted C is generated from GAME.EXE here (it contains the game's code translated to C) and is never committed.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project="$(cd "$here/.." && pwd)"
src="$project/src"
build="${BUILD_DIR:-$project/build/recomp-macos}"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
min_os="${MIN_MACOS:-27.0}"
jobs="${JOBS:-$(sysctl -n hw.ncpu)}"
mkdir -p "$build"
export GAME_EXE="${GAME_EXE:-$project/../../work/original/GAME.EXE}"
if [ ! -f "$build/rc_generated.c" ] || [ -n "${RELIFT:-}" ]; then
    python3 -I "$here/lift_recomp.py" "$build" "${CHUNKS:-24}"
fi
cc=(xcrun --sdk macosx clang -arch arm64 "-mmacosx-version-min=$min_os")
# the lifted functions: one compile each, in parallel, skipped when the object is newer than its source and than every header it includes
newest_header="$(ls -t "$src/original_methods_fl41.h" "$src/original_methods_fl41_x87.h" "$here/rc_lift_prelude.h" "$here/rc_fl57_helpers.h" "$here/rc.h" | head -1)"
export newest_header
ls "$build"/rc_lifted_*.c | xargs -P "$jobs" -I{} bash -c 'o="${1%.c}.o"; if [ ! -f "$o" ] || [ "$1" -nt "$o" ] || [ "$newest_header" -nt "$o" ]; then "${@:2}" -c "$1" -o "$o"; fi' _ {} \
    "${cc[@]}" -O1 -w -I"$src" -I"$here" -I"$build"
objects=("$build"/rc_lifted_*.o)
for f in rc_generated rc_core rc_win32 rc_ddraw rc_dsound rc_bink rc_main rc_unlifted; do
    s="$here/$f.c"; [ -f "$s" ] || s="$build/$f.c"
    "${cc[@]}" -std=gnu11 -O2 -Wall -Wextra -Wno-unused-parameter -I"$src" -I"$here" -I"$build" -c "$s" -o "$build/$f.o"
    objects+=("$build/$f.o")
done
for f in bink_adapter bink_player bink_audio native_display_geometry; do
    "${cc[@]}" -std=c11 -O2 -Wall -Wextra -I"$ffmpeg_prefix/include" -c "$src/$f.c" -o "$build/$f.o"
    objects+=("$build/$f.o")
done
bundle="$project/Blackmoor Recompiled.app"
stage="$(mktemp -d /private/tmp/blackmoor-recomp-build.XXXXXX)"
mkdir -p "$stage/Blackmoor Recompiled.app/Contents/MacOS"
xcrun --sdk macosx clang++ -arch arm64 "-mmacosx-version-min=$min_os" -std=c++17 -fobjc-arc -Wall -Wextra -O2 \
    -I"$src" -I"$here" \
    "$here/macos_recomp.mm" "$src/macos_platform.mm" "${objects[@]}" \
    -framework AppKit -framework Foundation -framework CoreGraphics -framework AVFAudio -framework Carbon \
    -L"$ffmpeg_prefix/lib" -lavformat -lavcodec -lavutil -lswscale -lswresample -Wl,-rpath,"$ffmpeg_prefix/lib" \
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
<key>LSMinimumSystemVersion</key><string>27.0</string>
<key>NSPrincipalClass</key><string>NSApplication</string>
</dict></plist>
PLIST
/usr/bin/codesign --force --sign - "$stage/Blackmoor Recompiled.app"
/usr/bin/codesign --verify --strict "$stage/Blackmoor Recompiled.app"
if [ -L "$bundle" ]; then printf 'Refusing to replace a symlink at %s\n' "$bundle" >&2; exit 1; fi
/usr/bin/ditto --noextattr --norsrc "$stage/Blackmoor Recompiled.app" "$bundle"
printf 'Built %s\n' "$bundle"
