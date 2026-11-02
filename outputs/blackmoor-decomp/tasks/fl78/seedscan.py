"""seedscan.py ROW OUT PARENTS.json SEEDS(a-b) 'RECIPE' [REQPC]: parents' overrides kept, seed varied; recipe applied (pipe steps); keep coverage adders.
Parents are reduced to one per distinct executed-set signature that executes REQPC (if given)."""
import sys,json,os
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl77')
from drv import *
import pipe
_P0=0x20000000
P0,P1,P2,P3,P4,P5,P6,P7=[_P0+0x10000*i for i in range(8)]
_r=sys.argv[5]
key,out,pf,rng_,recipe=sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],eval(open(_r[1:]).read() if _r.startswith('@') else _r)
req=int(sys.argv[6],16) if len(sys.argv)>6 else None
pool,W,G,row=setup(key)
if os.environ.get('LIM'): W.INSTRUCTION_LIMIT=int(os.environ['LIM'])
parents=json.load(open(pf))[key]
a,b=(0,1) if rng_=='same' else map(int,rng_.split('-'))
ex=set();ed=set();kept=[]
for s,ov in parents:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    ex|=tr.executed;ed|=tr.edges
print('base',cov(G,row,ex,ed)[:4],flush=True)
ex=set();ed=set()
for s,ov in parents:
    if req:
        tr=run(W,row,s,ov)
        if tr.fault or req not in tr.executed: continue
    for sd in ([s] if rng_=='same' else range(a,b)):
        for rec in (recipe if recipe and isinstance(recipe[0],list) else [recipe]):
            nov=pipe.apply_recipe(W,row,sd,ov,rec)
            if nov is None: continue
            tr=run(W,row,sd,nov); gc.collect()
            if tr.fault: continue
            if not (tr.executed<=ex and tr.edges<=ed):
                ex|=tr.executed;ed|=tr.edges;kept.append([sd,nov]);print('new',sd,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
