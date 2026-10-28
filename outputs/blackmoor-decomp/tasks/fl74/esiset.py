"""esiset.py ROW OUT PC OFFS VAL [scen..]: at the first hit of a string instruction at PC, set the byte at esi+OFFS to VAL (python ints); keep coverage adders"""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; pc=int(sys.argv[3],16); offs=int(sys.argv[4],0); val=int(sys.argv[5],0); extra=sys.argv[6:]
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
        def h(uc_,a,sz,u): hits.append(uc_.reg_read(X.UC_X86_REG_ESI))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if not hits: continue
    a=hits[0]+offs
    nov=[list(o) for o in ov if o[0]!=a]+[[a,1,val]]
    tr=run(W,row,s,nov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed):
        ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,hex(a),cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
