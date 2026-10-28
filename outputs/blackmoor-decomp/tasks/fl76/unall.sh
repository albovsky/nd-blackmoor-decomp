#!/bin/bash
# unall.sh ROW...: un.py each row against the committed partial scenarios, output tasks/fl76/out/ROW.json and tasks/fl76/out/ROW.txt
for r in "$@"; do
  python3 tasks/fl76/un.py $r tasks/fl76/out/$r.json tasks/fl66-partial-scenarios.json > tasks/fl76/out/$r.txt 2>&1
done
