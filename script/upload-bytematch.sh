#!/usr/bin/env bash
# Regenerate the objdiff x86 matching report and upload it to ByteMatch.
#
#   script/upload-bytematch.sh            # build objects, report, upload
#   script/upload-bytematch.sh --no-upload  # build objects and report only
#
# Needs the owner's local work/original/GAME.EXE, the pinned GNU as 2.43.1 under
# work/tools/s08-binutils-2.43.1, objdiff-cli under work/tools/objdiff and, for
# the upload, the per-project token in ~/.bytematch-token (never printed).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OBJDIFF_VERSION="v3.8.2"
OBJDIFF="work/tools/objdiff/objdiff-cli"
CENSUS="work/analysis/slices/M03-census/census.json"
REPORT="build/report.json"
PROJECT_URL="https://bytematch.dev/api/v1/projects/albovsky/nd-blackmoor-decomp/reports"
VERSION="gog"

if [[ ! -x "$OBJDIFF" ]]; then
  mkdir -p "$(dirname "$OBJDIFF")"
  curl -fsSL -o "$OBJDIFF" \
    "https://github.com/encounter/objdiff/releases/download/$OBJDIFF_VERSION/objdiff-cli-macos-arm64"
  chmod +x "$OBJDIFF"
fi

if [[ ! -f "$CENSUS" ]]; then
  python3 outputs/blackmoor-decomp/scripts/gen_hinted_asm.py census --out "$(dirname "$CENSUS")"
fi

python3 script/objdiff_units.py
"$OBJDIFF" report generate -o "$REPORT"
python3 - "$REPORT" <<'EOF'
import json, sys
m = json.load(open(sys.argv[1]))["measures"]
print(f"matched {m.get('matched_code', 0)}/{m['total_code']} code bytes "
      f"({m.get('matched_code_percent', 0):.2f}%), "
      f"{m.get('matched_functions', 0)}/{m['total_functions']} functions")
EOF

[[ "${1:-}" == "--no-upload" ]] && exit 0

# Every tracked input of the report must be committed: the generator, the
# auditor it imports, the unit list and the sources and census summary in asm/.
# The private census is checked against asm/census-summary.json by the generator.
if [[ -n "$(git status --porcelain -- objdiff.json script/objdiff_units.py \
    outputs/blackmoor-decomp/scripts outputs/blackmoor-decomp/asm)" ]]; then
  echo "report inputs have uncommitted changes; commit them so the report matches the commit" >&2
  exit 1
fi

gzip -9c "$REPORT" > "$REPORT.gz"
curl --fail-with-body -sS -X POST \
  -H "Authorization: Bearer $(cat ~/.bytematch-token)" \
  -H "Content-Type: application/json" \
  -H "Content-Encoding: gzip" \
  --data-binary @"$REPORT.gz" \
  "$PROJECT_URL?version=$VERSION&commit=$(git rev-parse HEAD)"
echo
