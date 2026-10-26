#!/bin/bash
# FL-65: classify the log tasks/fl65/LOG.txt of one row (a full rerun of the exhaustive check): merged log, -O2 identical code, survivor rules; output tasks/fl65/TAG-*.
# usage: fl65_one.sh TAG LOGFILE      (run from outputs/blackmoor-decomp)
cd "$(dirname "$0")/.." || exit 1
set -e
python3 scripts/fl52_merge.py "tasks/fl65/$1-merged.txt" "$2"
python3 scripts/fl41_o2_classify.py "tasks/fl65/$1-merged.txt" --out "tasks/fl65/$1-o2.json" --per-row 100000 --extended --jobs 2
python3 scripts/fl58_classify.py "tasks/fl65/$1-merged.txt" --equiv "tasks/fl65/$1-o2.json" --out "tasks/fl65/$1-surv.json"
