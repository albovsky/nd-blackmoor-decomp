import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
key='0x43a7ca'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],sys.argv[2:])
pcs=[int(x,0) for x in sys.argv[1].split(',')]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if all(p in tr.executed for p in pcs[:1]):
        print(s,[hex(p) for p in pcs if p in tr.executed],[ (hex(a),n,v) for a,n,v in ov if a<0x600000 and a>0x580000][:14])
