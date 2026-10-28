"""fz424.py OUT NRUNS SEED0 : structured fuzz of 0x424aa8 records. args arg2=0x100fee0 arg3=0x100fee4 arg4=0x100fee8 (ebp=0x100fed4); records at P (16 bytes each)."""
import sys,random; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key='0x424aa8'
out=sys.argv[1]; nruns=int(sys.argv[2]); rs=int(sys.argv[3])
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=200000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],sys.argv[4:])
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
R=random.Random(rs)
TY=[0x12,0x13,0x12,0x13,0x14,0x11,0xb,0x1,0x2,0x3,0x4,0x5,6,7,8,9,10,0xc,0xd,0xe,0xf,0x10,0x15,0x16]
SM=[0,1,2,3,6,7,9,0xb,0xd,0xe,0x1388,0x1389,0x2710,-1,0x200,5,4]
for it in range(nruns):
    N=R.choice([2,3,4,5,6,8,12])
    P=0x20200000
    ov=[[0x100fee4,4,0x20300000],[0x100fee8,4,0x20300000+16*N],[0x100feec,4,P]]
    # balanced-ish: random brackets
    while True:
        types=[R.choice(TY+[0x12,0x13,0x12,0x13]) for _ in range(N)]
        o=sum(1 for t in types if t==0x12); c=sum(1 for t in types if t==0x13)
        if o!=c or o==0: continue
        bad=False
        for i,t in enumerate(types):
            if t==0x12 and ((i+1<N and types[i+1]==0x13) or (i+2<N and types[i+2]==0x13)): bad=True
        if not bad: break
    for i in range(N):
        t=types[i]
        ov.append([P+16*i,2,t&0xffff])
        for off in (2,4,6,8,10,12,14):
            if R.random()<0.7: ov.append([P+16*i+off,2,R.choice(SM)&0xffff])
    ovd={}
    for o in ov: ovd[(o[0])]=o
    ov=list(ovd.values())
    s=R.choice([199,9,41,3,0])
    tr=run(W,row,s,ov); gc.collect()
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed):
        ex|=tr.executed;ed|=tr.edges;kept.append([s,ov]);print('new',it,s,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs)
print('untaken',' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
