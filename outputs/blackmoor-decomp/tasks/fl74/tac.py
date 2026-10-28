import sys,time; sys.path.insert(0,'scripts'); sys.path.insert(0,'tests'); sys.dont_write_bytecode=True
import z3, fl71_window as Wn, fl67_infeasible as P
key=sys.argv[1]; jcc=int(sys.argv[2],16); name=sys.argv[3]; S=int(sys.argv[4],16); tmo=int(sys.argv[5])
an,dom=Wn.prepare(key)
T=Wn.block_of(an,jcc,True); q=('dir','taken' if name=='taken' else 'fall')
order=Wn.window(an,dom,S,T)
f=Wn.run_window(an,order,S,T,q,False)
print('blocks',len(order),'facts',len(an.M.facts), flush=True)
for label,mk in (('default',lambda: z3.Solver()),
                 ('qfabv',lambda: z3.Tactic('qfaufbv').solver()),
                 ('bitblast',lambda: z3.Then(z3.Tactic('simplify'),z3.Tactic('solve-eqs'),z3.Tactic('bit-blast'),z3.Tactic('sat')).solver())):
    s=mk(); s.set('timeout',tmo); s.add(*an.M.facts); s.add(f)
    t=time.time(); r=s.check(); print(label,r,'%.1fs'%(time.time()-t),flush=True)
    if str(r)=='unsat': break
