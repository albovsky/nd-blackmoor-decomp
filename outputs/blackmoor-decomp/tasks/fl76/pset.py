"""pset.py ROW OUT NEWP PCHOOK [scen..]: for every known scenario add an override that points the table pointer [0x5bb5e5 + 0x8d*idx] (idx = signed word arg at [ebp+8] seen at PCHOOK) at NEWP; keeps scenarios that add coverage"""
import sys, struct; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; newp=int(sys.argv[3],0); pc=int(sys.argv[4],16); extra=sys.argv[5:]
pool,W,G,row=setup(key)
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    box=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            ebp=uc_.reg_read(X.UC_X86_REG_EBP); w=struct.unpack('<h',bytes(uc_.mem_read(ebp+8,2)))[0]; box.append(w)
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch); gc.collect()
    nov=[list(o) for o in ov]
    if box:
        a=0x5bb5e5+0x8d*box[0]
        nov=[o for o in nov if not (o[0]<a+4 and a<o[0]+o[1])]+[[a,4,newp]]
    tr=run(W,row,s,nov); gc.collect()
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,nov])
print('final',cov(G,row,ex,ed)[:4],len(kept))
json.dump({key:kept},open(out,'w'))
