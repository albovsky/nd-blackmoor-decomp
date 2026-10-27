"""FL-73: record-sweep scenarios for the 0x427a50 dispatcher: one record of every type byte, every state dword (0..2), a parameter block of small words, callee returns zero or one."""
import sys,random,time; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x427a50'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=3000000
PTR=0x20000000
def build(t, state, fill, eaxs):
    ov=[[0x583999,4,3],[0x5c39e3,2,1]]
    base=0x5bb5e3
    ov+=[[base,1,t],[base+2,4,PTR],[base+0x42,1,0],[base+0x4f,4,state],[base+0x55,4,0]]
    for i,v in enumerate(fill):
        ov.append([PTR+2*i,2,v])
    for k,e in enumerate(eaxs):
        ov.append([W.STUB_OVR+16*k,4,e])
    return ov
rng=random.Random(5)
fills=[[0]*24,[1]*24,[2]*24,[3]*24]+[[rng.randrange(0,4) for _ in range(24)] for _ in range(6)]
stubs=[[0]*12,[1]*12,[1,0]*6]
ex=set();ed=set();out=[]
base=json.load(open(P+'/tasks/fl73/s427a50_base.json'))[key]
for sd,ov in base:
    tr=run(W,row,sd,ov); ex|=tr.executed; ed|=tr.edges; out.append([sd,ov])
print('base',cov(G,row,ex,ed)[:4],flush=True)
t0=time.time()
for t in range(0,256):
    for state in (1,2,0):
        for fill in fills:
            for eaxs in stubs:
                ov=build(t,state,fill,eaxs)
                tr=run(W,row,1,ov)
                if tr.fault: continue
                if not (tr.executed<=ex and tr.edges<=ed):
                    ex|=tr.executed;ed|=tr.edges;out.append([1,ov])
    if t%32==31: print(t,len(out),cov(G,row,ex,ed)[:4],time.time()-t0,flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print(got,total,taken,dirs,[hex(x) for x in missing][:60]); print([(hex(a),n) for a,n in untaken][:60])
json.dump({key:out},open(P+'/tasks/fl73/s427a50_sw.json','w'))
