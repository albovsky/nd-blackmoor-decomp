"""pipef.py ROW OUT RECIPEFILE [scen..]: like pipe.py but the recipes python list is read from a file (long arguments)."""
import sys
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl77')
import pipe
sys.argv[3]=open(sys.argv[3]).read()
pipe.main()
