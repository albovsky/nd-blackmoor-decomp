import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import disx
key=sys.argv[1]
pool,W,G,row=setup(key)
files=sys.argv[2:] or [P+'/tasks/fl71-scenarios.json']
scen=F.known_scenarios(key,F.POOLS[pool]['world'],files)
print(len(scen),'scenarios')
ex=set();ed=set()
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: print('fault',s,tr.fault); continue
    ex|=tr.executed; ed|=tr.edges
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print(key,'ninstr',got,total,'dirs',taken,dirs,'callees',{hex(k):v for k,v in row['callees'].items()},'sites',row.get('sites'))
# missing ranges
m=sorted(missing); rngs=[]
for a in m:
    if rngs and a-rngs[-1][1]<=8: rngs[-1][1]=a
    else: rngs.append([a,a])
print('missing ranges',[(hex(a),hex(b)) for a,b in rngs])
print('untaken',[(hex(a),n) for a,n in untaken])
for a,n in untaken:
    d=disx.rd(a,16)
    i=next(disx.md.disasm(d,a))
    print('  %x %s %s (%s)'%(a,i.mnemonic,i.op_str,n))
