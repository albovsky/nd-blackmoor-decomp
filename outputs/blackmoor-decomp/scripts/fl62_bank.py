#!/usr/bin/env python3
"""FL-62: settle the rows that scripts/fl62_add_rows.py put into the corpus: the clean ones become credited candidates, every other one goes back to "translated, unverified".

  fl62_bank.py --clean ROW,ROW,... --added tasks/fl62-added-batch1.json [--added ...] [--keep-file tasks/fl62-covered-rows.json]      (run from outputs/blackmoor-decomp)

- a row of the added lists that is not clean leaves tests/fl41_corpus.json, src/original_methods_fl41.c and tests/test_fl41_differential.py; its corpus entry (the scenarios that give it full coverage) is saved in
  --keep-file, so that a later round can start from complete coverage
- a clean row leaves tests/fl41_translated.json and translated/original_methods_fl41_translated.c (a credited row is not repeated there; tests/test_fl55_translated.py fails otherwise)
scripts/fl41_accept.py then writes the acceptances of the rows that are left in the corpus.
"""
import argparse
import fcntl
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_generate as G
from fl45_merge import split

SOURCE = PROJECT / 'src/original_methods_fl41.c'
CORPUS = PROJECT / 'tests/fl41_corpus.json'
TABLE = PROJECT / 'tests/fl41_translated.json'
TRANSLATED = PROJECT / 'translated/original_methods_fl41_translated.c'
TEST = PROJECT / 'tests/test_fl41_differential.py'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--clean', required=True)
    ap.add_argument('--added', action='append', required=True)
    ap.add_argument('--keep-file', default='tasks/fl62-covered-rows.json')
    a = ap.parse_args()
    clean = set(a.clean.split(','))
    added = []
    for f in a.added:
        added += json.loads(Path(f).read_text())['added']
    back = [k for k in added if k not in clean]
    unknown = clean - set(added)
    if unknown:
        sys.exit('clean rows that this thread did not add: %s' % sorted(unknown))
    with open(str(CORPUS) + '.lock', 'w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        corpus = json.loads(CORPUS.read_text())
        keep_path = PROJECT / a.keep_file
        kept = json.loads(keep_path.read_text()) if keep_path.exists() else {}
        for k in back:
            if k in corpus:
                kept[k] = corpus.pop(k)
        keep_path.write_text(json.dumps(kept, indent=1, sort_keys=True) + '\n')
        text = SOURCE.read_text()
        have = split(text)
        header = text.split('/* GAME.EXE 0x', 1)[0]
        for k in back:
            have.pop(k, None)
        keys = sorted((k for k in have if k != '0x50c920'), key=lambda x: int(x, 16))
        order = (['0x50c920'] if '0x50c920' in have else []) + keys
        SOURCE.write_text(header + ''.join(have[k] for k in order))
        CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
        TEST.write_text(G.test_source(sorted(int(k, 16) for k in corpus)))
    table = json.loads(TABLE.read_text())
    for k in clean:
        table.pop(k, None)
    TABLE.write_text(json.dumps(table, indent=1, sort_keys=True) + '\n')
    t = TRANSLATED.read_text()
    parts = re.split(r'(?=/\* GAME\.EXE 0x[0-9a-f]+ \()', t)
    out = [p for p in parts if not any(p.startswith('/* GAME.EXE %s (' % k) for k in clean)]
    TRANSLATED.write_text(''.join(out))
    print('back to translated: %d, credited candidates: %d, translated table now %d rows' % (len(back), len(clean), len(table)))


if __name__ == '__main__':
    main()
