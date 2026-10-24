#!/usr/bin/env python3
"""FL-48: the mutants that survive in the last run of each row of a mutation-check log, as {row: [mutant hash]} for FL48_ONLY (tests/fl41_mutation_check.py rechecks only these).
   fl48_only.py OUT LOG [--rows 0x...,0x...]"""
import json
from pathlib import Path
import re
import sys


def main():
    out, log = sys.argv[1:3]
    rows = sys.argv[sys.argv.index('--rows') + 1].split(',') if '--rows' in sys.argv else None
    res = {}
    for line in Path(log).read_text().split('\n'):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if m and (rows is None or m.group(1) in rows):
            res[m.group(1)] = sorted({s[3] for s in eval(m.group(2)[:m.group(2).rindex(']') + 1]) if s[2] == 'survives'})
    Path(out).write_text(json.dumps({k: v for k, v in res.items() if v}, indent=1) + '\n')
    print(len(res), 'rows', sum(len(v) for v in res.values()), 'mutants')


if __name__ == '__main__':
    main()
