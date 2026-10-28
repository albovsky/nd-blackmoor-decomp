"""dbgrun.py ROW SEED PC:size:value[,..] : run one scenario (all reads at each PC get the value) and print fault info and the last pcs"""
import sys; sys.path.insert(0,'tasks/fl73/tools')
from drv import *
key=sys.argv[1]; seed=int(sys.argv[2]); spec=[x.split(':') for x in sys.argv[3].split(',')]
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=400000
cur=[]
for rnd in range(5):
    tr=run(W,row,seed,cur,observe=True)
    print('round',rnd,'fault',tr.fault,'calls',len(tr.calls),'executed',len(tr.executed))
    byp={}
    for (a,n,v,wc),pc in zip(tr.reads,tr.read_pcs): byp.setdefault(pc,[]).append(a)
    ch=False
    for pc,sz,val in spec:
        for a in byp.get(int(pc,16),[]):
            if not any(o[0]==a for o in cur): cur.append([a,int(sz),int(val,0)]); ch=True
    if not ch: break
print(cur[:30])
for attr in ('fault','fault_info','fault_pc','error'):
    print(attr,getattr(tr,attr,None))
import unicorn
last=[]
def watch(uc,ensure,trace,sp):
    def h(uc_,a,sz,u):
        last.append(a)
        if len(last)>6: last.pop(0)
    uc.hook_add(unicorn.UC_HOOK_CODE,h)
tr2=W.run_original(row,seed,[tuple(o) for o in cur],watch=watch)
print('last pcs',[hex(x) for x in last])
