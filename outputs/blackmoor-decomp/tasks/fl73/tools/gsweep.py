"""gsweep.py ROW OUT 'ADDR:size:v1,v2;ADDR:size:...' [scen..]: for every scenario set the listed cells to every combination of the listed values; keep what adds coverage."""
import sys,itertools; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
key=sys.argv[1]; out=sys.argv[2]; spec=sys.argv[3]; extra=sys.argv[4:]
cells=[]
for part in spec.split(';'):
    a,n,vs=part.split(':'); cells.append((int(a,0),int(n),[int(v,0) for v in vs.split(',')]))
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
import os
ZR=[tuple(int(x,0) for x in z.split(':')) for z in os.environ.get('ZR','').split(',') if z]
if ZR:
    nsc=[]
    for s,ov in scen:
        for (zb,zn) in ZR:
            ov=[o for o in ov if not (zb<=o[0]<zb+4*zn)]+[[zb+4*i,4,0] for i in range(zn)]
        nsc.append((s,ov))
    scen=nsc
REQ=[int(x,0) for x in os.environ.get('REQ','').split(',') if x]
if REQ:
    scen=[(s,ov) for s,ov in scen if (lambda t:(not t.fault) and all(p in t.executed for p in REQ))(run(W,row,s,ov))]
    print('scenarios reaching',len(scen),flush=True)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    combos=list(itertools.product(*[c[2] for c in cells]))
    SM=int(os.environ.get('SAMPLE','0'))
    if SM and len(combos)>SM:
        import random; combos=random.Random(1).sample(combos,SM)
    for combo in combos:
        nov=[list(o) for o in ov if not any(o[0]==c[0] for c in cells)]+[[c[0],c[1],v] for c,v in zip(cells,combo)]
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,combo,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken][:40])
json.dump({key:kept},open(out,'w'))
