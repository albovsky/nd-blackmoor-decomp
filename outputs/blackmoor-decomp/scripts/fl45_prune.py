#!/usr/bin/env python3
"""FL-45: keep in src/original_methods_fl41.c, tests/fl41_corpus.json and tests/test_fl41_differential.py the rows that were credited before this slice plus the rows whose mutation
survivors are all explained in tasks/fl45-survivors.json (rows_with_survivors with no unexplained item, and rows of the final log without any survivor); every other row of the corpus goes
back to tests/fl41_pending.json. Run from outputs/blackmoor-decomp:   fl45_prune.py <merged mutation log> <survivors json> <credited-before json (list of rows)>"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]


def main():
    log, surv_path, before_path = sys.argv[1:4]
    surv = json.loads(Path(surv_path).read_text())
    before = set(json.loads(Path(before_path).read_text()))
    checked = {l.split()[0] for l in Path(log).read_text().split('\n') if re.match(r'^0x[0-9a-f]+ mutants \d+', l)}
    keep = before | {r for r in checked if r not in set(surv['unexplained_rows'])}
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
            pending[k] = {'status': 'mutation survivor', 'detail': 'FL-45 exhaustive check (tasks/fl45-mutation-log-final.txt, tasks/fl45-survivors.json): a surviving mutant is neither identical -O2 code nor a proven no-op'}
        elif k in checked:
            pending[k] = {'status': 'mutation survivor', 'detail': 'FL-45 check incomplete for this row'}
        else:
            pending[k] = {'status': 'mutation check not run', 'detail': 'translated and agreeing with the original on a full-coverage corpus (FL-45 pool); the exhaustive mutation check has not been run on it yet'}
        del corpus[k]
    for k in keep:
        pending.pop(k, None)
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    pending_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    test = PROJECT / 'tests/test_fl41_differential.py'
    t = re.sub(r"    def test_([0-9a-f]+)_lifted\(self\):\n        self\.check_row\('(0x[0-9a-f]+)', 'm[0-9a-f]+_lifted'\)\n\n?",
               lambda m: m.group(0) if m.group(2) in keep else '', test.read_text())
    test.write_text(t)
    print('kept %d rows (%d credited before), %d pending' % (len(corpus), len(before), len(pending)))


if __name__ == '__main__':
    main()
