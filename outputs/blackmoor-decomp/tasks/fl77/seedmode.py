"""seedmode.py ROW OUT PC REG DISP SIZE VAL S0-S1 : for each seed in S0..S1 hook PC, cell = REG+DISP at that pc, override it to VAL; write ALL scenarios that do not fault (no coverage pruning)."""
import sys, struct; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key,out,pc,reg,disp,size,val,rng=sys.argv[1:9]
pc=int(pc,16); disp=int(disp,0); size=int(size); val=int(val,0); a,b=map(int,rng.split('-'))
pool,W,G,row=setup(key)
res=[]
for s in range(a,b):
    box={}
    def watch(uc,ensure,trace,sp):
        def h(uc_,ad,sz,u): box.setdefault('a',(uc_.reg_read(getattr(X,'UC_X86_REG_'+reg.upper()))+disp)&0xffffffff)
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    try: W.run_original(row,s,[],watch=watch)
    except Exception: continue
    gc.collect()
    if 'a' not in box: continue
    ov=[[box['a'],size,val]]
    tr=run(W,row,s,ov)
    if tr.fault: continue
    res.append([s,ov])
print(len(res),'scenarios')
json.dump({key:res},open(out,'w'))
