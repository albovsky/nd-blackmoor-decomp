#!/bin/bash
set -euo pipefail
workspace="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mode="${1:-run}"
if [[ $# -gt 0 ]]; then shift; fi
case "$mode" in
    run|--verify|--debug|--logs|--telemetry) ;;
    *) printf 'Usage: %s [run|--verify|--debug|--logs|--telemetry] [app arguments]\n' "$0" >&2; exit 2 ;;
esac
project="$workspace/outputs/blackmoor-decomp"
source_bundle="$project/Blackmoor Reconstruction.app"
# Exact executable name belongs solely to this project; never stop GOG/Wine.
/usr/bin/pkill -x BlackmoorNative >/dev/null 2>&1 || true
"$project/scripts/build_native_app.sh"
# Keep the executable launch copy outside File Provider's package metadata
# updates. This temporary directory stays available for the running app.
runtime_dir="$(mktemp -d /private/tmp/blackmoor-native-run-01a13368.XXXXXX)"
bundle="$runtime_dir/Blackmoor Reconstruction.app"
/usr/bin/ditto --noextattr --norsrc "$source_bundle" "$bundle"
/usr/bin/codesign --verify --strict "$bundle"
case "$mode" in
    --debug) /usr/bin/lldb -- "$bundle/Contents/MacOS/BlackmoorNative" "$@" ;;
    --logs|--telemetry)
        /usr/bin/open -n "$bundle" --args "$@"
        /usr/bin/log stream --info --style compact --predicate 'process == "BlackmoorNative"'
        ;;
    --verify)
        /usr/bin/open -n "$bundle" --args "$@"
        sleep 1
        /usr/bin/pgrep -x BlackmoorNative >/dev/null
        ;;
    run) /usr/bin/open -n "$bundle" --args "$@" ;;
esac
