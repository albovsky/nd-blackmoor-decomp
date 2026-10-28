"""cmpeq.py ROW OUT PC[,PC..] [scen..]: at every scenario that reaches a `repe cmpsb` at PC, make the compared strings equal (copy the edi string over [esi]); keep coverage-adding results.
env REQ=0xaddr,.. only scenarios executing those pcs are used; env UPTO=n limit copy length"""
import sys,os; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; pcs=[int(x,0) for x in sys.argv[3].split(',')]; extra=sys.argv[4:]
pool,W,G,row=setup(key)

scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    for pc in pcs:
        hits=[]
        def watch(uc,ensure,trace,sp):
            def h(uc_,a,sz,u):
                esi=uc_.reg_read(X.UC_X86_REG_ESI);edi=uc_.reg_read(X.UC_X86_REG_EDI);ecx=uc_.reg_read(X.UC_X86_REG_ECX)
                try: src=bytes(uc_.mem_read(edi,ecx))
                except Exception: src=None
                hits.append((esi,ecx,src))
            uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
        t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
        if not hits: continue
        esi,n,src=hits[0]
        if src is None or n>64: continue
        nov=[list(o) for o in ov]+[[esi+i,1,b] for i,b in enumerate(src)]
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,hex(pc),hex(esi),n,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs)
json.dump({key:kept},open(out,'w'))
