"""eqv.py ROW OUT 'A:B:eq;C:D:ne;..' [scen..]: for each known scenario, run observing reads; for every pair (PC_A, PC_B, op) take the first cell read at PC_A and the first cell read at PC_B and make the cell read at PC_B hold
the value read at PC_A (eq) or that value + 1 (ne). Pairs apply in order, rerun after each change (up to 12 rounds). A pair with a '@n' suffix on a pc takes the n-th read there (A:B@1:eq). Keeps coverage-adders."""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
key=sys.argv[1]; out=sys.argv[2]; spec=sys.argv[3]; extra=sys.argv[4:]
def pp(x):
    if '@' in x: a,n=x.split('@'); return int(a,16),int(n)
    return int(x,16),0
pairs=[]
for p in spec.split(';'):
    a,b,op=p.split(':'); pairs.append((pp(a),pp(b),op))
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
def reads(tr):
    byp={}
    for (a,n,v,wc),pc in zip(tr.reads,tr.read_pcs): byp.setdefault(pc,[]).append((a,n,v))
    return byp
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    cur=[list(o) for o in ov]
    for rnd in range(12):
        tr=run(W,row,s,cur,observe=True)
        if tr.fault: break
        used=[list(o) for o in cur]                                     # the overrides that produced tr
        b=reads(tr); changed=False
        for (pa,na),(pb,nb),op in pairs:
            if pa not in b or pb not in b or len(b[pa])<=na or len(b[pb])<=nb: continue
            va=b[pa][na][2]; ab,nz,vb=b[pb][nb]
            want=(va+{'eq':0,'ne':1,'gt':1,'lt':-1}[op])&((1<<(8*nz))-1)
            if vb!=want:
                cur=[o for o in cur if o[0]!=ab]+[[ab,nz,want]]; changed=True; break
        if not tr.fault and not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,used]);print('new',s,rnd,cov(G,row,ex,ed)[:4],flush=True)
        if not changed: break
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
