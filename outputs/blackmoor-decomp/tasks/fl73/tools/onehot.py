"""onehot.py ROW OUT PC_FIRST PC_LAST NCALLS [scen..]: for every scenario set the eax return of NCALLS consecutive callee stubs (first stub index = number of calls seen at the instruction PC_FIRST) to every one-hot (and all-zero) pattern; keep what adds coverage."""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn
key=sys.argv[1]; out=sys.argv[2]; pcf=int(sys.argv[3],16); n=int(sys.argv[5]); extra=sys.argv[6:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept))
for s,ov in scen:
    idx=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): idx.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pcf,end=pcf)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if t0.fault or not idx: continue
    i0=idx[0]
    for pat in range(1<<n) if n<=4 else [0]+[1<<j for j in range(n)]:
        nov=[list(o) for o in ov if not any(W.STUB_OVR+16*(i0+j)==o[0] for j in range(n))]
        for j in range(n): nov.append([W.STUB_OVR+16*(i0+j),4,(pat>>j)&1])
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,i0,pat,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs)
json.dump({key:kept},open(out,'w'))
