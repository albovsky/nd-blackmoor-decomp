#!/usr/bin/env python3
"""FL-45: merge the rows of a scripts/fl41_generate.py run (--out-dir DIR) into src/original_methods_fl41.c, tests/fl41_corpus.json and tests/test_fl41_differential.py,
and take them out of tests/fl41_pending.json. Rows already in the corpus are kept as they are. Run from outputs/blackmoor-decomp:   fl45_merge.py DIR"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_generate as G


def split(text):
    parts = re.split(r'(?=/\* GAME\.EXE 0x[0-9a-f]+ \()', text)
    return {m.group(1): p for p in parts for m in [re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', p)] if m}


def main():
    gen = Path(sys.argv[1])
    src = PROJECT / 'src/original_methods_fl41.c'
    have = split(src.read_text())
    new = split((gen / 'src/original_methods_fl41.c').read_text())
    corpus_path = PROJECT / 'tests/fl41_corpus.json'
    corpus = json.loads(corpus_path.read_text())
    new_corpus = json.loads((gen / 'tests/fl41_corpus.json').read_text())
    add = [k for k in new if k not in have and k in new_corpus and k != '0x50c920']
    for k in add:
        have[k] = new[k]
        corpus[k] = new_corpus[k]
    keys = sorted(have, key=lambda x: int(x, 16))
    header = src.read_text().split('/* GAME.EXE 0x', 1)[0]
    if '0x50c920' in new and 'FL41_CALL_LIFTED' in ''.join(have.values()) and '0x50c920' not in have:
        have['0x50c920'] = new['0x50c920']
    src.write_text(header + ''.join(have[k] for k in keys))
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    (PROJECT / 'tests/test_fl41_differential.py').write_text(G.test_source(sorted(int(k, 16) for k in corpus)))
    pend_path = PROJECT / 'tests/fl41_pending.json'
    pending = json.loads(pend_path.read_text())
    for k in add:
        pending.pop(k, None)
    pend_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    print('merged %d rows, corpus now %d' % (len(add), len(corpus)))


if __name__ == '__main__':
    main()
