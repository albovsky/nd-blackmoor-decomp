#!/usr/bin/env python3
"""FL-48: assemble tasks/fl48-written-reasons.json from the writers' files (one JSON list per row: {kind, line, ident, verdict, reason}) and the independent reviewers' files
(one JSON list per row: {kind, line, ident, verdict: confirmed|rejected, note}); a reason is kept only when the reviewer confirmed that mutant.

  fl48_assemble_reasons.py WRITER_DIR REVIEW_DIR [--out tasks/fl48-written-reasons.json]      (run from outputs/blackmoor-decomp)
"""
import json
from pathlib import Path
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M


def main():
    wdir, rdir = Path(sys.argv[1]), Path(sys.argv[2])
    out = Path(sys.argv[sys.argv.index('--out') + 1]) if '--out' in sys.argv else PROJECT / 'tasks/fl48-written-reasons.json'
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    rows = {}
    for rf in sorted(rdir.glob('0x*.json')):
        row = rf.stem
        writers = {(x['kind'], x['line'], x['ident']): x['reason'] for x in json.loads((wdir / rf.name).read_text()) if x['verdict'] == 'equivalent'}
        for x in json.loads(rf.read_text()):
            k = (x['kind'], x['line'], x['ident'])
            if x['verdict'] != 'confirmed' or k not in writers:
                continue
            rows.setdefault(row, []).append({'kind': x['kind'], 'line': x['line'], 'ident': x['ident'], 'statement': funcs[row].split('\n')[x['line']],
                                             'reason': writers[k], 'review': x['note']})
    doc = {'note': 'FL-48: row-specific written reasons that a surviving mutant (kind, line, ident = the hash of the mutated line) of a machine-translated upper-address row is equivalent to the original. Each was written by one Sonnet reader from the function alone and confirmed by a second, independent Sonnet reviewer who tried to break it (reviewer note kept); rejected reasons are not here. The statement must equal the current line of the row, else the reason is ignored (scripts/fl41_survivors.py).',
           'rows': {r: sorted(v, key=lambda i: (i['line'], i['kind'], i['ident'])) for r, v in sorted(rows.items(), key=lambda kv: int(kv[0], 16))}}
    out.write_text(json.dumps(doc, indent=1) + '\n')
    print(sum(len(v) for v in rows.values()), 'reasons in', len(rows), 'rows')


if __name__ == '__main__':
    main()
