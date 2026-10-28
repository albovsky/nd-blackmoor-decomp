"""miss.py ROW scen..: run all scenarios, list missing instruction addresses (grouped) and untaken directions"""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
key=sys.argv[1]; files=sys.argv[2:]
pool,W,G,row=setup(key)
scen=F.known_scenarios(key,F.POOLS[pool]['world'],files)
ex=set();ed=set()
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    ex|=tr.executed;ed|=tr.edges
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print(got,total,taken,dirs)
print('missing',' '.join(hex(x) for x in sorted(missing)))
print('untaken',' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
