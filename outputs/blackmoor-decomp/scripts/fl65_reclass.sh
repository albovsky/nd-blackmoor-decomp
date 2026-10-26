#!/bin/bash
# FL-65: classify an already merged log again with the current rules; usage: fl65_reclass.sh TAG   (run from outputs/blackmoor-decomp; tasks/fl65/TAG-merged.txt and TAG-o2.json exist)
cd "$(dirname "$0")/.." || exit 1
python3 scripts/fl58_classify.py "tasks/fl65/$1-merged.txt" --equiv "tasks/fl65/$1-o2.json" --out "tasks/fl65/$1-surv.json"
