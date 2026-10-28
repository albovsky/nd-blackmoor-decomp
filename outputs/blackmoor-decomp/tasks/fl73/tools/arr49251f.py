import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import itertools
key='0x49251f'; out=sys.argv[1]; extra=sys.argv[2:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=600000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
T=0x20000000; ARR=((0x20e5,0x55),(0x22d9,0x55),(0x242d,0x19)); OBJ=0x20050000
for s,ov in scen:
    for mode,zz in itertools.product(itertools.product((0,1,2),repeat=3),(0,1)):   # per array: 0 keep, 1 first entry zero, 2 all zero
        nov=[list(o) for o in ov]
        for (off,n),m in zip(ARR,mode):
            if m==0: continue
            nov=[o for o in nov if not (T+off<=o[0]<T+off+4*n)]
            if m==1:
                nov.append([T+off,4,0]); nov+= [[T+off+4*i,4,OBJ] for i in range(1,3)]
            else:
                nov+= [[T+off+4*i,4,0] for i in range(n)]+[[T+off+4*n,4,OBJ]]
        if zz:
            for off,n in ((0x41f1,0x55),(0x4345,0x28),(0x43e5,0x55),(0x4539,0x19)):
                nov=[o for o in nov if not (T+off<=o[0]<T+off+4*n)]+[[T+off+4*i,4,0] for i in range(n)]
        nov+=[[OBJ+0x2f,2,2]]
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,mode,zz,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
