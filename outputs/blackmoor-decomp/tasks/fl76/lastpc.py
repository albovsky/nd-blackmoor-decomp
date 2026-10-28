"""lastpc.py ROW SEED 'OVLIST' : run, print fault and the last 12 pcs executed"""
import sys; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
key=sys.argv[1]; seed=int(sys.argv[2]); ov=eval(sys.argv[3])
pool,W,G,row=setup(key)
seq=[]
def watch(uc,ensure,trace,sp):
    def h(uc_,a,sz,u):
        seq.append(a)
        if len(seq)>5000000: seq.pop(0)
    uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=row['va'],end=row['va']+row['body'])
tr=W.run_original(row,seed,[tuple(o) for o in ov],watch=watch)
print(tr.fault,[hex(x) for x in seq[-12:]])
