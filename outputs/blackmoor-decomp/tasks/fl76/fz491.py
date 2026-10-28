import sys,json; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x491db2'; out=sys.argv[1]; files=sys.argv[2:]
pool,W,G,row=setup(key)
scen=F.known_scenarios(key,F.POOLS[pool]['world'],files)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
Z=0x600000
for s in range(0,60):
    tr=run(W,row,s,[],observe=True); gc.collect()
    th=[a-0x1f67 for (a,n,v,wc),p in zip(tr.reads,tr.read_pcs) if p==0x491e4d]
    if not th: continue
    t=th[0]
    for v in (0,1,2):
        ov=[[t+0x1f67,4,Z],[t+0x1f47,4,0x610000],[t+0x1f53,4,0x620000],[0x620000,4,v],[t+0x47ad,4,0],[t+0x45ad,4,0]]
        tr=run(W,row,s,ov); gc.collect()
        if tr.fault: print(s,v,'fault',tr.fault); continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,ov]);print('new',s,v,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[hex(x) for x in missing][:10],' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
