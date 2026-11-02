import sys,struct
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; seed=int(sys.argv[2]); pcs=[int(x,16) for x in sys.argv[3:]]
pool,W,G,row=setup(key)
out=[]
def watch(uc,ensure,trace,sp):
    def h(uc_,a,sz,u):
        esp=uc_.reg_read(X.UC_X86_REG_ESP); ebp=uc_.reg_read(X.UC_X86_REG_EBP)
        mem=struct.unpack('<6I',bytes(uc_.mem_read(esp,24)))
        out.append((hex(a),hex(esp),hex(ebp),[hex(m) for m in mem]))
    for p in pcs: uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=p,end=p)
try:
    tr=W.run_original(row,seed,[],watch=watch)
    print(tr.fault)
except Exception as e: print('exc',e)
print('SP',hex(W.SP),'STOP',hex(W.STOP))
for o in out: print(o)
