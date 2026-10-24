#!/usr/bin/env python3
"""FL-50: merge the per-window lines of `tests/fl40_mutation_check.py --window lo:hi` (one log file per window, name ROW-LO-HI.log) into one log line per row,
in the format of the other mutation logs, and append it to a log file.

  fl50_merge_windows.py WINDOW_DIR ROW LOG      (run from outputs/blackmoor-decomp)

The row's windows must cover mutants 0..N without a gap (checked from the file names; mutants that do not compile are left out of a window's count)."""
import json
from pathlib import Path
import random
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M

LINE = re.compile(r'(0x[0-9a-f]+) mutants (\d+) killed (\d+) survivors (.*)')


def main():
    directory, row, log = Path(sys.argv[1]), sys.argv[2], Path(sys.argv[3])
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    total = len(M.mutants(funcs[row], int(row, 16), random.Random(int(row, 16)), 100000))
    mutants = killed = budget = hangs = 0
    survivors = []
    for f in sorted(directory.glob(row + '-*.log')):
        lines = [LINE.match(l) for l in f.read_text().splitlines() if l.startswith('0x')]
        if len(lines) != 1 or lines[0] is None:
            sys.exit('%s: expected exactly one result line, found %d' % (f.name, len(lines)))
        for m in lines:
            mutants += int(m.group(2))
            killed += int(m.group(3))
            rest = m.group(4)
            survivors += eval(rest[:rest.rindex(']') + 1])
            b = re.search(r'budget-kills (\d+)', rest)
            budget += int(b.group(1)) if b else 0
            h = re.search(r'hang-kills (\d+)', rest)
            hangs += int(h.group(1)) if h else 0
    spans = sorted((int(a), int(b)) for a, b in (re.findall(r'-(\d+)-(\d+)\.log$', f.name)[0] for f in directory.glob(row + '-*.log')))
    if spans[0][0] != 0 or spans[-1][1] < total or any(x[1] != y[0] for x, y in zip(spans, spans[1:])):
        sys.exit('windows %s do not cover mutants 0..%d' % (spans, total))
    with log.open('a') as out:
        out.write('%s mutants %d killed %d survivors %r hang-kills %d budget-kills %d\n' % (row, mutants, killed, survivors, hangs, budget))
    print(row, mutants, killed, len(survivors))


if __name__ == '__main__':
    main()
