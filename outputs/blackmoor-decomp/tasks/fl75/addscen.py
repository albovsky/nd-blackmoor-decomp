"""addscen.py ROW FILE..: add the scenarios of FILE.. for ROW into tasks/fl75/scenarios.json (row -> [[seed, overrides]]), starting from FL-72's second near-miss set (tasks/fl75/near-miss-scenarios-2.json) if the row is new; skips duplicates"""
import json,sys,os
P=os.path.dirname(os.path.abspath(__file__))+'/'
dst=P+'scenarios.json'
d=json.load(open(dst)) if os.path.exists(dst) else {}
row=sys.argv[1]
if row not in d: d[row]=json.load(open(P+'near-miss-scenarios-2.json')).get(row,[])
seen={json.dumps(x,sort_keys=True) for x in d[row]}
for f in sys.argv[2:]:
    for x in json.load(open(f)).get(row,[]):
        k=json.dumps(x,sort_keys=True)
        if k not in seen: seen.add(k); d[row].append(x)
json.dump(d,open(dst,'w'))
print(row,len(d[row]))
