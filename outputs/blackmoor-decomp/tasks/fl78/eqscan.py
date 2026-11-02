import sys,json,os
sys.path.insert(0,'scripts')
import fl66_tested as T
key=sys.argv[1]; f=sys.argv[2]
pool=T.pool_of(key); p=T.POOLS[pool]
W,G=T.world(p['world']); lib=T.library(pool); row=T.row_info(pool,key)
d=json.load(open(f))
sc=d[key] if isinstance(d,dict) else d
good=[]; bad=[]
for i,(seed,ov) in enumerate(sc):
    ov=[tuple(o) for o in ov]
    o=W.run_original(row,seed,ov)
    if o.fault: continue
    n=W.run_native(lib,row,seed,ov)
    if n.fault or n.digest()!=o.digest(): bad.append(i)
    else: good.append(i)
print('good',len(good),'bad',len(bad),bad[:20])
if len(sys.argv)>3:
    json.dump({key:[sc[i] for i in good]},open(sys.argv[3],'w'))
