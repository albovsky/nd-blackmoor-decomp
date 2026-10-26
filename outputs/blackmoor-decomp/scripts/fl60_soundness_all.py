#!/usr/bin/env python3
"""FL-60: scripts/fl55_rule_soundness.py over ALL rows of tests/fl41_corpus.json at once, from the committed mutation logs.

  fl60_soundness_all.py CLASSES.json      (CLASSES.json: `fl60_rule_sweep.py classify` output, the mutants of every row as if no seed had killed any)

A mutant that a rule (any class but `written reason`; `identical code` is not asked here either) calls harmless is UNSOUND when a real run killed it with the seeds of the corpus. The real runs are all lines
`ROW mutants N killed K survivors [...]` of tasks/*.txt and tasks/fl52/*.txt with N equal to the number of compiling mutants of the row today (the same translation text); of those the run with the fewest
survivors is used, and a mutant listed in a `killed by a hang or crash` line of that same run's file is never counted as killed (a hang kill is not a seed kill). Rows without such a run are reported.
"""
import ast
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
LINE = re.compile(r'^(0x[0-9a-f]+) mutants (\d+) killed (\d+) survivors (\[.*\])\s*$')
HANG = re.compile(r'^(0x[0-9a-f]+) mutants killed by a hang or crash (\[.*\])\s*$')


def main():
    classes = json.loads(Path(sys.argv[1]).read_text())['mutants']
    runs, hung = {}, {}
    files = sorted(PROJECT.glob('tasks/*.txt')) + sorted(PROJECT.glob('tasks/fl52/*.txt')) + sorted(PROJECT.glob('tasks/fl62/*.txt')) + sorted(PROJECT.glob('tasks/fl63/*.txt')) + sorted(PROJECT.glob('tasks/fl65/*.txt'))
    for f in files:
        for line in f.read_text(errors='replace').splitlines():
            m = LINE.match(line)
            if m:
                try:
                    surv = ast.literal_eval(m.group(4))
                except Exception:
                    continue
                runs.setdefault(m.group(1), []).append((int(m.group(2)), f.name, {x[3] for x in surv if len(x) > 3 and x[2] == 'survives'}, len(surv)))
                continue
            m = HANG.match(line)
            if m:
                try:
                    hung.setdefault((m.group(1), f.name), set()).update(x[2] for x in ast.literal_eval(m.group(2)))
                except Exception:
                    pass
    bad, claimed, norun = [], 0, []
    for row, items in sorted(classes.items(), key=lambda kv: int(kv[0], 16)):
        n_now = len(items)
        ok = [r for r in runs.get(row, []) if r[0] == n_now]
        if not ok:
            norun.append((row, n_now, sorted({r[0] for r in runs.get(row, [])})))
            continue
        best = min(ok, key=lambda r: len(r[2]))
        for kind, n, ident, cls in items:
            if cls is None or cls == 'written reason':
                continue
            claimed += 1
            if ident not in best[2] and ident not in hung.get((row, best[1]), ()):
                bad.append((row, kind, n, ident, cls, best[1]))
    print('rows %d; mutants a rule calls harmless: %d; killed by a real seed run: %d; rows without a matching run: %d' % (len(classes), claimed, len(bad), len(norun)))
    for b in bad:
        print('UNSOUND', b)
    for r in norun:
        print('NORUN', r)


if __name__ == '__main__':
    main()
