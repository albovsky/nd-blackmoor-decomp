"""fz4e81.py OUT NRUNS RSEED [scen..]: structured fuzz for 0x4e812f: [0x583a2b]=N entries (words at 0x583a31) are record indexes; record type words at this+idx*0x16d+0x77e."""
import sys,json,random; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x4e812f'; out=sys.argv[1]; nruns=int(sys.argv[2]); R=random.Random(int(sys.argv[3])); files=sys.argv[4:]
pool,W,G,row=setup(key)
scen=F.known_scenarios(key,F.POOLS[pool]['world'],files)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
thisof={}
for s in sorted({s for s,_ in scen})[:12]:
    tr=run(W,row,s,[],observe=True); gc.collect()
    t=[a-0x822e for (a,n,v,wc),p in zip(tr.reads,tr.read_pcs) if p==0x4e815f]
    if t: thisof[s]=t[0]
print(thisof,flush=True)
for it in range(nruns):
    s=R.choice(list(thisof)); t=thisof[s]
    N=R.choice([1,2,3,5,8,16,17,18,20,33,40,60])
    nidx=R.choice([2,3,4])
    ov=[[0x583a2b,2,N],[t+0x8232,4,R.choice([0x65,0x66,0x67,0x68,0x69,0x6a,0])]]
    for i in range(N):
        ov.append([0x583a31+2*i,2,R.randrange(nidx)])
    for k in range(nidx):
        ov.append([t+k*0x16d+0x77e,2,R.choice([0,1,2,3,3,3,4])])
    tr=run(W,row,s,ov); gc.collect()
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed):
        ex|=tr.executed;ed|=tr.edges;kept.append([s,ov]);print('new',it,s,N,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[hex(x) for x in missing][:10])
print('untaken',' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
