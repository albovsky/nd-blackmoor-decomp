#!/usr/bin/env python3
"""FL-47: put the rows of tasks/fl45-hang-dependent-rows.json back into src/original_methods_fl41.c, tests/fl41_corpus.json and tests/test_fl41_differential.py (and out of tests/fl41_pending.json).
Glib ruled on 2026-10-23 that a mutant which does not terminate counts as killed under a fixed step budget; the rows are credited only after the step-budget rerun
(FL45_STRICT_HANG) kills or explains every hang-listed mutant.   fl47_restore.py [--rows 0x48a70a,...]       (run from outputs/blackmoor-decomp)"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_generate as G
from fl45_merge import split


def main():
    only = sys.argv[sys.argv.index('--rows') + 1].split(',') if '--rows' in sys.argv else None
    held = json.loads((PROJECT / 'tasks/fl45-hang-dependent-rows.json').read_text())['rows']
    src = PROJECT / 'src/original_methods_fl41.c'
    have = split(src.read_text())
    corpus_path = PROJECT / 'tests/fl41_corpus.json'
    corpus = json.loads(corpus_path.read_text())
    pend_path = PROJECT / 'tests/fl41_pending.json'
    pending = json.loads(pend_path.read_text())
    add = [k for k in held if (only is None or k in only) and k not in have]
    for k in add:
        have[k] = held[k]['c_source']
        corpus[k] = held[k]['corpus']
        pending.pop(k, None)
    keys = sorted(have, key=lambda x: int(x, 16))
    header = src.read_text().split('/* GAME.EXE 0x', 1)[0]
    src.write_text(header + ''.join(have[k] for k in keys))
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    pend_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    (PROJECT / 'tests/test_fl41_differential.py').write_text(G.test_source(sorted(int(k, 16) for k in corpus)))
    print('restored %d rows, corpus now %d' % (len(add), len(corpus)))


if __name__ == '__main__':
    main()
