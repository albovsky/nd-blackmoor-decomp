import sys; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x427a50'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=3000000
PTR=0x20000000
out=[]
for t in range(256):
    for v in (1,2):
        for st in (0,1,2):
            ov=[[0x583999,4,3],[0x5c39e3,2,1],[0x5bb5e3,1,t],[0x5bb5e5,4,PTR],[0x5bb5e3+0x4f,4,st],[0x5bb5e3+0x42,1,0],[0x5bb5e3+0x55,4,0],[PTR+0x23,2,v]]+[[W.STUB_OVR+16*k,4,1] for k in range(14)]
            tr=run(W,row,1,ov)
            if not tr.fault and 0x429c48 in tr.executed and ((0x429c4f,0x429c5c) in tr.edges or (0x429c58,0x429c93) in tr.edges):
                out.append([1,ov]); print(t,v,st,flush=True)
json.dump({key:out},open(P+'/tasks/fl73/s427a50_sw6.json','w'))
