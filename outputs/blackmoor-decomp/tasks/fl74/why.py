import sys; sys.path.insert(0,'scripts'); sys.path.insert(0,'tests'); sys.dont_write_bytecode=True
import z3, fl67_infeasible as P
key=sys.argv[1]; jcc=int(sys.argv[2],16); name=sys.argv[3]
image=P.load_image(); row=P.row_of(key)
an=P.Analysis(row,image,60000); an.run()
print('plan',an.plan)
kind='taken' if name=='taken' else 'fall'
block=[a for a,b in an.blocks.items() if b['insns'][-1].address==jcc][0]
conds=[c for (n,k,t),c in an.edge.items() if n[0]==block and k==kind]
print(len(conds))
s=z3.Solver(); s.set('timeout',60000); s.add(*an.M.facts); s.add(conds[0] if len(conds)==1 else z3.Or(*conds))
r=s.check(); print(r)
if r==z3.sat:
    m=s.model(); print(str(m)[:3000])
c=conds[0]
print('cond size',len(str(c)))
print(str(z3.simplify(c))[:2500])
print('facts',len(an.M.facts), 'split', an.split if hasattr(an,'split') else None)
t=str(z3.simplify(c))
import re
print('TAIL', re.sub(r'\s+',' ',t)[-1800:])
