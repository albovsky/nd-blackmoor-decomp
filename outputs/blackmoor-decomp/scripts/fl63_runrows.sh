#!/bin/bash
# FL-63: the mutation check of the rows named on the command line, one after the other; log tasks/fl63/TAG-ROW.txt (TAG is $FL63_TAG, default h1).
# $FL63_SCEN: a --scen file ({row: [[seed, overrides], ...]}); $FL63_NOHARDEN=1: add --no-harden (the killers of the checker's fixed seed ranges are not added to the corpus).
cd "$(dirname "$0")/.." || exit 1
mkdir -p tasks/fl63
for row in "$@"; do
  FL48_RLIMIT_MB=6000 timeout "${FL63_TIMEOUT:-3000}" python3 -u scripts/fl62_onerow.py "$row" ${FL63_SCEN:+--scen "$FL63_SCEN"} ${FL63_NOHARDEN:+--no-harden} > "tasks/fl63/${FL63_TAG:-h1}-$row.txt" 2>&1
done
