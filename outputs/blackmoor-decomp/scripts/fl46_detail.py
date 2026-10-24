#!/usr/bin/env python3
"""FL-46: for the held rows, the mutants behind each unexplained survivor (kind, line): the original line and the replacement line(s), regenerated with the same seed as the exhaustive run.

  fl46_detail.py [--out tasks/fl46-detail.json]      (run from outputs/blackmoor-decomp)
"""
import json
from pathlib import Path
import random
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M


def details(held):
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    out = {}
    for row, items in held.items():
        if items[0]['kind'] == 'unchecked':
            continue
        text = funcs[row]
        lines = text.split('\n')
        muts = M.mutants(text, int(row, 16), random.Random(int(row, 16)), 100000)
        out[row] = []
        for it in items:
            rep = [m[2].split('\n')[it['line']].strip() for m in muts if m[0] == it['kind'] and m[1] == it['line']]
            out[row].append({'kind': it['kind'], 'line': it['line'], 'original': lines[it['line']].strip(), 'mutants': rep})
    return out


if __name__ == '__main__':
    held = json.loads((PROJECT / 'tasks/fl40-held-rows.json').read_text())['rows']
    out = details(held)
    if '--out' in sys.argv:
        Path(sys.argv[sys.argv.index('--out') + 1]).write_text(json.dumps(out, indent=1) + '\n')
    print(sum(len(v) for v in out.values()), 'survivors in', len(out), 'rows')
