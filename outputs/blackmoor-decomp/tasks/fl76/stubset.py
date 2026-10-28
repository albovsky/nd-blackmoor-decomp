"""stubset.py ROW OUT 'SPEC' [scenfile..]: SPEC is a python list of steps applied in order to every known scenario (hit index recomputed after each step, so a step never sits on a shifted callee):
  ('g', addr, size, val)               global cell override (first, replaces an earlier one at addr)
  ('wr', callpc, target, val)          the first hit of callpc also stores val (dword) at target
  ('ret', callpc, slot, val)           the first hit of callpc returns val in slot 0=eax 1=ecx 2=edx
  ('wrn', callpc, nth, target, val)    like wr, nth hit
  ('retn', callpc, nth, slot, val)     like ret, nth hit
Scenarios whose run does not hit a callpc skip the remaining steps (the run is still tried). Keeps scenarios that add coverage; prints untaken."""
import sys; sys.path.insert(0, '/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
key = sys.argv[1]; out = sys.argv[2]; spec = eval(sys.argv[3]); files = sys.argv[4:]
pool, W, G, row = setup(key)

scen = F.known_scenarios(key, F.POOLS[pool]['world'], files)
import os
if os.environ.get('SEEDS'):
    a, b = os.environ['SEEDS'].split('-'); scen = [(i, []) for i in range(int(a), int(b))]
ex = set(); ed = set(); kept = []
for s, ov in scen:
    tr = run(W, row, s, ov) if not os.environ.get('SEEDS') else None
    if tr is None or tr.fault: continue
    if not (tr.executed <= ex and tr.edges <= ed):
        ex |= tr.executed; ed |= tr.edges; kept.append([s, [list(o) for o in ov]])
print('base', cov(G, row, ex, ed)[:4], len(kept), flush=True)
def hit_index(s, nov, pc, nth):
    hits = []
    def watch(uc, ensure, trace, sp):
        def h(uc_, a, sz, u): hits.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE, h, begin=pc, end=pc)
    W.run_original(row, s, [tuple(o) for o in nov], watch=watch)
    gc.collect()
    return hits[nth] if len(hits) > nth else None
for s, ov in scen:
    nov = [list(o) for o in ov if os.environ.get('KEEP') or not (W.STUB_OVR <= o[0] < W.STUB_OVR + 0x10000 or W.STUB_WR <= o[0] < W.STUB_WR + 0x10000)]
    for st in spec:
        if st[0] == 'g':
            nov = [o for o in nov if o[0] != st[1]] + [[st[1], st[2], st[3]]]
    for st in spec:
        if st[0] == 'g': continue
        if st[0] in ('wr', 'ret'): pc, nth, rest = st[1], 0, st[2:]
        else: pc, nth, rest = st[1], st[2], st[3:]
        k = hit_index(s, nov, pc, nth)
        if k is None: break
        if st[0] in ('wr', 'wrn'):
            nov = nov + [[W.STUB_WR + 16 * k, 4, rest[0]], [W.STUB_WR + 16 * k + 4, 4, rest[1]]]
        else:
            nov = nov + [[W.STUB_OVR + 16 * k + 4 * rest[0], 4, rest[1]]]
    tr = run(W, row, s, nov); gc.collect()
    if tr.fault: continue
    if not (tr.executed <= ex and tr.edges <= ed):
        ex |= tr.executed; ed |= tr.edges; kept.append([s, nov]); print('new', s, cov(G, row, ex, ed)[:4], flush=True)
got, total, taken, dirs, missing, untaken = cov(G, row, ex, ed)
print('final', got, total, taken, dirs, [hex(x) for x in missing][:20])
print('untaken', ' '.join('%x%s' % (a, 'T' if n == 'taken' else 'F') for a, n in untaken))
json.dump({key: kept}, open(out, 'w'))
