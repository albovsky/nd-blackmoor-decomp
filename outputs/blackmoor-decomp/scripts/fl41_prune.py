#!/usr/bin/env python3
"""FL-41: take the rows whose mutation survivors are unexplained (tasks/fl41-survivors.json, from fl41_survivors.py) out of the translated set: their function
leaves src/original_methods_fl41.c, their entry leaves tests/fl41_corpus.json and their test leaves tests/test_fl41_differential.py; they are listed in
tests/fl41_pending.json with the reason. Run from outputs/blackmoor-decomp."""
import json
from pathlib import Path
import re

PROJECT = Path(__file__).resolve().parents[1]


def main():
    survivors = json.loads((PROJECT / 'tasks/fl41-survivors.json').read_text())
    unhardened = set(survivors.get('unhardened_rows', []))     # rows whose hardening run hit an emulator memory error: not checked to the standard, left for a later slice
    diverged = survivors.get('diverged_rows', {})                # rows where a seed added by the hardening run shows a difference between the translation and the original
    drop = set(survivors['unexplained_rows']) | unhardened | set(diverged)
    src = PROJECT / 'src/original_methods_fl41.c'
    text = src.read_text()
    parts = re.split(r'(?=/\* GAME\.EXE 0x[0-9a-f]+ \()', text)
    kept = [p for p in parts if not (re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', p) and re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', p).group(1) in drop)]
    src.write_text(''.join(kept))
    corpus_path = PROJECT / 'tests/fl41_corpus.json'
    corpus = json.loads(corpus_path.read_text())
    pending_path = PROJECT / 'tests/fl41_pending.json'
    pending = json.loads(pending_path.read_text())
    for k in sorted(drop & set(corpus)):
        if k in diverged:
            pending[k] = {'status': 'translation differs from the original', 'detail': diverged[k]}
            del corpus[k]
            continue
        if k in unhardened and k not in survivors['unexplained_rows']:
            pending[k] = {'status': 'mutation check incomplete', 'detail': 'the hardening run of the mutation check died with UC_ERR_NOMEM on this row (tasks/fl41-survivors.json, unhardened_rows)'}
            del corpus[k]
            continue
        pending[k] = {'status': 'mutation survivor', 'detail': 'a mutant of the translation survives the corpus and its statement is not one of the explained kinds (tasks/fl41-survivors.json)'}
        del corpus[k]
    corpus_path.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    pending_path.write_text(json.dumps(pending, indent=1, sort_keys=True) + '\n')
    test = PROJECT / 'tests/test_fl41_differential.py'
    t = test.read_text()
    for k in drop:
        t = re.sub(r"    def test_%x_lifted\(self\):\n        self\.check_row\('%s', 'm%x_lifted'\)\n\n" % (int(k, 16), k, int(k, 16)), '', t)
    test.write_text(t)
    print('pruned %d rows, %d remain' % (len(drop & set(json.loads(corpus_path.read_text())) ) or len(drop), len(corpus)))


if __name__ == '__main__':
    main()
