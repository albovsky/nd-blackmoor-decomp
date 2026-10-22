#!/usr/bin/env python3
"""FL-40: write the port acceptances of the rows in tests/fl40_corpus.json into function-ledger-overrides.json and tasks/fl40-acceptances.json.

  fl40_accept.py --reviewer "<text>" [--blockers-reviewed tasks/fl40-blockers.json]

An acceptance names the translation (`m<va>_lifted` in src/original_methods_fl40.c), the differential test of the row (tests/test_fl40_differential.py) and
the original-only oracle (tests/fl40_original_oracle.py) with the window [va, va + body size]. The rows are accepted as `native_oracle_verified`; the note says
what the symbol is (a machine translation over the 32-bit address space) so that the owner can drop the whole batch with one ruling. Existing acceptances are
left alone. Run from outputs/blackmoor-decomp.
"""
import argparse
import json
from pathlib import Path
import sys

PROJECT = Path(__file__).resolve().parents[1]
OVERRIDES = PROJECT / 'function-ledger-overrides.json'
CORPUS = PROJECT / 'tests/fl40_corpus.json'
DATE = '2026-10-22'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reviewer', required=True)
    ap.add_argument('--blockers-reviewed')
    a = ap.parse_args()
    corpus = json.loads(CORPUS.read_text())
    blockers = json.loads(Path(a.blockers_reviewed).read_text()) if a.blockers_reviewed else {}
    doc = json.loads(OVERRIDES.read_text())
    have = {e['va'] for e in doc['port_acceptances']}
    new = []
    for key in sorted(corpus, key=lambda k: int(k, 16)):
        if key in have:
            continue
        c = corpus[key]
        va = int(key, 16)
        entry = {'va': key, 'class': 'native_oracle_verified', 'reviewer': a.reviewer, 'date': DATE,
                 'native_source': {'path': 'src/original_methods_fl40.c', 'symbol': 'm%x_lifted' % va},
                 'tests': [{'path': 'tests/test_fl40_differential.py', 'test_id': 'Fl40Differential.test_%x_lifted' % va}],
                 'oracle': {'path': 'tests/fl40_original_oracle.py', 'window': [key, '0x%x' % (va + c['body'])]},
                 'parts_accounted': [],
                 'note': 'Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, %d seeds; oracle: %d/%d instructions '
                         'executed, %d/%d conditional-jump directions taken, callees as recording stubs.' % (
                             len(c['seeds']), c['instructions'][0], c['instructions'][1], c['directions'][0], c['directions'][1])}
        if key in blockers:
            entry['blockers_reviewed'] = blockers[key]
        new.append(entry)
    doc['port_acceptances'].extend(new)
    OVERRIDES.write_text(json.dumps(doc, indent=1, ensure_ascii=False) + '\n')
    (PROJECT / 'tasks/fl40-acceptances.json').write_text(json.dumps(new, indent=1, ensure_ascii=False) + '\n')
    print('added %d acceptances' % len(new))


if __name__ == '__main__':
    sys.exit(main())
