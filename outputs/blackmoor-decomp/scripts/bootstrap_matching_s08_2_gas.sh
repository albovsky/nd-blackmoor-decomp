#!/bin/bash
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/../../.." && pwd)"
base="$repo_dir/work/tools/s08-binutils-2.43.1"
archive="$base/binutils-2.43.1.tar.xz"
expected_sha512="20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824"
if [[ ! -f "$archive" ]]; then
    echo "Place official binutils-2.43.1.tar.xz at $archive (sourceware.org/pub/binutils/releases/)" >&2
    exit 1
fi
actual_sha512="$(shasum -a 512 "$archive" | awk '{print $1}')"
if [[ "$actual_sha512" != "$expected_sha512" ]]; then
    echo "Binutils source archive SHA-512 mismatch" >&2
    exit 1
fi
mkdir -p "$base/source" "$base/build" "$base/prefix"
if [[ ! -d "$base/source/binutils-2.43.1" ]]; then
    tar -xf "$archive" -C "$base/source"
fi
cd "$base/build"
if ! ../source/binutils-2.43.1/configure \
    --target=i686-w64-mingw32 \
    --prefix="$base/prefix" \
    --disable-nls --disable-werror --disable-gdb --disable-gprof --disable-gold \
    --disable-ld --disable-sim --disable-libdecnumber --disable-readline \
    --enable-deterministic-archives --with-system-zlib > ../configure.log 2>&1; then
    tail -n 60 ../configure.log
    exit 1
fi
if ! make -j2 MAKEINFO=true all-gas > ../build.log 2>&1; then
    tail -n 80 ../build.log
    exit 1
fi
if ! make MAKEINFO=true install-gas > ../install.log 2>&1; then
    tail -n 60 ../install.log
    exit 1
fi
"$base/prefix/bin/i686-w64-mingw32-as" --version | head -n 2
