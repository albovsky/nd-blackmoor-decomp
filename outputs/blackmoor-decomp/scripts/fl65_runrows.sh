#!/bin/bash
# FL-65: the mutation check of the rows named on the command line, one after the other; log tasks/fl65/TAG-ROW.txt (TAG is $FL65_TAG, default h1).
# $FL65_SCEN: a --scen file ({row: [[seed, overrides], ...]}); $FL65_NOHARDEN=1: add --no-harden (the killers of the checker's fixed seed ranges are not added to the corpus).
cd "$(dirname "$0")/.." || exit 1
mkdir -p tasks/fl65
for row in "$@"; do
  FL48_RLIMIT_MB=6000 timeout "${FL65_TIMEOUT:-3000}" python3 -u scripts/fl62_onerow.py "$row" ${FL65_SCEN:+--scen "$FL65_SCEN"} ${FL65_NOHARDEN:+--no-harden} > "tasks/fl65/${FL65_TAG:-h1}-$row.txt" 2>&1
done
