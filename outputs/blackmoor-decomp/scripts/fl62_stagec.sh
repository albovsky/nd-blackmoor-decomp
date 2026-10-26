#!/bin/bash
# FL-62 stage C: for each row, scenarios aimed at its unexplained survivors (scripts/fl62_target.py from the classification SURV.json), then the check on them: tasks/fl62/tgt-ROW.json, p5-ROW.txt (+ b-ROW.txt budget rerun by fl62_pipe.py)
# usage: fl62_stagec.sh SURV.json ROW [ROW ...]      (from outputs/blackmoor-decomp)
cd "$(dirname "$0")/.."
surv="$1"
shift
for row in "$@"; do
  if ! grep -qs " killed " "tasks/fl62/p5-$row.txt"; then
    python3 -u scripts/fl62_target.py "$surv" "$row" --out "tasks/fl62/tgt-$row.json" --cap "${FL62_CAP:-1500}" > "tasks/fl62/tgt-$row.log" 2>&1
    FL48_RLIMIT_MB=6000 timeout "${FL62_TIMEOUT:-1800}" python3 -u scripts/fl62_onerow.py "$row" --scen "tasks/fl62/tgt-$row.json" --no-harden > "tasks/fl62/p5-$row.txt" 2>&1
  fi
  echo "$row p5"
done
