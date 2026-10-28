"""dif.py ROW SEED 'OVLIST' [scen..]: run one scenario on original and translation, print the first differences of regs / writes / calls"""
import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
sys.path.insert(0,'scripts')
import fl66_tested as T
key=sys.argv[1]; seed=int(sys.argv[2]); ov=[tuple(o) for o in eval(sys.argv[3])]
pool=T.pool_of(key); p=T.POOLS[pool]; W,G=T.world(p['world']); lib=T.library(pool); row=T.row_info(pool,key)
o=W.run_original(row,seed,ov); n=W.run_native(lib,row,seed,ov)
print('fault',o.fault,n.fault)
print('regs diff',{k:(hex(o.regs[k]),hex(n.regs.get(k,0))) for k in o.regs if o.regs[k]!=n.regs.get(k)})
print('calls',len(o.calls),len(n.calls))
for i,(a,b) in enumerate(zip(o.calls,n.calls)):
    if a!=b: print('call',i,a,'|',b); break
print('writes',len(o.writes),len(n.writes))
for i,(a,b) in enumerate(zip(o.writes,n.writes)):
    if a!=b: print('write',i,a,'|',b); break
for i in range(max(0,int(__import__('os').environ.get('FROM','18'))),min(len(o.writes),len(n.writes))):
    print(i,[hex(x) if isinstance(x,int) else x for x in o.writes[i]],[hex(x) if isinstance(x,int) else x for x in n.writes[i]])
