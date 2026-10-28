"""bigstr.py ROW OUT CALLPC NPAGES [scen..]: at the first hit of CALLPC make the callee return a pointer to NPAGES pages of non-zero bytes."""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn
key=sys.argv[1]; out=sys.argv[2]; callpc=int(sys.argv[3],0); NP=int(sys.argv[4]); extra=sys.argv[5:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
P=0x20400000
fill=int.from_bytes(b'A'*1024,'little')
for s,ov in scen:
    hits=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): hits.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=callpc,end=callpc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if not hits: continue
    k=hits[0]
    nov=[list(o) for o in ov if o[0] not in (W.STUB_OVR+16*k,)]
    nov+=[[W.STUB_OVR+16*k,4,P]]+[[P+0x400*i,1024,fill] for i in range(NP*4)]
    tr=run(W,row,s,nov)
    if tr.fault: print('fault',tr.fault); continue
    if not (tr.executed<=ex and tr.edges<=ed):
        ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,k,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs)
json.dump({key:kept},open(out,'w'))
