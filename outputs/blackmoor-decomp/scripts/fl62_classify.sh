#!/bin/bash
# FL-62: classify the definitive logs (tasks/fl62/p3-ROW.txt, else p2-ROW.txt) of the rows named on the command line: merged log, -O2 identical code, survivor rules with no written reason; output tasks/fl62/TAG-*.
# usage: fl62_classify.sh TAG ROW [ROW ...]      (run from outputs/blackmoor-decomp)
cd "$(dirname "$0")/.."
tag="$1"
shift
logs=()
for row in "$@"; do
  if grep -qs " killed " "tasks/fl62/p5-$row.txt"; then log="tasks/fl62/p5-$row.txt"; elif grep -qs " killed " "tasks/fl62/p4-$row.txt"; then log="tasks/fl62/p4-$row.txt"; elif grep -qs " killed " "tasks/fl62/p3-$row.txt"; then log="tasks/fl62/p3-$row.txt"; else log="tasks/fl62/p2-$row.txt"; fi
  if [ -f "tasks/fl62/b-$row.txt" ]; then log="$log:tasks/fl62/b-$row.txt"; fi
  logs+=("$log")
done
python3 scripts/fl52_merge.py "tasks/fl62/$tag-merged.txt" "${logs[@]}"
python3 scripts/fl41_o2_classify.py "tasks/fl62/$tag-merged.txt" --out "tasks/fl62/$tag-o2.json" --per-row 100000 --extended --jobs 2
python3 scripts/fl58_classify.py "tasks/fl62/$tag-merged.txt" --equiv "tasks/fl62/$tag-o2.json" --out "tasks/fl62/$tag-surv.json"
