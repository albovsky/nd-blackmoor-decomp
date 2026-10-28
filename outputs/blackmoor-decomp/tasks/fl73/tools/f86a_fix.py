import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
key='0x49f86a'; out=sys.argv[1]; extra=sys.argv[2:]
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=600000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
SP=W.STACK_BASE+W.STACK_SIZE-0x100-4*(W.ARGS+1); T=0x20000000
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept))
for s,ov in scen:
    arg=[o[2] for o in ov if o[0]==SP+4]; arg=arg[0] if arg else 0
    base=T+0x2c+0x15e*arg
    for ent in (1,0x10001,0x201,0x1000001,0x30001):
        for word in (2,3,4):
            nov=[list(o) for o in ov if o[0] not in (0x6329d5,T+0xe0c) and not (base+0x118<=o[0]<base+0x118+40) and not (base+0x140<=o[0]<base+0x140+20)]
            nov+=[[0x6329d5,4,1],[T+0xe0c,4,3]]+[[base+0x118+4*j,4,ent] for j in range(10)]+[[base+0x140+2*j,2,word] for j in range(10)]
            tr=run(W,row,s,nov)
            if tr.fault: continue
            if not (tr.executed<=ex and tr.edges<=ed):
                ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,hex(ent),word,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
