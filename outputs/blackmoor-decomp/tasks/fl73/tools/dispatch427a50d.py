import sys,random,time,itertools; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x427a50'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=3000000
PTR=0x20000000
rng=random.Random(21)
ex=set();ed=set();out=[]
for f in ('s427a50_base','s427a50_sw','s427a50_extra','s427a50_sw2','s427a50_sw3'):
    for sd,ov in json.load(open(P+'/tasks/fl73/%s.json'%f))[key]:
        tr=run(W,row,sd,ov); ex|=tr.executed; ed|=tr.edges; out.append([sd,ov])
print('base',cov(G,row,ex,ed)[:4],flush=True)
def mk(t,state,words,structs,eaxs):
    ov=[[0x583999,4,3],[0x5c39e3,2,1],[0x5bb5e3+0x4f,4,state],[0x5bb5e3,1,t],[0x5bb5e5,4,PTR],[0x5bb5e3+0x42,1,0],[0x5bb5e3+0x55,4,0]]
    for i,v in enumerate(words): ov.append([PTR+2*i,2,v])
    for idx,v in enumerate(structs): ov.append([0x585d65+idx*0x106,4,v])
    for k,e in enumerate(eaxs): ov.append([W.STUB_OVR+16*k,4,e])
    return ov
# types reaching the struct case
types=[]
for t in range(256):
    tr=run(W,row,1,mk(t,0,[0,1]+[0]*20,[1]*8,[1]*14))
    if 0x428822 in tr.executed: types.append(t)
print('struct types',types,flush=True)
t0=time.time()
for t in types:
    for op in range(7):
        for v in (1,2,5,6,0):
            for w8 in (0,5000):
                for w4 in (0,3,100):
                    words=[0,op,w4,w4,w8]+[rng.choice((0,1,2,3)) for _ in range(16)]
                    for eaxs in ([1]*14,[0]*14):
                        ov=mk(t,0,words,[v]*8,eaxs)
                        tr=run(W,row,1,ov)
                        if tr.fault: continue
                        if not (tr.executed<=ex and tr.edges<=ed):
                            ex|=tr.executed;ed|=tr.edges;out.append([1,ov])
print('struct sweep',len(out),cov(G,row,ex,ed)[:4],time.time()-t0,flush=True)
# stub eax 3 for the early compare
for t in range(256):
    for st in (0,1,2):
        for k in range(0,6):
            eaxs=[1]*14; eaxs[k]=3
            ov=mk(t,st,[0]*24,[1]*8,eaxs)
            tr=run(W,row,1,ov)
            if tr.fault: continue
            if not (tr.executed<=ex and tr.edges<=ed):
                ex|=tr.executed;ed|=tr.edges;out.append([1,ov])
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print(got,total,taken,dirs,[(hex(a),n) for a,n in untaken],time.time()-t0)
json.dump({key:out},open(P+'/tasks/fl73/s427a50_sw4.json','w'))
