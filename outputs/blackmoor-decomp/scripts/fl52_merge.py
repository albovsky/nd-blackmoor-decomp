#!/usr/bin/env python3
"""FL-52: merge the normal mutation log of a row with its step-budget rerun log into one log that scripts/fl41_o2_classify.py and scripts/fl41_survivors.py read.

A mutant that the normal run lists under 'killed by a hang or crash' is NOT killed (Glib's ruling): only the budget rerun (FL45_STRICT_HANG, a fixed step budget on scenarios where the
unmutated translation agrees with the original) can kill it. The merged line of the row lists as survivors (label 'survives') the normal run's 'survives' entries and the budget rerun's
survivors; it fails when the budget log does not account for every hang-listed mutant of the normal log (each must be either killed by the budget or a budget survivor).

  fl52_merge.py OUT.txt NORMAL.txt[:BUDGET.txt] [NORMAL.txt[:BUDGET.txt] ...]       (run from outputs/blackmoor-decomp)

A normal log without a budget log must have no hang-listed mutant."""
import ast
from pathlib import Path
import re
import sys


def parse(path):
    row = hangs = budgets = surv = None
    n = 0
    for line in Path(path).read_text().splitlines():
        m = re.match(r'(0x[0-9a-f]+) mutants killed by a hang or crash (\[.*\])$', line)
        if m:
            hangs = [tuple(x) for x in ast.literal_eval(m.group(2))]
        m = re.match(r'(0x[0-9a-f]+) mutants killed by the step budget (\[.*\])$', line)
        if m:
            budgets = [tuple(x) for x in ast.literal_eval(m.group(2))]
        m = re.match(r'(0x[0-9a-f]+) mutants (\d+) killed (\d+) survivors (\[.*\])$', line)
        if m:
            row, n, surv = m.group(1), int(m.group(2)), ast.literal_eval(m.group(4))
    if row is None:
        raise SystemExit('%s: no result line' % path)
    return row, n, hangs or [], budgets or [], surv


def main():
    out = []
    for arg in sys.argv[2:]:
        normal, _, budget = arg.partition(':')
        row, n, hangs, _, surv = parse(normal)
        hang_idents = {h[2] for h in hangs}
        merged = [s for s in surv if s[2] == 'survives']
        if hang_idents:
            if not budget:
                raise SystemExit('%s: %d hang-listed mutants and no budget log' % (row, len(hang_idents)))
            brow, _, _, bbud, bsurv = parse(budget)
            if brow != row:
                raise SystemExit('%s: budget log is for %s' % (row, brow))
            killed = {b[2] for b in bbud}
            alive = {s[3] for s in bsurv}
            missing = hang_idents - killed - alive
            if missing:
                raise SystemExit('%s: the budget log accounts for neither kill nor survivor of %s' % (row, sorted(missing)))
            merged += [(s[0], s[1], 'survives', s[3]) for s in bsurv if s[3] in hang_idents]
        out.append('%s mutants %d killed %d survivors %r' % (row, n, n - len(merged), merged))
        print(row, 'survivors', len(merged), 'hang-listed', len(hang_idents))
    Path(sys.argv[1]).write_text('\n'.join(out) + '\n')


if __name__ == '__main__':
    main()
