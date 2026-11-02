import sys,struct
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; seed=int(sys.argv[2]); gfile=sys.argv[3]; idx=int(sys.argv[4]); pcs=[int(x,16) for x in sys.argv[5:]]
pool,W,G,row=setup(key)
SP=W.SP
def arg(n): return SP+4+4*n
def R(reg,val): return (W.REG_OVERRIDE+4*W.REG_NAMES.index(reg),4,val)
for i in range(8): globals()['P%d'%i]=0x20000000+0x10000*i
exec(open(gfile).read())
out=[]
def watch(uc,ensure,trace,sp):
    def h(uc_,a,sz,u):
        if len(out)>12: return
        g=lambda r: hex(uc_.reg_read(getattr(X,'UC_X86_REG_'+r)))
        out.append((hex(a),[g(r) for r in ("EAX","ECX","EDX","EBX","ESI","EDI","EBP","ESP")],[hex(x) for x in struct.unpack("<4I",bytes(uc_.mem_read(uc_.reg_read(X.UC_X86_REG_EBP)-12,16)))]))
    for p in pcs: uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=p,end=p)
tr=W.run_original(row,seed,[tuple(o) for o in SETS[idx]],watch=watch)
print(tr.fault)
for o in out: print(o)
