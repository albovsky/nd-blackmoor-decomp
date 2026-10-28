"""bund.py ROW BUNDLEFILE OUT : bundleFile is python expr giving list of override-lists (each [[addr,size,val],..]); apply each to every known scenario; keep ones that add coverage"""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import time
key=sys.argv[1]; bundles=eval(open(sys.argv[2]).read()); out=sys.argv[3]
extra=sys.argv[4:] or [P+'/tasks/fl71-scenarios.json']
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=300000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed):
        ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(scen))
t0=time.time()
for b in bundles:
    for s,ov in scen:
        nov=[list(o) for o in ov]+[list(o) for o in b]
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,cov(G,row,ex,ed)[:4])
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[hex(x) for x in missing][:20],[(hex(a),n) for a,n in untaken],time.time()-t0)
json.dump({key:kept},open(out,'w'))
