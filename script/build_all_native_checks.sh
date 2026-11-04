#!/bin/bash
set -euo pipefail
workspace="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project="$workspace/outputs/blackmoor-decomp"
# Rebuild ignored artifacts in this checkout. No app is launched.
for builder in "$project"/scripts/build_*.sh; do
    if [[ "$(basename "$builder")" == "build_matches.sh" ]]; then
        /bin/bash "$builder" "$workspace/work/original/GAME.EXE"
    elif [[ "$(basename "$builder")" == "build_matching_s08.sh" ]]; then
        /bin/bash "$builder" "$workspace/work/original/GAME.EXE"
    elif [[ "$(basename "$builder")" == "build_matching_s08_2.sh" ]]; then
        /bin/bash "$builder" "$workspace/work/original/GAME.EXE"
    elif [[ "$(basename "$builder")" == "build_matching_s08_2_x86.sh" ]]; then
        /bin/bash "$builder" "$workspace/work/original/GAME.EXE"
    else
        # Some checked-in shell builders have no executable bit. Use their
        # common shell explicitly so the full suite still rebuilds every one.
        /bin/bash "$builder"
    fi
done
