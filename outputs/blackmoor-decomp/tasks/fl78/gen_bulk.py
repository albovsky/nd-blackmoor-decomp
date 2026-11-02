"""gen_bulk.py ROW ...: scripts/fl62_concolic.py with the lifter in BULK mode, the way scripts/fl66_tested.py world(41) sets it for row_info: a row whose callees must be classified for the x87 stack (callee chains deeper than 6, indirect calls, interior labels of C runtime routines) can then be set up. Same arguments as fl62_concolic.py."""
import sys
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl62_concolic as C62
import lift_fl41 as L
L.BULK = True
C62.C.main()
