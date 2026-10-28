"""eq1.py OUT : 0x4bbb3e. At the ftol call 0x4bbc25 make the stub return the old [item+0x68] and make the old [item+0x70] equal the new one (so the first two compares at 0x4bbdf2 0x4bbe03 pass);
then the callee-store variants: none, [item+0x6c], [item+0x74] (the compares at 0x4bbe11 / 0x4bbe22)."""
import sys; sys.path.insert(0,'tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
out=sys.argv[1]
key='0x4bbb3e'; callpc=0x4bbc25
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],sys.argv[2:])
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    info=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            m=lambda ad:int.from_bytes(bytes(uc_.mem_read(ad&0xffffffff,4)),'little')
            ebp=uc_.reg_read(X.UC_X86_REG_EBP); item=m(ebp-8)
            info.append((len(trace.calls),item,m(item+0x68),m(item+0x50)))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=callpc,end=callpc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if not info: continue
    k,item,v68,v50=info[0]
    for var in (None,0x6c,0x74,0x6c|0x1000):
        nov=[list(o) for o in ov if o[0] not in (W.STUB_WR+16*k,W.STUB_WR+16*k+4,W.STUB_OVR+16*k,item+0x70)]
        nov+=[[item+0x70,4,(v68+v50-1)&0xffffffff],[W.STUB_OVR+16*k,4,v68]]
        if var is not None:
            off=var&0xfff
            nov+=[[W.STUB_WR+16*k,4,item+off],[W.STUB_WR+16*k+4,4,0x5555]]
        tr=run(W,row,s,nov)
        if tr.fault: print('fault',s,var); continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,k,var,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
