#!/usr/bin/env python3
"""FL-52: put rows of another checkout's working set (its src/original_methods_fl41.c and tests/fl41_corpus.json, which hold the rows with their killing scenarios) into this checkout's translated set,
the way scripts/fl45_merge.py does for a generator run, and take them out of tests/fl41_pending.json.
  fl52_restore.py OTHER_PROJECT_DIR ROW [ROW ...]      (run from outputs/blackmoor-decomp)"""
import json
from pathlib import Path
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_generate as G
from fl45_merge import split


def main():
    other = Path(sys.argv[1])
    rows = sys.argv[2:]
    src = PROJECT / 'src/original_methods_fl41.c'
    have = split(src.read_text())
    new = split((other / 'src/original_methods_fl41.c').read_text())
    corpus_path = PROJECT / 'tests/fl41_corpus.json'
    corpus = json.loads(corpus_path.read_text())
    new_corpus = json.loads((other / 'tests/fl41_corpus.json').read_text())
    for k in rows:
        have[k] = new[k]
        corpus[k] = new_corpus[k]
    keys = sorted(have, key=lambda x: int(x, 16))
    header = src.read_text().split('/* GAME.EXE 0x', 1)[0]
    src.write_text(header + ''.join(have[k] for k in keys))
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    (PROJECT / 'tests/test_fl41_differential.py').write_text(G.test_source(sorted(int(k, 16) for k in corpus)))
    pend_path = PROJECT / 'tests/fl41_pending.json'
    pending = json.loads(pend_path.read_text())
    for k in rows:
        pending.pop(k, None)
    pend_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    print('restored %d rows, corpus now %d' % (len(rows), len(corpus)))


if __name__ == '__main__':
    main()
