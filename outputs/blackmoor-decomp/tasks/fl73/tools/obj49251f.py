import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn,itertools
import os
PCA=int(os.environ.get("OBJPC","0x492791"),16)
key="0x49251f"; out=sys.argv[1]; extra=sys.argv[2:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=600000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
OBJ=0x20020000; DATA=0x20028000; BUF=0x20030000
for s,ov in scen:
    idx=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): idx.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=PCA,end=PCA)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if t0.fault or not idx: continue
    k=idx[0]-1
    for (c23,c2d,c2b,c2f,mal,g895,after) in itertools.product((4,),(0,1,2),(0,1,3),(1,2),(0,BUF),(1,3),(0,1)):
        nov=[list(o) for o in ov if not (W.STUB_OVR+16*k<=o[0]<W.STUB_OVR+16*(k+2)+16)]
        nov=[o for o in nov if o[0] not in (0x639895,)]
        nov+=[[W.STUB_OVR+16*k,4,OBJ],[W.STUB_OVR+16*(k+1),4,mal],[0x639895,2,g895],[OBJ+0x23,4,c23],[OBJ+0x2d,2,c2d],[OBJ+0x2b,2,c2b],[OBJ+0x2f,2,c2f],[OBJ,4,DATA]]
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,k,(c2d,c2b,c2f,mal,g895),cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs)
json.dump({key:kept},open(out,'w'))
