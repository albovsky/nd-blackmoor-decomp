import sys,random,time; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x427a50'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=3000000
ex=set();ed=set();out=[]
for f in ('s427a50_base','s427a50_sw','s427a50_extra','s427a50_sw2','s427a50_sw3','s427a50_sw4'):
    for sd,ov in json.load(open(P+'/tasks/fl73/%s.json'%f))[key]:
        tr=run(W,row,sd,ov); ex|=tr.executed; ed|=tr.edges; out.append([sd,ov])
print('base',cov(G,row,ex,ed)[:4],flush=True)
variants=[[[0x5bb22a,4,1]],[[0x583204,4,4]],[[0x583204,4,3]],[[0x63a4cd,2,1]],[[0x5bb5e4,1,2]],[[0x5bb22a,4,1],[0x63a4cd,2,1]],[[0x5bb22a,4,0],[0x583204,4,4],[0x63a4cd,2,1]],[[0x5bb22a,4,0],[0x583204,4,3],[0x63a4cd,2,1]]]
for t in range(256):
    for var in variants:
        for eax in (0,1):
            ov=[[0x583999,4,3],[0x5c39e3,2,1],[0x5bb5e3,1,t],[0x5bb5e3+0x42,1,0],[0x5bb5e3+0x55,4,0]]+var+[[W.STUB_OVR+16*k,4,eax] for k in range(14)]
            tr=run(W,row,1,ov)
            if tr.fault: continue
            if not (tr.executed<=ex and tr.edges<=ed):
                ex|=tr.executed;ed|=tr.edges;out.append([1,ov])
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print(got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:out},open(P+'/tasks/fl73/s427a50_sw5.json','w'))
