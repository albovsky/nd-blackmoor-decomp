"""confirm13.py ROW SCENJSON...: run check_row (original and translation) on the scenario worker's kept scenarios plus the extra scenarios of the given files (a list of [seed, [[addr, size, value], ...]]), write tasks/fl78/scen13_<ROW>.json when the row becomes tested_equivalent"""
import sys, json
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
key = sys.argv[1]
d = json.load(open('/home/user/wt-scen/outputs/blackmoor-decomp/tasks/fl66/rows/%s.json' % key))
scen = [(s, [tuple(x) for x in ov]) for s, ov in d['kept']]
for f in sys.argv[2:]:
    scen += [(s, [tuple(x) for x in ov]) for s, ov in json.load(open(f))]
res = T.check_row(key, scenarios=scen)
print(key, res['status'], res['instructions'], res['directions'], res.get('untaken'), res.get('mismatch'))
if res['status'] == 'tested_equivalent':
    json.dump({key: res['kept']}, open('tasks/fl78/scen13_%s.json' % key, 'w'))
