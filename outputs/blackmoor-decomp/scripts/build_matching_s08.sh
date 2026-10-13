#!/bin/bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
    echo 'Usage: build_matching_s08.sh /absolute/path/to/original/GAME.EXE' >&2
    exit 2
fi
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
repository_dir="$(cd "$project_dir/../.." && pwd)"
work_dir="$repository_dir/work"
build_dir="$project_dir/build"
mkdir -p "$build_dir"
xcrun clang -target i686-pc-windows-msvc -std=c11 -O0 -fno-omit-frame-pointer \
    -fno-stack-protector -fno-builtin -c "$project_dir/src/matching_s08.c" \
    -o "$build_dir/matching_s08.obj"
verifier_report="$build_dir/matching_s08-verifier-report.json"
if python3 "$project_dir/scripts/verify_matches.py" "$1" \
    "$project_dir/matches_s08.json" --report "$verifier_report" >/dev/null; then
    verifier_status=0
else
    verifier_status=$?
fi
if [[ "$verifier_status" -gt 1 ]]; then
    echo "verify_matches failed with status $verifier_status" >&2
    exit "$verifier_status"
fi
python3 "$project_dir/scripts/audit_matching_s08.py" "$1" "$verifier_report"
rm -f "$verifier_report"
