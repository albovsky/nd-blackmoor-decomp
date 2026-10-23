#!/usr/bin/env python3
"""FL-43: keep in src/original_methods_fl41.c, tests/fl41_corpus.json and tests/test_fl41_differential.py only the rows whose mutation survivors are all explained
(tasks/fl43-survivors.json: every row of tasks/fl43-mutation-log.txt that is not in `unexplained_rows`); every other row of the corpus goes back to tests/fl41_pending.json
(its entry from the first pass stays; a row the FL-43 check judged gets the FL-43 reason). Run from outputs/blackmoor-decomp."""
import json
from pathlib import Path
import re

PROJECT = Path(__file__).resolve().parents[1]


def main():
    surv = json.loads((PROJECT / 'tasks/fl43-survivors.json').read_text())
    logrows = [l.split()[0] for l in (PROJECT / 'tasks/fl43-mutation-log.txt').read_text().split('\n') if l.startswith('0x')]
    keep = {r for r in logrows if r not in set(surv['unexplained_rows'])}
    src = PROJECT / 'src/original_methods_fl41.c'
    parts = re.split(r'(?=/\* GAME\.EXE 0x[0-9a-f]+ \()', src.read_text())
    out = []
    for p in parts:
        m = re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', p)
        if m and m.group(1) not in keep:
            continue
        out.append(p)
    src.write_text(''.join(out))
    corpus_path = PROJECT / 'tests/fl41_corpus.json'
    corpus = json.loads(corpus_path.read_text())
    pending_path = PROJECT / 'tests/fl41_pending.json'
    pending = json.loads(pending_path.read_text())
    for k in sorted(set(corpus) - keep):
        if k in surv['unexplained_rows']:
            pending[k] = {'status': 'mutation survivor', 'detail': 'FL-43 exhaustive check (tasks/fl43-mutation-log.txt, tasks/fl43-survivors.json): a surviving mutant is neither identical -O2 code nor a proven no-op'}
        else:
            pending.setdefault(k, {'status': 'mutation survivor', 'detail': 'rejected by the FL-41 sample check (tasks/fl41-mutation-log-sample.txt); not re-checked'})
        del corpus[k]
    for k in keep:
        pending.pop(k, None)
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    pending_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    test = PROJECT / 'tests/test_fl41_differential.py'
    t = test.read_text()
    for m in re.finditer(r"    def test_([0-9a-f]+)_lifted\(self\):\n        self\.check_row\('(0x[0-9a-f]+)', 'm[0-9a-f]+_lifted'\)\n\n?", t):
        pass
    t = re.sub(r"    def test_([0-9a-f]+)_lifted\(self\):\n        self\.check_row\('(0x[0-9a-f]+)', 'm[0-9a-f]+_lifted'\)\n\n?",
               lambda m: m.group(0) if m.group(2) in keep else '', t)
    test.write_text(t)
    print('kept %d rows, %d pending' % (len(corpus), len(pending)))


if __name__ == '__main__':
    main()
