#!/bin/bash
# Builds the linker and the binary tools (ld, objcopy, objdump, ...) of the pinned binutils 2.43.1 into the prefix
# that bootstrap_matching_s08_2_gas.sh created for the assembler, from the same verified source archive
# (work/tools/s08-binutils-2.43.1/binutils-2.43.1.tar.xz).  The single GAME.EXE build (build_game_exe.sh) links
# with this ld and writes the image with this objcopy.  Run bootstrap_matching_s08_2_gas.sh first.
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/../../.." && pwd)"
base="$repo_dir/work/tools/s08-binutils-2.43.1"
archive="$base/binutils-2.43.1.tar.xz"
expected_sha512="20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824"
if [[ ! -f "$archive" ]]; then
    echo "Place official binutils-2.43.1.tar.xz at $archive (sourceware.org/pub/binutils/releases/)" >&2
    exit 1
fi
actual_sha512="$(sha512sum "$archive" 2>/dev/null | awk '{print $1}' || true)"
[[ -n "$actual_sha512" ]] || actual_sha512="$(shasum -a 512 "$archive" | awk '{print $1}')"
if [[ "$actual_sha512" != "$expected_sha512" ]]; then
    echo "Binutils source archive SHA-512 mismatch" >&2
    exit 1
fi
mkdir -p "$base/source" "$base/prefix"
if [[ ! -d "$base/source/binutils-2.43.1" ]]; then
    tar -xf "$archive" -C "$base/source"
fi
# a separate build tree: the assembler's configure of the first bootstrap disabled ld
mkdir -p "$base/build-link"
cd "$base/build-link"
if ! ../source/binutils-2.43.1/configure \
    --target=i686-w64-mingw32 \
    --prefix="$base/prefix" \
    --disable-nls --disable-werror --disable-gdb --disable-gprof --disable-gold \
    --disable-sim --disable-libdecnumber --disable-readline \
    --enable-deterministic-archives --with-system-zlib > ../configure-link.log 2>&1; then
    tail -n 60 ../configure-link.log
    exit 1
fi
if ! make -j2 MAKEINFO=true all-ld all-binutils > ../build-link.log 2>&1; then
    tail -n 80 ../build-link.log
    exit 1
fi
if ! make MAKEINFO=true install-ld install-binutils > ../install-link.log 2>&1; then
    tail -n 60 ../install-link.log
    exit 1
fi
"$base/prefix/bin/i686-w64-mingw32-ld" --version | head -n 1
"$base/prefix/bin/i686-w64-mingw32-objcopy" --version | head -n 1
