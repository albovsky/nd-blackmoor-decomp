#!/usr/bin/env python3
"""FL-63: pool the scenario files of earlier rounds (FL-62 boundary, second boundary and targeted files) and of this round into one --scen file for scripts/fl62_onerow.py.

  fl63_pool.py OUT.json ROW [ROW ...] [--extra FILE ...]      (run from outputs/blackmoor-decomp)

The files are tasks/fl62/{bound,bound2,tgt}-ROW.json and tasks/fl63/{tgt,shift}-ROW.json when they exist, plus every --extra FILE ({row: [[seed, overrides], ...]}). Duplicates are dropped.
"""
import argparse
import json
from pathlib import Path

ap = argparse.ArgumentParser()
ap.add_argument('out')
ap.add_argument('rows', nargs='+')
ap.add_argument('--extra', action='append', default=[])
a = ap.parse_args()
out = {}
for row in a.rows:
    files = [Path('tasks/fl62/%s-%s.json' % (k, row)) for k in ('bound', 'bound2', 'tgt')] + [Path('tasks/fl63/%s-%s.json' % (k, row)) for k in ('tgt', 'shift')] + [Path(f) for f in a.extra]
    seen, items = set(), []
    for f in files:
        if not f.exists():
            continue
        for seed, ov in json.loads(f.read_text()).get(row, []):
            k = (seed, tuple(map(tuple, ov)))
            if k not in seen:
                seen.add(k)
                items.append([seed, ov])
    out[row] = items
    print(row, len(items))
Path(a.out).write_text(json.dumps(out))
