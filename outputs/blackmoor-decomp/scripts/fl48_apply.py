#!/usr/bin/env python3
"""FL-48: append the scenarios found by scripts/fl45_targeted.py (its --out JSON, run without --apply or interrupted before it) to tests/fl41_corpus.json, once.
   fl48_apply.py FOUND.json [FOUND.json ...]       (run from outputs/blackmoor-decomp)"""
import json
from pathlib import Path
import sys

PROJECT = Path(__file__).resolve().parents[1]
CORPUS = PROJECT / 'tests/fl41_corpus.json'


def main():
    corpus = json.loads(CORPUS.read_text())
    added = 0
    for path in sys.argv[1:]:
        for key, res in json.loads(Path(path).read_text()).items():
            have = {(sd, json.dumps(ov)) for sd, ov in corpus[key]['seeds']}
            for sd, ov, _ in res.get('found', []):
                if (sd, json.dumps(ov)) not in have:
                    corpus[key]['seeds'].append([sd, ov])
                    have.add((sd, json.dumps(ov)))
                    added += 1
    CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    print('added', added, 'scenarios')


if __name__ == '__main__':
    main()
