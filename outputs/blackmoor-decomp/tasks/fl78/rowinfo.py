import sys
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
pool,W,G,row=setup(sys.argv[1])
print({k:(v if k!='magic' else '...') for k,v in row.items() if k in ('va','body','sites','callees','fs')})
