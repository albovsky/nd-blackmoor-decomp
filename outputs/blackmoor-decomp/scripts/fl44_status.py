#!/usr/bin/env python3
"""FL-44: which held rows are clean after the rescue run with seeds from 40000 (callees with boundary-value styles) and the `rep count` rule of scripts/fl40_survivors.py?

  fl44_status.py [--write]      (run from outputs/blackmoor-decomp)

Reads tasks/fl40-held-rows.json (row -> unexplained survivors: kind, line, statement) and tasks/fl44-rescue-base40000.txt (the log of
`tests/fl40_mutation_check.py --per-row 100000 --rescue ... --base 40000`). A survivor leaves the held list when the rescue killed it on a seed where the unmutated
translation equals the original, or when `rep count` explains it. With --write the held file is rewritten with what is left.
"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M
import fl40_survivors as S

HELD = PROJECT / 'tasks/fl40-held-rows.json'
LOG = PROJECT / 'tasks/fl44-rescue-base40000.txt'


def main():
    held = json.loads(HELD.read_text())
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    alive, ran = {}, {}
    for line in LOG.read_text().splitlines():
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if m:
            items = eval(m.group(2)[:m.group(2).rindex(']') + 1])
            alive[m.group(1)] = {(k, n) for k, n, why in items if why == 'survives'}
            ran[m.group(1)] = int(re.match(r'\S+ mutants (\d+)', line).group(1)) > 0
    rows, freed, explained, classes = {}, [], {}, {}
    for row, items in held['rows'].items():
        text = funcs[row].split('\n')
        left = []
        for it in items:
            key = (it['kind'], it['line'])
            if ran.get(row) and key not in alive[row]:
                continue            # killed by the corpus (it holds the earlier killing seeds) or by a rescue seed; no mutant of that statement survives
            why = S.classify(it['kind'], text, it['line'], False, row) if it['kind'] != 'unchecked' else None
            if why in ('rep count', 'masked read', 'range', 'flow repeat', 'flow dead'):
                explained[why] = explained.get(why, 0) + 1
                classes.setdefault(row, {})[(it['kind'], it['line'])] = why
                continue
            left.append(it)
        if left:
            rows[row] = left
        else:
            freed.append(row)
    print('held %d -> %d; freed %d rows; survivors explained by rule %s' % (len(held['rows']), len(rows), len(freed), explained))
    print(' '.join(sorted(freed, key=lambda k: int(k, 16))))
    if '--write' in sys.argv:
        held['rows'] = rows
        HELD.write_text(json.dumps(held, indent=1) + '\n')


if __name__ == '__main__':
    main()
