#!/bin/bash
# The canonical full-suite command (QA-1).
#
#   script/run_test_suite.sh [--no-build] [unittest options, e.g. -v]
#
# 1. rebuilds every ignored artifact with script/build_all_native_checks.sh
#    (skipped with --no-build), so no test runs against a stale library;
# 2. runs the whole suite with the oracle interpreter (the only one that has
#    Unicorn) from the workspace root, with BLACKMOOR_REQUIRE_ORACLE=1 so a
#    missing oracle is a failure rather than a skip.
#
# The exit status is unittest's. Extra arguments go straight to unittest.
# The same suite without the wrapper:
#   work/tools/oracle-python/bin/python -m unittest discover \
#       -s outputs/blackmoor-decomp/tests -p 'test_*.py'
set -euo pipefail

workspace="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
oracle_python="$workspace/work/tools/oracle-python/bin/python"
original="$workspace/work/original/GAME.EXE"

build=1
arguments=()
for argument in "$@"; do
    if [[ "$argument" == "--no-build" ]]; then
        build=0
    else
        arguments+=("$argument")
    fi
done

if [[ ! -x "$oracle_python" ]]; then
    {
        echo "run_test_suite.sh: oracle interpreter not found or not executable:"
        echo "  $oracle_python"
        echo "It is the Python with Unicorn that runs the original-x86 oracles; set it up under work/tools/oracle-python first."
    } >&2
    exit 2
fi
if ! "$oracle_python" -c 'import unicorn' 2>/dev/null; then
    {
        echo "run_test_suite.sh: the oracle interpreter cannot import unicorn:"
        echo "  $oracle_python"
        echo "Reinstall Unicorn into work/tools/oracle-python before running the suite."
    } >&2
    exit 2
fi
if [[ ! -f "$original" ]]; then
    {
        echo "run_test_suite.sh: original executable not found:"
        echo "  $original"
        echo "The oracle tests need the owned GAME.EXE under work/original (never modified by the suite)."
    } >&2
    exit 2
fi

cd "$workspace"
if [[ "$build" -eq 1 ]]; then
    echo "run_test_suite.sh: rebuilding native artifacts (script/build_all_native_checks.sh)" >&2
    if ! "$workspace/script/build_all_native_checks.sh"; then
        echo "run_test_suite.sh: rebuild failed; not running the suite against partial artifacts." >&2
        exit 3
    fi
else
    echo "run_test_suite.sh: --no-build: using existing artifacts; tests/test_build_freshness.py still reports stale ones." >&2
fi

export BLACKMOOR_REQUIRE_ORACLE=1
exec "$oracle_python" -m unittest discover \
    -s outputs/blackmoor-decomp/tests -p 'test_*.py' \
    ${arguments[@]+"${arguments[@]}"}
