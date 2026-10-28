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
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=0x45f8ea,end=0x45f8ea)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if t0.fault or not idx: continue
    k=idx[0]
    T=None
    tr=run(W,row,s,ov,observe=True)
    rd=[a for (a,nn,v,wc),pc in zip(tr.reads,tr.read_pcs) if pc==0x45f8fc]
    if not rd: continue
    this=rd[0]-0x324
    for c371 in (0xffff,):
        for c29c in (0,):
            for rv in (0,1):
                nov=[list(o) for o in ov if o[0] not in (W.STUB_OVR+16*k,this+0x371,this+0x29c)]
                nov+=[[W.STUB_OVR+16*k,4,rv],[this+0x371,2,c371],[this+0x29c,1,c29c]]
                tr2=run(W,row,s,nov)
                if tr2.fault: continue
                if not (tr2.executed<=ex and tr2.edges<=ed):
                    ex|=tr2.executed;ed|=tr2.edges;kept.append([s,nov]);print('new',s,k,rv,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
