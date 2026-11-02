#!/usr/bin/env python3
"""FL-78: prove_row on the missing items of tasks/fl66/rows/ROW.json (written by `fl66_tested.py check ROW`), with the traceback of a crash and the time per phase."""
import json, sys, time, traceback
from pathlib import Path
PROJECT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl67_infeasible as P
key = sys.argv[1]
res = json.loads((PROJECT / 'tasks/fl66/rows' / (key + '.json')).read_text())
t0 = time.time()
try:
    out = P.prove_row(key, {'missing': res['missing'], 'untaken': res['untaken']}, timeout_ms=40000, fail_fast=True)
    print(key, out['status'], out.get('reason'), {k: v[0] for k, v in list(out['instructions'].items()) + list(out['directions'].items())} if out['status'] != 'proved' else len(out['instructions']) + len(out['directions']), '%.0fs' % (time.time() - t0), flush=True)
except BaseException:
    traceback.print_exc()
