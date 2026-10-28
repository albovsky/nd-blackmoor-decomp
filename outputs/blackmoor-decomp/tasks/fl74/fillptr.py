"""fillptr.py ROW OUT PC SLOTOFF N [scen..]: at the first hit of PC read the pointer at [ebp+SLOTOFF] (SLOTOFF<0x10000: ebp-relative; or 'reg:edi' to take a register), then set N bytes of 'A' (plus a NUL after if env NUL=1) there; keep coverage adders"""
import sys,os; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; pc=int(sys.argv[3],16); off=sys.argv[4]; N=int(sys.argv[5],0); extra=sys.argv[6:]
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    hits=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            if off.startswith('reg:'): ptr=uc_.reg_read(getattr(X,'UC_X86_REG_'+off[4:].upper()))
            else:
                ebp=uc_.reg_read(X.UC_X86_REG_EBP)
                ptr=int.from_bytes(bytes(uc_.mem_read((ebp+int(off,0))&0xffffffff,4)),'little')
            hits.append(ptr)
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if not hits: continue
    p=hits[0]
    nov=[list(o) for o in ov if not (p<=o[0]<p+N+1)]+[[p+i,1,0x41] for i in range(N)]+([[p+N,1,0]] if os.environ.get('NUL') else [])
    tr=run(W,row,s,nov)
    if tr.fault: print('fault',tr.fault); continue
    if not (tr.executed<=ex and tr.edges<=ed):
        ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,hex(p),cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
