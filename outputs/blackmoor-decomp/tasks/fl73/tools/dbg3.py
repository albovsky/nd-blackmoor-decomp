import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
key='0x43a7ca'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],sys.argv[1:])
cells=[0x58321d,0x583215,0x583216,0x583213,0x583214,0x58321e,0x583227,0x583228,0x583225,0x583226]
n=0
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault or 0x43c88d not in tr.executed: continue
    nov=[list(o) for o in ov if o[0] not in cells]+[[c,1,0] for c in cells]
    t2=run(W,row,s,nov)
    print(t2.fault,[hex(p) for p in (0x43c88d,0x43c8c7,0x43c8dd,0x43c8f4,0x43c900,0x43c90b,0x43c915,0x43c917,0x43c92d) if p in t2.executed], [ (hex(w[0]),w[2]) for w in t2.writes if 0x583200<=w[0]<0x583240])
    n+=1
    if n>3: break
