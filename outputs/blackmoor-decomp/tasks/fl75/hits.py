"""hits.py ROW PC.. : for each known scenario print whether each PC ran, and the untaken list"""
import sys; sys.path.insert(0,'tasks/fl73/tools')
from drv import *
key=sys.argv[1]; pcs=[int(x,0) for x in sys.argv[2:]]
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=200000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],[])
for s,ov in scen:
    tr=run(W,row,s,ov)
    print(s,ov[:4],'fault' if tr.fault else '',[hex(p) for p in pcs if p in tr.executed], len(tr.calls))
