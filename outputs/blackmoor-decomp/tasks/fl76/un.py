"""un.py ROW OUT scen.. : merge scenario files, keep only coverage-adding ones, print untaken list brief"""
import sys; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key=sys.argv[1]; out=sys.argv[2]; files=sys.argv[3:]
pool,W,G,row=setup(key)

scen=F.known_scenarios(key,F.POOLS[pool]['world'],files)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print(key,got,total,taken,dirs,len(kept))
print('untaken',' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
