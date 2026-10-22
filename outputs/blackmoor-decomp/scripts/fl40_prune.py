#!/usr/bin/env python3
"""FL-40: take the rows whose mutation survivors are unexplained (tasks/fl40-survivors.json, from fl40_survivors.py) out of the translated set: their function
leaves src/original_methods_fl40.c, their entry leaves tests/fl40_corpus.json and their test leaves tests/test_fl40_differential.py; they are listed in
tests/fl40_pending.json with the reason. Run from outputs/blackmoor-decomp."""
import json
from pathlib import Path
import re

PROJECT = Path(__file__).resolve().parents[1]


def main():
    drop = set(json.loads((PROJECT / 'tasks/fl40-survivors.json').read_text())['unexplained_rows'])
    src = PROJECT / 'src/original_methods_fl40.c'
    text = src.read_text()
    parts = re.split(r'(?=/\* GAME\.EXE 0x[0-9a-f]+ \()', text)
    kept = [p for p in parts if not (re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', p) and re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', p).group(1) in drop)]
    src.write_text(''.join(kept))
    corpus_path = PROJECT / 'tests/fl40_corpus.json'
    corpus = json.loads(corpus_path.read_text())
    pending_path = PROJECT / 'tests/fl40_pending.json'
    pending = json.loads(pending_path.read_text())
    for k in sorted(drop & set(corpus)):
        pending[k] = {'status': 'mutation survivor', 'detail': 'a mutant of the translation survives the corpus and its statement is not one of the explained kinds (tasks/fl40-survivors.json)'}
        del corpus[k]
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    pending_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    test = PROJECT / 'tests/test_fl40_differential.py'
    t = test.read_text()
    for k in drop:
        t = re.sub(r"    def test_%x_lifted\(self\):\n        self\.check_row\('%s', 'm%x_lifted'\)\n\n" % (int(k, 16), k, int(k, 16)), '', t)
    test.write_text(t)
    print('pruned %d rows, %d remain' % (len(drop & set(json.loads(corpus_path.read_text())) ) or len(drop), len(corpus)))


if __name__ == '__main__':
    main()
