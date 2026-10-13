#!/bin/bash
set -euo pipefail
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
repo_dir="$(cd "$project_dir/../.." && pwd)"
original="${1:-$repo_dir/work/original/GAME.EXE}"
assembler="$repo_dir/work/tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
object="$project_dir/build/matching_s08_2_x86.obj"
if [[ ! -x "$assembler" ]]; then
    echo "Pinned GNU as missing; run outputs/blackmoor-decomp/scripts/bootstrap_matching_s08_2_gas.sh" >&2
    exit 1
fi
mkdir -p "$(dirname "$object")"
"$assembler" --32 -o "$object" "$project_dir/src/matching_s08_2_x86.s"
python3 "$project_dir/scripts/audit_matching_s08_2_x86.py" --original "$original" --object "$object"
