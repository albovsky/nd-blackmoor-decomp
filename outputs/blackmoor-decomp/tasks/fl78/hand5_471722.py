"""0x471722 round 4: loop counts [ecx+0x21] at 0x471836 / 0x471b99: make them positive."""
import sys, json
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
from unicorn import x86_const as X
key = '0x471722'
pool = T.pool_of(key); W, G = T.world(T.POOLS[pool]['world']); row = T.row_info(pool, key)
def load(f, k=None):
    d = json.load(open(f)); d = d[key] if isinstance(d, dict) else d
    return [(s, [tuple(x) for x in ov]) for s, ov in d]
pool_sc = load('tasks/fl78/gen-471722.json') + load('tasks/fl78/hand2_471722.json') + load('tasks/fl78/hand3_471722.json')
good, ex0, ed0 = [], set(), set()
for s, ov in pool_sc:
    o = W.run_original(row, s, ov)
    if o.fault:
        continue
    good.append((s, ov)); ex0 |= o.executed; ed0 |= o.edges
untaken = lambda ex, ed: [(hex(a), n) for a, n in G.covers(row, ex, ed)[5]]
print('base', untaken(ex0, ed0), len(good), flush=True)
def regs_at(s, ov, addr):
    seen = []
    def p(uc, ensure, n):
        seen.append({r: uc.reg_read(getattr(X, 'UC_X86_REG_' + r.upper())) for r in ('eax', 'ecx', 'edx')})
    W.run_original(row, s, ov, probes={addr: p})
    return seen
hits, cur_ex, cur_ed = [], set(ex0), set(ed0)
for s, ov in good:
    for addr, reg, disp in ((0x471836, 'ecx', 0x21), (0x471b99, 'ecx', 0x21)):
        r = regs_at(s, ov, addr)
        if not r:
            continue
        a = (r[0][reg] + disp) & 0xffffffff
        for v in (1, 3, 100):
            cand = ov + [(a, 2, v)]
            o = W.run_original(row, s, cand)
            if o.fault:
                print(s, hex(addr), v, 'fault'); continue
            before = set(untaken(cur_ex, cur_ed)); after = set(untaken(cur_ex | o.executed, cur_ed | o.edges))
            if after < before:
                cur_ex |= o.executed; cur_ed |= o.edges; hits.append((s, cand))
                print('HIT', s, hex(addr), hex(a), v, '->', sorted(after), flush=True)
print('final', untaken(cur_ex, cur_ed))
json.dump([[s, [list(x) for x in c]] for s, c in hits], open('tasks/fl78/hand5_471722.json', 'w'))
