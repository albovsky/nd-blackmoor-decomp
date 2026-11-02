"""prove13.py ROW...: prove_row on the one untaken direction of each scenario-complete row (targets of triage13.py)"""
import sys, time
from pathlib import Path
PROJ = str(Path(__file__).resolve().parents[2])
sys.path.insert(0, PROJ + '/scripts'); sys.path.insert(0, PROJ + '/tasks/fl78')
import fl67_infeasible as P
from triage13 import T
T.update({'0x50eb20': [['0x50eba5', 'taken']]})
img = P.load_image()
for key in sys.argv[1:]:
    t0 = time.time()
    try:
        out = P.prove_row(key, {'missing': [], 'untaken': T[key]}, timeout_ms=40000, image=img)
        print(key, out['status'], out.get('reason', ''), {k: v[0] for k, v in out['directions'].items()}, round(time.time() - t0), flush=True)
    except Exception as e:
        print(key, 'error', type(e).__name__, e, round(time.time() - t0), flush=True)
