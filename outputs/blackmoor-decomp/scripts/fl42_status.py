#!/usr/bin/env python3
"""FL-42: which rows are clean (every mutant killed or explained) after the survivor rules and the rescue runs?

  fl42_status.py   (run from outputs/blackmoor-decomp) writes tasks/fl42-held-rows.json (row -> remaining unexplained survivors) and prints counts
"""
import json
from pathlib import Path
import re

PROJECT = Path(__file__).resolve().parents[1]
PAIRS = [('tasks/fl42-survivors-fl40.json', 'tasks/fl42-rescue-old.txt'), ('tasks/fl42-survivors.json', 'tasks/fl42-rescue-new.txt')]


def main():
    held, clean = {}, []
    for surv, rescue in PAIRS:
        data = json.loads((PROJECT / surv).read_text())['rows_with_survivors']
        alive = {}
        for line in (PROJECT / rescue).read_text().splitlines():
            m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
            if m:
                items = eval(m.group(2)[:m.group(2).rindex(']')+1])
                alive[m.group(1)] = {(k, n) for k, n, why in items if why == 'survives'}
        for row, items in data.items():
            left = [(k, n, t) for k, c, t, n in items if c is None and (row not in alive or (k, n) in alive[row])]
            if left:
                held[row] = [{'kind': k, 'line': n, 'statement': t} for k, n, t in left]
    out = {'note': 'Rows translated by scripts/lift_function.py whose oracle and differential pass, but whose mutation check leaves survivors that nothing explains (identical -O2 code, the rules of scripts/fl40_survivors.py, or a killing seed from the rescue runs). Not accepted.', 'rows': held}
    (PROJECT / 'tasks/fl40-held-rows.json').write_text(json.dumps(out, indent=1) + '\n')
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
    import collections
    c = collections.Counter(s['kind'] for l in held.values() for s in l)
    print('corpus rows %d, held %d, accepted %d; remaining survivors by kind %s' % (len(corpus), len(held), len(corpus) - len(held), dict(c)))


if __name__ == '__main__':
    main()
