import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn
key='0x435015'; out=sys.argv[1]; extra=sys.argv[2:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=600000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
SP=W.STACK_BASE+W.STACK_SIZE-0x100-4*(W.ARGS+1); EBP=SP-4
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    idx=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): idx.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=0x4374c6,end=0x4374c6)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if not idx: continue
    k=idx[0]
    for N in (1,):
        nov=[list(o) for o in ov if o[0] not in (W.STUB_WR+16*k,W.STUB_WR+16*k+4,W.STUB_OVR+16*k)]
        nov+=[[W.STUB_WR+16*k,4,0x5bb1c6],[W.STUB_WR+16*k+4,4,1],[W.STUB_OVR+16*k,4,0x77]]
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,k,N,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken][:50])
json.dump({key:kept},open(out,'w'))
