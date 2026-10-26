#!/bin/bash
# FL-62: the mutation check of the rows named on the command line, one after the other (TAG is $FL62_TAG, default m); log tasks/fl62/TAG-ROW.txt
cd "$(dirname "$0")/.."
for row in "$@"; do
  timeout "${FL62_TIMEOUT:-3000}" python3 -u scripts/fl62_onerow.py "$row" ${FL62_SCEN:+--scen "$FL62_SCEN"} > "tasks/fl62/${FL62_TAG:-m}-$row.txt" 2>&1
done
