"""allreads.py (craft.py with nth='all': every read at the pc gets the value) ROW 'PCMAP' OUT [scenfile..]: PCMAP python dict {pc: (size,value)} or {pc:(size,value,nth)}: for every known scenario, run observe, set the cell read at pc (n-th read) to value;
iterate: rerun with the overrides (new pcs may appear), up to 4 rounds. keeps scenarios that add coverage."""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
key=sys.argv[1]; pcmap=eval(sys.argv[2]); out=sys.argv[3]
extra=sys.argv[4:] or [P+'/tasks/fl75/near-miss-scenarios-2.json']
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
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
print('base',cov(G,row,ex,ed)[:4])
for s,ov in scen:
    cur=[list(o) for o in ov]
    for rnd in range(4):
        tr=run(W,row,s,cur,observe=True)
        if tr.fault: break
        b=reads(tr); changed=False
        for pc,spec in pcmap.items():
            if spec=='STREQ':
                if pc in b and len(b[pc])>=2:
                    for a in (b[pc][0][0],b[pc][1][0]):
                        if not any(o[0]==a for o in cur):
                            cur=cur+[[a+i,1,0] for i in range(10)]; changed=True
                continue
            sz,val=spec[0],spec[1]; nth=spec[2] if len(spec)>2 else 0
            for k in (range(len(b.get(pc,[]))) if nth=='all' else [nth]):
                if pc in b and len(b[pc])>k:
                    a=b[pc][k][0]
                    if not any(o[0]==a and o[2]==val for o in cur):
                        cur=[o for o in cur if o[0]!=a]+[[a,sz,val]]; changed=True
        if not tr.fault and not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in cur]]);print('new',s,rnd,cov(G,row,ex,ed)[:4])
        if not changed: break
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[hex(x) for x in missing][:30],[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
