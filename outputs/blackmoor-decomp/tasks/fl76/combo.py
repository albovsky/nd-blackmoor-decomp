"""combo.py ROW OUT 'EXPR' [scenfile..]: EXPR is a python list of override-lists [[addr,size,val],..];
every known scenario is run with each combo appended (a combo cell replaces an earlier override of the same address); scenarios that add coverage are kept.
Prints the untaken list afterwards. Instruction limit 200000 like fl66."""
import sys; sys.path.insert(0, '/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key = sys.argv[1]; out = sys.argv[2]; combos = eval(sys.argv[3]); files = sys.argv[4:]
pool, W, G, row = setup(key)

scen = F.known_scenarios(key, F.POOLS[pool]['world'], files)
ex = set(); ed = set(); kept = []
for s, ov in scen:
    tr = run(W, row, s, ov)
    if tr.fault: continue
    if not (tr.executed <= ex and tr.edges <= ed):
        ex |= tr.executed; ed |= tr.edges; kept.append([s, [list(o) for o in ov]])
print('base', cov(G, row, ex, ed)[:4])
for s, ov in scen:
    for c in combos:
        addrs = {o[0] for o in c}
        nov = [list(o) for o in ov if o[0] not in addrs] + [list(o) for o in c]
        tr = run(W, row, s, nov)
        gc.collect()
        if tr.fault: continue
        if not (tr.executed <= ex and tr.edges <= ed):
            ex |= tr.executed; ed |= tr.edges; kept.append([s, nov])
            print('new', s, cov(G, row, ex, ed)[:4])
got, total, taken, dirs, missing, untaken = cov(G, row, ex, ed)
print('final', got, total, taken, dirs, [hex(x) for x in missing][:20], ' '.join('%x%s' % (a, 'T' if n == 'taken' else 'F') for a, n in untaken))
json.dump({key: kept}, open(out, 'w'))
