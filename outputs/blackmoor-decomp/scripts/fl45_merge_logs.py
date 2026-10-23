#!/usr/bin/env python3
"""FL-45: merge mutation-check logs (oldest first): for every row the lines of its LAST run (the `mutants N killed K survivors ...` line and the `killed by a hang or crash` / `divergent seeds`
lines of the same row that precede it) go into the output. Rows only in an older log keep that log's lines.   fl45_merge_logs.py OUT LOG [LOG ...]"""
import re
import sys
from pathlib import Path

out, logs = sys.argv[1], sys.argv[2:]
rows = {}
for log in logs:
    pending = {}
    for line in Path(log).read_text().split('\n'):
        m = re.match(r'^(0x[0-9a-f]+) ', line)
        if not m:
            continue
        row = m.group(1)
        if ' mutants ' in line and re.match(r'^0x[0-9a-f]+ mutants \d+ killed', line):
            rows[row] = pending.pop(row, []) + [line]
        elif 'COMPILE ERROR' in line:
            continue
        else:
            pending.setdefault(row, []).append(line)
Path(out).write_text('\n'.join(l for r in sorted(rows, key=lambda x: int(x, 16)) for l in rows[r]) + '\n')
print(len(rows), 'rows')
