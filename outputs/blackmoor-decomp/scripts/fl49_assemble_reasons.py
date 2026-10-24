#!/usr/bin/env python3
"""FL-49: assemble tasks/fl49-written-reasons.json from writer and reviewer outputs (JSON lists of {row, kind, line, reason|note, verdict}); a reason is kept only when the reviewer confirmed it.

  fl49_assemble_reasons.py --reasons W.json [W2.json ...] --reviews R.json [R2.json ...] [--out tasks/fl49-written-reasons.json]      (run from outputs/blackmoor-decomp)
"""
import argparse
import json
from pathlib import Path
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reasons', nargs='+', required=True)
    ap.add_argument('--reviews', nargs='+', required=True)
    ap.add_argument('--out', default=str(PROJECT / 'tasks/fl49-written-reasons.json'))
    a = ap.parse_args()
    writers = {}
    for f in a.reasons:
        for x in json.loads(Path(f).read_text()):
            if x['verdict'] == 'equivalent':
                writers[(x['row'], x['kind'], x['line'])] = x['reason']
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    rows = {}
    for f in a.reviews:
        for x in json.loads(Path(f).read_text()):
            k = (x['row'], x['kind'], x['line'])
            if x['verdict'] != 'confirmed' or k not in writers:
                continue
            statement = funcs[x['row']].split('\n')[x['line']].strip()[:300]
            rows.setdefault(x['row'], []).append({'kind': x['kind'], 'line': x['line'], 'statement': statement, 'reason': writers[k], 'review': x['note']})
    doc = {'note': 'FL-49: row-specific written reasons that a lifted-C survivor (kind, line) is equivalent to the original, same rules as tasks/fl46-written-reasons.json. Each was written by one Sonnet reader from the function alone and confirmed by a second, independent Sonnet reviewer who tried to break it (reviewer note kept); rejected reasons are not here. The statement must equal the current line of the row, else the reason is ignored (scripts/fl44_final.py).',
           'rows': {r: sorted(v, key=lambda i: (i['line'], i['kind'])) for r, v in sorted(rows.items(), key=lambda kv: int(kv[0], 16))}}
    Path(a.out).write_text(json.dumps(doc, indent=1) + '\n')
    print(sum(len(v) for v in rows.values()), 'reasons in', len(rows), 'rows')


if __name__ == '__main__':
    main()
