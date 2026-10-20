#!/bin/bash
# The single build step for GAME.EXE (packet M-D).  Assembles every committed source with the pinned
# i686-w64-mingw32-as 2.43.1, links the objects with the same binutils' ld and writes the image with its objcopy.
# Every output byte is assembler or linker output of text inputs; link_image.py only writes those text inputs, and the
# data text comes from the owner's own GAME.EXE (see its docstring).
#
#   scripts/build_game_exe.sh [--original PATH] [--prefix DIR] [--jobs N] [--out DIR] [--data-build DIR]
#
# The one step that reads the owner's local GAME.EXE is the extraction of the data sources (rdata, data, resources,
# headers, the CRT block-copy jump tables): they are regenerated from it, checked against the committed hashes and
# layouts, and written under work/asm_data (never committed).  The result is build/game/GAME.linked.exe; the script
# requires its SHA-256 to equal the original's.  That is build evidence, not a claim of a whole-file x86 match.
set -euo pipefail
project="$(cd "$(dirname "$0")/.." && pwd)"
repo_dir="$(cd "$project/../.." && pwd)"
prefix="$repo_dir/work/tools/s08-binutils-2.43.1/prefix"
original="$repo_dir/work/original/GAME.EXE"
out="$project/build/game"
data_build="$repo_dir/work/asm_data"
jobs="$(nproc 2>/dev/null || echo 4)"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --original) original="$2"; shift 2 ;;
        --prefix) prefix="$2"; shift 2 ;;
        --jobs) jobs="$2"; shift 2 ;;
        --out) out="$2"; shift 2 ;;
        --data-build) data_build="$2"; shift 2 ;;
        *) echo "unknown argument $1" >&2; exit 2 ;;
    esac
done
mkdir -p "$out" "$data_build"
prefix="$(cd "$prefix" && pwd)"
out="$(cd "$out" && pwd)"
data_build="$(cd "$data_build" && pwd)"
original="$(cd "$(dirname "$original")" && pwd)/$(basename "$original")"
target=i686-w64-mingw32
as="$prefix/bin/$target-as"
ld="$prefix/bin/$target-ld"
objcopy="$prefix/bin/$target-objcopy"

python3 "$project/scripts/link_image.py" prepare --prefix "$prefix" --original "$original" --out "$out" --data-build "$data_build"
cd "$out"
rm -f obj/*.o game.pe GAME.linked.exe
xargs -P "$jobs" -I{} "$as" --32 -o obj/{}.o src/{}.s < assemble.list
"$ld" @link.rsp
"$objcopy" @objcopy.rsp
python3 "$project/scripts/link_image.py" verify "$out/GAME.linked.exe"
