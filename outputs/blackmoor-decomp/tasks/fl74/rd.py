"""rd.py ROW PC scen..: for each scenario that reaches PC, print the cells read at PC and whether written earlier"""
import sys; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key=sys.argv[1]; pc=int(sys.argv[2],16); extra=sys.argv[3:]
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=200000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
n=0
for s,ov in scen:
    tr=run(W,row,s,ov,observe=True)
    if tr.fault or pc not in tr.executed: continue
    rs=[(hex(a),sz,hex(v)) for (a,sz,v,wc),p in zip(tr.reads,tr.read_pcs) if p==pc]
    ws=set()
    for a,sz,v in tr.writes: ws.update(range(a,a+sz))
    print(s,rs[:4],[any(b in ws for b in range(int(a,16),int(a,16)+sz)) for a,sz,v in rs[:4]])
    n+=1
    if n>=6: break
