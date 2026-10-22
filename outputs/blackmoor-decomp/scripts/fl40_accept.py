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


def recorded_windows():
    """window of the fl40 oracle per row, from function-evidence.json (empty before the first evidence run)"""
    out = {}
    path = PROJECT / 'function-evidence.json'
    if not path.is_file():
        return out
    for f in json.loads(path.read_text())['functions']:
        for p in f['evidence']:
            if p['kind'] == 'oracle' and (p['path'] or '').endswith('tests/fl40_original_oracle.py') and p['window'][0] == f['va']:
                out[f['va']] = p['window']
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reviewer', required=True)
    ap.add_argument('--blockers-reviewed')
    a = ap.parse_args()
    corpus = json.loads(CORPUS.read_text())
    blockers = json.loads(Path(a.blockers_reviewed).read_text()) if a.blockers_reviewed else {}
    doc = json.loads(OVERRIDES.read_text())
    have = {e['va'] for e in doc['port_acceptances']}
    held = set(json.loads((PROJECT / 'tasks/fl40-held-rows.json').read_text())['rows']) if (PROJECT / 'tasks/fl40-held-rows.json').is_file() else set()
    doc['port_acceptances'] = [e for e in doc['port_acceptances']
                               if not ((e.get('oracle') or {}).get('path') == 'tests/fl40_original_oracle.py' and e['va'] in held)]
    have = {e['va'] for e in doc['port_acceptances']}
    windows = recorded_windows()
    # the window is the one the recorded run saw: the end of the function's span (alignment padding included), not va + translated body
    for e in doc['port_acceptances']:
        if (e.get('oracle') or {}).get('path') == 'tests/fl40_original_oracle.py' and e['va'] in windows:
            e['note'] = e['note'].replace('Machine translation of the original instructions', 'Machine-translated from the original instructions')
            e['oracle']['window'] = windows[e['va']]
            if e['va'] in blockers:
                e['blockers_reviewed'] = blockers[e['va']]
    new = []
    for key in sorted(corpus, key=lambda k: int(k, 16)):
        if key in have or key in held:
            continue
        c = corpus[key]
        va = int(key, 16)
        entry = {'va': key, 'class': 'native_oracle_verified', 'reviewer': a.reviewer, 'date': DATE,
                 'native_source': {'path': 'src/original_methods_fl40.c', 'symbol': 'm%x_lifted' % va},
                 'tests': [{'path': 'tests/test_fl40_differential.py', 'test_id': 'Fl40Differential.test_%x_lifted' % va}],
                 'oracle': {'path': 'tests/fl40_original_oracle.py', 'window': windows.get(key, [key, '0x%x' % (va + c['body'])])},
                 'parts_accounted': [],
                 'note': 'Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, %d seeds; oracle: %d/%d instructions '
                         'executed, %d/%d conditional-jump directions taken, callees as recording stubs.' % (
                             len(c['seeds']), c['instructions'][0], c['instructions'][1], c['directions'][0], c['directions'][1])}
        if key in blockers:
            entry['blockers_reviewed'] = blockers[key]
        new.append(entry)
    doc['port_acceptances'].extend(new)
    OVERRIDES.write_text(json.dumps(doc, indent=1, ensure_ascii=False) + '\n')
    mine = [e for e in doc['port_acceptances'] if (e.get('oracle') or {}).get('path') == 'tests/fl40_original_oracle.py']
    (PROJECT / 'tasks/fl40-acceptances.json').write_text(json.dumps(mine, indent=1, ensure_ascii=False) + '\n')
    print('added %d acceptances' % len(new))


if __name__ == '__main__':
    sys.exit(main())
