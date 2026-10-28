import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn
key='0x435015'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=600000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],sys.argv[1:])
c=0
for s,ov in scen:
    idx=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): idx.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=0x4374c6,end=0x4374c6)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    print(s,t0.fault,idx[:5],hex(len(t0.executed)))
    if idx:
        c+=1
        if c>3: break
    if idx:
        k=idx[0]
        nov=[list(o) for o in ov if o[0] not in (W.STUB_WR+16*k,W.STUB_WR+16*k+4,W.STUB_OVR+16*k)]
        nov+=[[W.STUB_WR+16*k,4,0x5bb1c6],[W.STUB_WR+16*k+4,4,1],[W.STUB_OVR+16*k,4,0x77]]
        tr=run(W,row,s,nov)
        print('  mod',tr.fault,hex(len(tr.executed)),0x4374f6 in tr.executed,0x4374ff in tr.executed, 0x4374e5 in tr.executed)
        got,total,taken,dirs,missing,untaken=cov(G,row,tr.executed,tr.edges)
        print('  cov',got,total,taken,dirs,[(hex(a),n) for a,n in untaken if 0x4374d0<=a<=0x437500])
