import sys; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/scripts'); sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tests')
import fl71_window as Wn, fl67_infeasible as P
an,dom=Wn.prepare(sys.argv[1])
T=Wn.block_of(an,int(sys.argv[2],16),True)
for S in [int(x,16) for x in sys.argv[3].split(',')]:
    order=Wn.window(an,dom,S,T)
    print(hex(S),None if order is None else len(order),flush=True)
    if order is None: continue
    try:
        f=Wn.run_window(an,order,S,T,('dir','taken'),False)
    except P.Unsupported as e:
        print('  unsupported:',e); continue
    r,h=an.check(f,60000)
    print('  ->',r,flush=True)
