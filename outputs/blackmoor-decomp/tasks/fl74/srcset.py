"""srcset.py ROW OUT PC SLOTOFF [scen..]: at a `repe cmpsb` at PC, copy the string at edi over the string that the pointer stored at [ebp+SLOTOFF] points to (SLOTOFF e.g. -0x30); keep coverage adders"""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; pc=int(sys.argv[3],16); off=int(sys.argv[4],0); extra=sys.argv[5:]
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=200000
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
            ebp=uc_.reg_read(X.UC_X86_REG_EBP); edi=uc_.reg_read(X.UC_X86_REG_EDI); ecx=uc_.reg_read(X.UC_X86_REG_ECX)
            try:
                ptr=int.from_bytes(bytes(uc_.mem_read((ebp+off)&0xffffffff,4)),'little'); src=bytes(uc_.mem_read(edi,ecx))
            except Exception: return
            hits.append((ptr,src))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if not hits: continue
    ptr,src=hits[0]
    for extra_b in (b'',b'\x00'):
        nov=[list(o) for o in ov]+[[ptr+i,1,b] for i,b in enumerate(src+extra_b)]
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,hex(ptr),cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
