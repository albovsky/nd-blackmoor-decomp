#!/bin/bash
set -euo pipefail
workspace="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mode="${1:-run}"
if [[ $# -gt 0 ]]; then shift; fi
case "$mode" in
    run|--verify|--debug|--logs|--telemetry|--build-only) ;;
    *) printf 'Usage: %s [run|--verify|--debug|--logs|--telemetry|--build-only] [app arguments]\n' "$0" >&2; exit 2 ;;
esac
# Leave an existing user game and its save directory untouched.
if /usr/bin/pgrep -f '/Contents/MacOS/BlackmoorRecompiled([[:space:]]|$)' >/dev/null; then
    printf 'Blackmoor Recompiled is already running; quit it normally before rebuilding or launching.\n' >&2
    exit 1
else
    query_status=$?
    if [[ "$query_status" != 1 ]]; then
        printf 'Cannot check for an existing game (pgrep status %s); no build or launch.\n' "$query_status" >&2
        exit 1
    fi
fi
project="$workspace/outputs/blackmoor-decomp"
python_env="$workspace/work/tools/recomp-python"
python="$python_env/bin/python3"
if [[ ! -x "$python" ]]; then
    printf 'Missing project build Python. Run %s/script/setup_recomp_python.sh first.\n' "$workspace" >&2
    exit 1
fi
"$python" -I - "$project/recomp/requirements-build.txt" <<'PYTHON'
from importlib.metadata import PackageNotFoundError, version
from pathlib import Path
import sys

for line in Path(sys.argv[1]).read_text().splitlines():
    line = line.strip()
    if not line or line.startswith('#'):
        continue
    name, separator, expected = line.partition('==')
    if not separator or not name or not expected:
        raise SystemExit('Expected an exact build dependency pin: ' + line)
    try:
        actual = version(name)
    except PackageNotFoundError:
        actual = 'missing'
    if actual != expected:
        raise SystemExit(f'{name}: expected {expected}, found {actual}; run script/setup_recomp_python.sh')
PYTHON
# build_macos.sh invokes python3; its child generator inherits this interpreter.
export PATH="$python_env/bin:$PATH"
source_bundle="${BLACKMOOR_BUNDLE_PATH:-$project/Blackmoor Recompiled.app}"
"$project/recomp/build_macos.sh"
if [[ "$mode" == --build-only ]]; then
    printf 'Built %s (no launch)\n' "$source_bundle"
    exit 0
fi
# Keep the executable launch copy outside File Provider package updates.
# Do not stop an existing game; each requested launch owns its new copy.
runtime_dir="$(mktemp -d -t blackmoor-recomp-run.XXXXXX)"
bundle="$runtime_dir/Blackmoor Recompiled.app"
/usr/bin/ditto --noextattr --norsrc "$source_bundle" "$bundle"
/usr/bin/codesign --verify --strict "$bundle"
executable="$bundle/Contents/MacOS/BlackmoorRecompiled"
app_args=(--mute "$@")
start_app() {
    "$executable" "${app_args[@]}" &
    app_pid=$!
    sleep 1
    if ! app_command="$(/bin/ps -p "$app_pid" -o command=)"; then
        printf 'Blackmoor Recompiled exited before verification (pid %s).\n' "$app_pid" >&2
        return 1
    fi
    if [[ "$app_command" != "$executable" && "$app_command" != "$executable "* ]]; then
        printf 'Unexpected executable for launched pid %s: %s\n' "$app_pid" "$app_command" >&2
        return 1
    fi
}
case "$mode" in
    --debug) exec /usr/bin/lldb -- "$executable" "${app_args[@]}" ;;
    --logs|--telemetry)
        start_app
        /usr/bin/log stream --info --style compact --predicate 'process == "BlackmoorRecompiled"'
        ;;
    --verify)
        start_app
        printf 'Running pid %s: %s\n' "$app_pid" "$executable"
        ;;
    run) exec "$executable" "${app_args[@]}" ;;
esac
