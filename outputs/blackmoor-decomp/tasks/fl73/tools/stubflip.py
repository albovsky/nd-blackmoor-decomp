"""stubflip.py ROW OUT SHARD/NSHARDS [scen..]: for every scenario and every callee stub index k that the run reaches, set the k-th stub's eax to each of 0,1,-1; keep coverage gains."""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
key=sys.argv[1]; out=sys.argv[2]; sh,nsh=[int(x) for x in sys.argv[3].split('/')]; extra=sys.argv[4:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for si,(s,ov) in enumerate(scen):
    if si%nsh!=sh: continue
    t0=run(W,row,s,ov)
    if t0.fault: continue
    nc=len(getattr(t0,'calls',[])) or 160
    for k in range(nc+1):
        for v in (0,1,0xffffffff):
            nov=[list(o) for o in ov if o[0]!=W.STUB_OVR+16*k]+[[W.STUB_OVR+16*k,4,v]]
            tr=run(W,row,s,nov)
            if tr.fault: continue
            if not (tr.executed<=ex and tr.edges<=ed):
                ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',si,k,hex(v),cov(G,row,ex,ed)[:4],flush=True)
    json.dump({key:kept},open(out,'w'))
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken][:60])
json.dump({key:kept},open(out,'w'))
