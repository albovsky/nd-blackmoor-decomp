import sys,random,time; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x427a50'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=3000000
PTR=0x20000000
rng=random.Random(11)
ex=set();ed=set();out=[]
for f in ('s427a50_base','s427a50_sw','s427a50_extra'):
    for sd,ov in json.load(open(P+'/tasks/fl73/%s.json'%f))[key]:
        tr=run(W,row,sd,ov); ex|=tr.executed; ed|=tr.edges; out.append([sd,ov])
print('base',cov(G,row,ex,ed)[:4],flush=True)
t0=time.time()
for t in range(0,256):
    for it in range(40):
        fill=[rng.randrange(0,8) if i%2==0 else rng.randrange(0,8) for i in range(24)]
        ov=[[0x583999,4,3],[0x5c39e3,2,1],[0x5bb5e3,1,t],[0x5bb5e5,4,PTR],[0x5bb5e3+0x42,1,0],[0x5bb5e3+0x55,4,0]]
        for i,v in enumerate(fill): ov.append([PTR+2*i,2,v])
        for idx in range(8): ov.append([0x585d65+idx*0x106,4,rng.choice((0,1,2,5,6,3,4))])
        if rng.random()<0.5:
            for idx in range(8):
                for o in (4,8,0xc,0x10): ov.append([0x585d65+idx*0x106+o,4,rng.choice((0,1,2,5,100,5000,70000))])
        for k in range(14): ov.append([W.STUB_OVR+16*k,4,rng.choice((0,1,1,3))])
        tr=run(W,row,1,ov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;out.append([1,ov])
    if t%32==31: print(t,len(out),cov(G,row,ex,ed)[:4],'%.0fs'%(time.time()-t0),flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print(got,total,taken,dirs,[(hex(a),n) for a,n in untaken][:80])
json.dump({key:out},open(P+'/tasks/fl73/s427a50_sw2.json','w'))
