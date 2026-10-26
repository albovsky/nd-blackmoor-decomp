#!/bin/bash
# FL-63: classify the mutation logs of the rows named on the command line: merged log, -O2 identical code, survivor rules with no written reason; output tasks/fl63/TAG-*.
# usage: fl63_classify.sh TAG LOG [LOG ...]      (run from outputs/blackmoor-decomp; a LOG is a tasks/fl63/*.txt log of fl62_onerow.py, one per row; extra logs of the same row go in one argument joined with ':')
cd "$(dirname "$0")/.." || exit 1
set -e          # a failed merge or classifier must stop the run: the later steps would read the previous TAG-* files
tag="$1"
shift
python3 scripts/fl52_merge.py "tasks/fl63/$tag-merged.txt" "$@"
python3 scripts/fl41_o2_classify.py "tasks/fl63/$tag-merged.txt" --out "tasks/fl63/$tag-o2.json" --per-row 100000 --extended --jobs 2
python3 scripts/fl58_classify.py "tasks/fl63/$tag-merged.txt" --equiv "tasks/fl63/$tag-o2.json" --out "tasks/fl63/$tag-surv.json"
