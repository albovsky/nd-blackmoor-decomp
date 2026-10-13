#!/bin/bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
    echo 'Usage: build_matches.sh /absolute/path/to/original/GAME.EXE' >&2
    exit 2
fi
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$project_dir/build"
xcrun clang -target i686-pc-windows-msvc -O2 -fomit-frame-pointer \
    -fno-stack-protector -c "$project_dir/src/initial_functions.c" \
    -o "$project_dir/build/initial_functions.obj"
exec python3 "$project_dir/scripts/verify_matches.py" "$1" \
    "$project_dir/matches.json" --report "$project_dir/matching-report.json"
