"""0x471722 round 2: on the scenarios of the generated set and the string hits, flip the bytes behind the remaining untaken compares."""
import sys, json
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
from unicorn import x86_const as X
key = '0x471722'
pool = T.pool_of(key); W, G = T.world(T.POOLS[pool]['world']); row = T.row_info(pool, key)
g = json.load(open('tasks/fl78/gen-471722.json'))[key]
pool_sc = [(s, [tuple(x) for x in ov]) for s, ov in g] + [(s, [tuple(x) for x in ov]) for s, ov in json.load(open('tasks/fl78/hand2_471722.json'))]
good = []
ex0, ed0 = set(), set()
for s, ov in pool_sc:
    o = W.run_original(row, s, ov)
    if o.fault:
        continue
    good.append((s, ov)); ex0 |= o.executed; ed0 |= o.edges
untaken = lambda ex, ed: [(hex(a), n) for a, n in G.covers(row, ex, ed)[5]]
print('base', untaken(ex0, ed0), flush=True)
def regs_at(s, ov, addr):
    seen = []
    def p(uc, ensure, n):
        seen.append({r: uc.reg_read(getattr(X, 'UC_X86_REG_' + r.upper())) for r in ('eax', 'ecx', 'edx', 'esi', 'edi', 'ebp')})
    W.run_original(row, s, ov, probes={addr: p})
    return seen
SITES = [(0x4724d6, 'ecx', 0xdfe, 1, (0, 1, 0xff)), (0x4721cb, 'eax', 0xd3b, 1, (1, 0xff)), (0x4721b7, 'ecx', 0xd01, 2, (1, 5, 0x7fff))]
hits, cur_ex, cur_ed = [], set(ex0), set(ed0)
for s, ov in good:
    for addr, reg, disp, size, vals in SITES:
        r = regs_at(s, ov, addr)
        if not r:
            continue
        a = (r[0][reg] + disp) & 0xffffffff
        for v in vals:
            cand = ov + [(a, size, v)]
            o = W.run_original(row, s, cand)
            if o.fault:
                continue
            before = set(untaken(cur_ex, cur_ed))
            after = set(untaken(cur_ex | o.executed, cur_ed | o.edges))
            if after < before:
                cur_ex |= o.executed; cur_ed |= o.edges
                hits.append((s, cand))
                print('HIT', s, hex(addr), hex(a), v, '->', sorted(after), flush=True)
print('final', untaken(cur_ex, cur_ed))
json.dump([[s, [list(x) for x in c]] for s, c in hits], open('tasks/fl78/hand3_471722.json', 'w'))
