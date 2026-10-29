#!/bin/sh
# Lift GAME.EXE, compile the lifted code with the native host and the headless harness for Linux (x86-64 or arm64).
#   GAME_EXE=path/to/GAME.EXE ./build_linux.sh [build-dir]       build-dir defaults to ../build/recomp-linux
# Needs: python3 with pefile and capstone, a C compiler, make-less parallel compile through xargs. The lifted C and the binary are build
# outputs (never committed); game data is not needed to build.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
PROJECT=$(cd "$HERE/.." && pwd)
OUT=${1:-$PROJECT/build/recomp-linux}
CC=${CC:-cc}
JOBS=${JOBS:-$(nproc 2>/dev/null || echo 4)}
CFLAGS="-O1 -fPIC -w -I$PROJECT/src -I$HERE -I$OUT"
mkdir -p "$OUT"
if [ ! -f "$OUT/rc_generated.c" ] || [ -n "${RELIFT:-}" ]; then
    python3 -I "$HERE/lift_recomp.py" "$OUT" "${CHUNKS:-24}"
fi
ls "$OUT"/rc_lifted_*.c > "$OUT/lifted.list"
cd "$OUT"
# the lifted files: one compile each, in parallel, skipped when the object is newer than its source and the headers
cat lifted.list | xargs -P "$JOBS" -I{} sh -c 'o=${1%.c}.o; if [ ! -f "$o" ] || [ "$1" -nt "$o" ]; then '"$CC"' '"$CFLAGS"' -c "$1" -o "$o"; fi' _ {}
for f in rc_generated rc_core rc_win32 rc_ddraw rc_dsound rc_bink rc_main rc_unlifted rc_headless; do
    src="$HERE/$f.c"; [ -f "$src" ] || src="$OUT/$f.c"
    $CC -O2 -fPIC -Wall -Wextra -Wno-unused-parameter -I"$PROJECT/src" -I"$HERE" -I"$OUT" -c "$src" -o "$f.o"
done
$CC -o rc_headless rc_lifted_*.o rc_generated.o rc_core.o rc_win32.o rc_ddraw.o rc_dsound.o rc_bink.o rc_main.o rc_unlifted.o rc_headless.o -lm -lpthread
echo "built $OUT/rc_headless"
