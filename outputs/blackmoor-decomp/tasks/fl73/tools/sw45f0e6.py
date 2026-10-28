import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn
key='0x45f0e6'; out=sys.argv[1]; extra=sys.argv[2:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
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
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=0x45feae,end=0x45feae)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if t0.fault or not idx: continue
    n=idx[0]
    tr=run(W,row,s,ov,observe=True)
    rd=[a for (a,nn,v,wc),pc in zip(tr.reads,tr.read_pcs) if pc==0x45feae]
    for k in range(max(0,n-4),n):
        for val in (1,):
            nov=[list(o) for o in ov if o[0] not in (W.STUB_WR+16*k,W.STUB_WR+16*k+4)]+[[W.STUB_WR+16*k,4,rd[0]],[W.STUB_WR+16*k+4,4,val]]
            tr2=run(W,row,s,nov)
            if tr2.fault: continue
            if not (tr2.executed<=ex and tr2.edges<=ed):
                ex|=tr2.executed;ed|=tr2.edges;kept.append([s,nov]);print('new',s,k,n,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
