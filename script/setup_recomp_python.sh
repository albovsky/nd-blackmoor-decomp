#!/bin/bash
# Install only the pinned source-generation dependencies into this checkout.
set -euo pipefail
workspace="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python_env="$workspace/work/tools/recomp-python"
requirements="$workspace/outputs/blackmoor-decomp/recomp/requirements-build.txt"
bootstrap_python="${RECOMP_BOOTSTRAP_PYTHON:-python3}"
if [[ -e "$python_env" && ! -f "$python_env/pyvenv.cfg" ]]; then
    printf 'Refusing an existing non-venv path: %s\n' "$python_env" >&2
    exit 1
fi
if [[ ! -d "$python_env" ]]; then
    "$bootstrap_python" -m venv "$python_env"
fi
"$python_env/bin/python3" -I -m pip --disable-pip-version-check install --no-input \
    --only-binary=:all: --no-deps --requirement "$requirements"
printf 'Build Python ready: %s\n' "$python_env/bin/python3"
