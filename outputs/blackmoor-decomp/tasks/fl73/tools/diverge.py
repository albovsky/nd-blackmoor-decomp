"""diverge.py ROW SCEN 'ADDR:size:val;..': first pc where the run with the cells set leaves the original run's path (first scenario)"""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn
key=sys.argv[1]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=200000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],[sys.argv[2]])
cells=[(int(x.split(':')[0],0),int(x.split(':')[1]),int(x.split(':')[2],0)) for x in sys.argv[3].split(';')]
def seq(s,ov):
    pcs=[]
    def watch(uc,ensure,trace,sp):
        uc.hook_add(unicorn.UC_HOOK_CODE,lambda u,a,sz,x: pcs.append(a))
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    return pcs
import os
REQ=int(os.environ.get('REQ','0'),0)
n=0
for s,ov in scen:
    a=seq(s,ov)
    if REQ and REQ not in a: continue
    n+=1
    if n>3: break
    nov=[list(o) for o in ov if not any(o[0]==c[0] for c in cells)]+[[c[0],c[1],c[2]] for c in cells]
    b=seq(s,nov)
    for i,(x,y) in enumerate(zip(a,b)):
        if x!=y:
            print(s,'diverge at step',i,hex(a[i-1]),'->',hex(x),'vs',hex(y)); break
    else: print(s,'same prefix',len(a),len(b))
