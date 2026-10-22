#!/usr/bin/env python3
"""FL-42: merge the output of scripts/fl40_generate.py --out-dir DIR (rows that are now complete) into the committed FL-40 files:
src/original_methods_fl40.c, tests/fl40_corpus.json, tests/test_fl40_differential.py (regenerated for every corpus row) and tests/fl40_pending.json.

  fl42_merge.py DIR [DIR ...]      (run from outputs/blackmoor-decomp)
"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_generate as G
import fl40_mutation_check as M


def main():
    src_path = PROJECT / 'src/original_methods_fl40.c'
    corpus_path = PROJECT / 'tests/fl40_corpus.json'
    pending_path = PROJECT / 'tests/fl40_pending.json'
    text = src_path.read_text()
    corpus = json.loads(corpus_path.read_text())
    pending = json.loads(pending_path.read_text())
    added = []
    for d in sys.argv[1:]:
        d = Path(d)
        new_corpus = json.loads((d / 'tests/fl40_corpus.json').read_text())
        funcs = M.split_functions((d / 'src/original_methods_fl40.c').read_text())
        new_pending = json.loads((d / 'tests/fl40_pending.json').read_text())
        for key, entry in new_corpus.items():
            if key in corpus:
                continue
            corpus[key] = entry
            text = text.rstrip('\n') + '\n' + funcs[key].rstrip('\n') + '\n'
            pending.pop(key, None)
            added.append(key)
        for key, entry in new_pending.items():
            if key in pending and key not in corpus:
                pending[key] = entry
    src_path.write_text(text)
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    pending_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    (PROJECT / 'tests/test_fl40_differential.py').write_text(G.test_source(sorted((int(k, 16) for k in corpus))))
    print('added %d rows: %s' % (len(added), ' '.join(added)))


if __name__ == '__main__':
    main()
