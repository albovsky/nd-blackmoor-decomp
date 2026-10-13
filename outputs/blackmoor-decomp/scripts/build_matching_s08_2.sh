#!/bin/bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
    echo 'Usage: build_matching_s08_2.sh /absolute/path/to/original/GAME.EXE' >&2
    exit 2
fi
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
python3 "$project_dir/scripts/audit_matching_s08_2.py" "$1"
