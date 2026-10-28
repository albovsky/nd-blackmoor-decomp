import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
key=sys.argv[1]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=200000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],[sys.argv[2]])
cells=[(int(x.split(':')[0],0),int(x.split(':')[1]),int(x.split(':')[2],0)) for x in sys.argv[4].split(';')]
pcs=[int(x,0) for x in sys.argv[3].split(',')]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault or pcs[0] not in tr.executed: continue
    nov=[list(o) for o in ov if not any(o[0]==c[0] for c in cells)]+[[c[0],c[1],c[2]] for c in cells]
    t2=run(W,row,s,nov)
    print(s,t2.fault,[hex(p) for p in pcs if p in t2.executed])
