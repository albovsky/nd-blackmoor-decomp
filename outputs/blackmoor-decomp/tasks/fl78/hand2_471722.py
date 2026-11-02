"""0x471722: make the repe cmpsb compares at 0x472496 and 0x4726dd succeed (write the constant string where esi points), then try byte flips at the compares behind them."""
import sys, json, struct
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
from unicorn import x86_const as X
key = '0x471722'
pool = T.pool_of(key); W, G = T.world(T.POOLS[pool]['world']); row = T.row_info(pool, key)
pe = T.world(41)[0].od.load_image(); IB = T.world(41)[0].IMAGE_BASE
g = json.load(open('tasks/fl78/gen-471722.json'))[key]
base = [(s, [tuple(x) for x in ov]) for s, ov in g]
good = []
ex0, ed0 = set(), set()
for s, ov in base:
    o = W.run_original(row, s, ov)
    if o.fault:
        continue
    good.append((s, ov)); ex0 |= o.executed; ed0 |= o.edges
def untaken(ex, ed):
    return [(hex(a), n) for a, n in G.covers(row, ex, ed)[5]]
print('base', untaken(ex0, ed0), flush=True)
def regs_at(s, ov, addr, regs=('esi', 'edi', 'ecx', 'edx', 'eax')):
    seen = []
    def p(uc, ensure, n):
        seen.append({r: uc.reg_read(getattr(X, 'UC_X86_REG_' + r.upper())) for r in regs})
    W.run_original(row, s, ov, probes={addr: p})
    return seen
hits = []
for s, ov in good:
    for addr in (0x472496, 0x4726dd):
        r = regs_at(s, ov, addr)
        if not r:
            continue
        esi, edi = r[0]['esi'], r[0]['edi']
        writes = [(esi + k, 1, pe.image[edi + k - IB]) for k in range(9)] + [(edi + k, 1, pe.image[edi + k - IB]) for k in range(9)]       # the world randomises globals in the image, a string constant too: restore it
        cand = ov + writes
        o = W.run_original(row, s, cand)
        if o.fault:
            print(s, hex(addr), 'fault', flush=True); continue
        u = untaken(ex0 | o.executed, ed0 | o.edges)
        print(s, hex(addr), 'esi', hex(esi), '->', u, flush=True)
        hits.append((s, cand))
json.dump([[s, [list(x) for x in c]] for s, c in hits], open('tasks/fl78/hand2_471722.json', 'w'))
