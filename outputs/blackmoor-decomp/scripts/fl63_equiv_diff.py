#!/usr/bin/env python3
"""FL-63: which instructions does the fl43_equiv.py string-op fix newly prove (`movsx` no longer ends the facts about memory)? Runs `prove` over every instruction of every row of tests/fl41_corpus.json
with the old test (mnemonic starts with a string-op prefix) and the new one, as scripts/fl41_survivors.py calls it, and prints the rows and addresses that only the new test proves.

  fl63_equiv_diff.py [ROW ...]      (run from outputs/blackmoor-decomp)
"""
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl43_equiv as E
import fl45_ranges as RG

corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
new_test = E.is_string_op
old_test = lambda m: m.startswith(E.STRING_OPS)
out = {}
for key in (sys.argv[1:] or sorted(corpus, key=lambda k: int(k, 16))):
    va, body = int(key, 16), corpus[key]['body']
    try:
        ranges = RG.Ranges(va, body)
    except E.NoProof:
        ranges = None
    res = {}
    for name, test in (('old', old_test), ('new', new_test)):
        E.is_string_op = test
        try:
            f = E.Function(va, body, ranges.feasible if ranges else None, exposed_ok=True)
            addrs = sorted(f.at)
            res[name] = E.prove(va, body, addrs, ranges.feasible if ranges else None, RG.TableFunction if ranges else None, exposed_ok=True)
        except E.NoProof:
            res[name] = {}
    gained = sorted(a for a, r in res['new'].items() if r and not res['old'].get(a))
    lost = sorted(a for a, r in res['old'].items() if r and not res['new'].get(a))
    if gained or lost:
        out[key] = {'gained': [hex(a) for a in gained], 'lost': [hex(a) for a in lost]}
        print(key, 'gained', [hex(a) for a in gained], 'LOST', [hex(a) for a in lost], flush=True)
print('rows with a change:', len(out))
Path('tasks/fl63/equiv-diff.json').write_text(json.dumps(out, indent=1))
