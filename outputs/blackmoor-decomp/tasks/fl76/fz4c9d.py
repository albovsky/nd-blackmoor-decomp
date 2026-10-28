"""fz4c9d.py OUT [scen..]: 0x4c9d91 state-3 branch: this+0x1f24=A, +0x1f28=B (own pages), counts equal, name strings (16 bytes at +0x30c, stride 0x3e4) equal or not, flag 0/1."""
import sys,json,itertools; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
key='0x4c9d91'; out=sys.argv[1]; files=sys.argv[2:]
pool,W,G,row=setup(key)
scen=F.known_scenarios(key,F.POOLS[pool]['world'],files)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
def hit(s,ov,pc):
    hits=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): hits.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch); gc.collect()
    return hits[0] if hits else None
P1,P2=0x20400000,0x20500000
for s in sorted({s for s,_ in scen}):
    tr=run(W,row,s,[],observe=True); gc.collect()
    t=[a-0x1f24 for (a,n,v,wc),p in zip(tr.reads,tr.read_pcs) if p==0x4c9dac]
    if not t: continue
    t=t[0]
    for cnt,equal,flag,diffbyte in itertools.product((1,2,3),(1,0),(0,1),(0,1)):
        if not equal and diffbyte: continue
        ov=[[t+0x1f24,4,P1],[t+0x1f28,4,P2],[t+0x1f30,4,3],[P2+0x1758,4,cnt],[0x63a4cd,2,flag]]
        for i in range(cnt):
            for j in range(4): 
                ov.append([P1+0x30c+i*0x3e4+4*j,4,0]); ov.append([P2+0x30c+i*0x3e4+4*j,4,0])
        if not equal: ov.append([P2+0x30c,1,7])
        elif diffbyte: ov.append([P2+0x30c+(cnt-1)*0x3e4+9,1,5])
        k1=hit(s,ov,0x4c9dfd)
        if k1 is None: continue
        ov+=[[W.STUB_WR+16*k1,4,t+0x1f34],[W.STUB_WR+16*k1+4,4,1]]
        k2=hit(s,ov,0x4c9f6d)
        if k2 is None: continue
        ov+=[[W.STUB_WR+16*k2,4,P1+0x1758],[W.STUB_WR+16*k2+4,4,cnt],[W.STUB_OVR+16*k2,4,1]]
        tr=run(W,row,s,ov); gc.collect()
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,ov]);print('new',s,cnt,equal,flag,diffbyte,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[hex(x) for x in missing][:10])
print('untaken',' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
