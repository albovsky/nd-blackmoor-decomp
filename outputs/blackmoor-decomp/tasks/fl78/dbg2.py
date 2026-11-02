import sys,os,random
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
key=sys.argv[1]; seed=int(sys.argv[2]); gfile=sys.argv[3]; idx=int(sys.argv[4]); watchpcs=[int(x,16) for x in sys.argv[5:]]
pool,W,G,row=setup(key)
SP=W.SP
def arg(n): return SP+4+4*n
def R(reg,val): return (W.REG_OVERRIDE+4*W.REG_NAMES.index(reg),4,val)
for i in range(8): globals()['P%d'%i]=0x20000000+0x10000*i
exec(open(gfile).read())
ov=SETS[idx]
seq=[]
def watch(uc,ensure,trace,sp):
    def h(uc_,a,sz,u): seq.append(a)
    uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=row['va'],end=row['va']+row['body'])
tr=W.run_original(row,seed,[tuple(o) for o in ov],watch=watch)
import collections
c=collections.Counter(seq)
print(tr.fault,len(seq),sorted(((hex(p),n) for p,n in c.items() if n>2000))[:60])
