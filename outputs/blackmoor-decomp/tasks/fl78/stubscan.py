"""stubscan.py ROW [MAXK]: hand-scenario search for a scenario-complete row that is one direction short: on top of each kept scenario (taken from the scenario worker's row file),
set the result register (eax, ecx or edx) of the k-th callee stub to 0, 1 or all ones (STUB_OVR) and report the candidates whose original run takes a still-untaken direction.
Only the original is run here (cheap); a hit is then confirmed with check_row (both sides)."""
import sys, json, itertools
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
import fl41_world as W41
key = sys.argv[1]
maxk = int(sys.argv[2]) if len(sys.argv) > 2 else 6
pool = T.pool_of(key); W, G = T.world(T.POOLS[pool]['world']); row = T.row_info(pool, key)
d = json.load(open('/home/user/wt-scen/outputs/blackmoor-decomp/tasks/fl66/rows/%s.json' % key))
kept = [(s, [tuple(x) for x in ov]) for s, ov in d['kept']]
ex, ed = set(), set()
for s, ov in kept:
    o = W.run_original(row, s, ov)
    ex |= o.executed; ed |= o.edges
got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
print(key, 'base', got, total, taken, dirs, [(hex(a), n) for a, n in untaken], flush=True)
want = set(untaken)
hits = []
for s, ov in kept:
    for k, reg, v in itertools.product(range(maxk), range(3), (0, 1, 0xffffffff)):
        cand = list(ov) + [(W41.STUB_OVR + 16 * k + 4 * reg, 4, v)]
        o = W.run_original(row, s, cand)
        if o.fault:
            continue
        g = G.covers(row, ex | o.executed, ed | o.edges)
        new = want - set(g[5])
        if new:
            hits.append((s, cand))
            print('HIT', s, cand[-1], [(hex(a), n) for a, n in new], flush=True)
            break
    else:
        continue
    break
json.dump([[s, [list(x) for x in c]] for s, c in hits], open('tasks/fl78/stubscan_%s.json' % key, 'w'))
