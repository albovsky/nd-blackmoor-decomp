"""reprove_all.py OUT [row ...]: re-prove every missing item of the rows of tasks/fl67-infeasible.json with the current prover (all rows when none given); prints one line per row"""
import sys,json,time,multiprocessing as mp
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/scripts'); sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tests')
import fl67_infeasible as P
MAN=json.load(open('/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl67-infeasible.json'))['rows']
def one(key):
    r=MAN[key]; pr=r['proofs']
    tg={'missing':list(pr['instructions']),'untaken':[k.split(':') for k in pr['directions']]}
    t0=time.time()
    try:
        out=P.prove_row(key,tg,timeout_ms=40000,fail_fast=True)
        return key,out['status'],len(tg['missing']),len(tg['untaken']),round(time.time()-t0)
    except Exception as e:
        return key,'error:%s'%type(e).__name__,len(tg['missing']),len(tg['untaken']),round(time.time()-t0)
if __name__=='__main__':
    out=sys.argv[1]; keys=sys.argv[2:] or sorted(MAN,key=lambda k:(MAN[k]['body'],int(k,16)))
    res=[]
    with mp.Pool(2,maxtasksperchild=1) as pool:
        for r in pool.imap_unordered(one,keys):
            print(*r,flush=True); res.append(r)
    json.dump(res,open(out,'w'))
