#!/bin/bash
# FL-65: the FL-62 definitive logs (tasks/fl62/p5|p4|p3|p2-ROW.txt, plus b-ROW.txt) of the rows named on the command line, classified with the cell rules; output tasks/fl65/TAG-*. A row of tasks/fl63/ keeps its newer log: pass LOG for it with FL65_LOG_ROW=ROW:LOG.
# usage: fl65_classify.sh TAG ROW [ROW ...]      (run from outputs/blackmoor-decomp)
cd "$(dirname "$0")/.." || exit 1
set -e
tag="$1"
shift
logs=()
for row in "$@"; do
  if grep -qs " killed " "tasks/fl62/p5-$row.txt"; then log="tasks/fl62/p5-$row.txt"; elif grep -qs " killed " "tasks/fl62/p4-$row.txt"; then log="tasks/fl62/p4-$row.txt"; elif grep -qs " killed " "tasks/fl62/p3-$row.txt"; then log="tasks/fl62/p3-$row.txt"; else log="tasks/fl62/p2-$row.txt"; fi
  if [ -f "tasks/fl62/b-$row.txt" ]; then log="$log:tasks/fl62/b-$row.txt"; fi
  logs+=("$log")
done
python3 scripts/fl52_merge.py "tasks/fl65/$tag-merged.txt" "${logs[@]}"
python3 scripts/fl41_o2_classify.py "tasks/fl65/$tag-merged.txt" --out "tasks/fl65/$tag-o2.json" --per-row 100000 --extended --jobs 2
python3 scripts/fl58_classify.py "tasks/fl65/$tag-merged.txt" --equiv "tasks/fl65/$tag-o2.json" --out "tasks/fl65/$tag-surv.json"
