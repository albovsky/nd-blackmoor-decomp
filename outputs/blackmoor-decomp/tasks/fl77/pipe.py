"""pipe.py ROW OUT 'RECIPES' [scen..]   (FL-77: one tool for stub returns, callee stores, compares and register-relative cells)

RECIPES is a python list; a recipe is a list of steps applied in order to EVERY known scenario (the files named, plus the corpus). Each step re-runs the scenario with the overrides built so far
to find the hook, so a later step sees the effect of an earlier one. A scenario whose hook pc is not reached is dropped for that recipe. Coverage adders are kept (env ALL=1 keeps every
scenario that ran the whole recipe without a fault; env MAXHIT=n limits each recipe to the first n scenarios that run it; env DBG=1 prints faults).

Steps:
  ('g', addr, size, val)                      global cell
  ('ret', pc, slot, val[, nth])               the callee called at pc (nth hit) returns val in slot 0=eax 1=ecx 2=edx
  ('wr', pc, target, val[, nth])              that callee also stores the dword val at target; target is an int, (reg, off) = reg + off at the call, or ('d', reg, [o0,o1,..,oN]) = [..[reg+o0]+o1..]+oN
  ('cp', pc, n[, nth])                        at the repe cmpsb at pc make the n bytes at esi equal the n bytes at edi
  ('cell', pc, reg, path, size, val[, nth])   a cell [..[reg+path0]+path1..]+pathN at the nth hit of pc (every offset but the last is dereferenced); reg is a register name
  ('cellv', pc, reg, path, size, val[, nth])  as 'cell' but the cell address is reg + path (no dereference of reg) when path is an int
  ('cellabs', addr, size, val)                same as 'g'
  ('cells', pc, reg, [(path,size,val),..][, nth])  several cells with one probe (path ['A', addr] = absolute address)
  ('shift', pc, n[, nth])                     the stub overrides at or after the call index reached at pc move n calls later (use after a step that inserts n callee calls before them)
Example: pipe.py 0x4181c6 out.json "[[('g',0x5bb1fe,4,0xffffffff),('ret',0x4182a9,0,1),('wr',0x4182a9,('ebp',-0x150),0x10002),('cp',0x418303,20)]]" base.json
"""
import sys, os, struct
sys.path.insert(0, '/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X

REGN = ('eax', 'ebx', 'ecx', 'edx', 'esi', 'edi', 'ebp', 'esp')


def probe(W, row, s, nov, pc, nth, want_bytes=None, resolve=None):
    hits = []

    def watch(uc, ensure, trace, sp):
        def h(uc_, a, sz, u):
            regs = {r: uc_.reg_read(getattr(X, 'UC_X86_REG_' + r.upper())) for r in REGN}
            ncalls = len(trace.calls)

            def rd(addr):
                return struct.unpack('<I', bytes(uc_.mem_read(addr, 4)))[0]
            extra = None
            if want_bytes:
                extra = (bytes(uc_.mem_read(regs['edi'], want_bytes)), regs['esi'])
            res = resolve(regs, rd) if resolve else None       # pointer chains are walked here, at the hook, not after the run
            hits.append((ncalls, regs, rd, extra, res))
        uc.hook_add(unicorn.UC_HOOK_CODE, h, begin=pc, end=pc)
    try:
        W.run_original(row, s, [tuple(o) for o in nov], watch=watch)
    except Exception:
        return None
    gc.collect()
    return hits[nth] if len(hits) > nth else None


def chain(regs, rd, reg, path):
    a = regs[reg]
    for o in path[:-1]:
        a = rd((a + o) & 0xffffffff)
    return (a + path[-1]) & 0xffffffff


def apply_recipe(W, row, s, ov, recipe, dbg=False):
    nov = [list(o) for o in ov]
    for st in recipe:
        kind = st[0]
        if kind in ('g', 'cellabs'):
            nov = [o for o in nov if not (o[0] < st[1] + st[2] and st[1] < o[0] + o[1])] + [[st[1], st[2], st[3]]]
        elif kind in ('ret', 'wr'):
            pc = st[1]
            nth = st[4] if len(st) > 4 else 0
            tg = st[2] if kind == 'wr' else None
            h = probe(W, row, s, nov, pc, nth, resolve=(lambda regs, rd: chain(regs, rd, tg[1], tg[2])) if isinstance(tg, tuple) and tg[0] == 'd' else None)
            if h is None:
                return None
            k = h[0]
            if kind == 'ret':
                nov = [o for o in nov if o[0] != W.STUB_OVR + 16 * k + 4 * st[2]] + [[W.STUB_OVR + 16 * k + 4 * st[2], 4, st[3]]]
            else:
                tgt = st[2]
                if isinstance(tgt, tuple) and tgt[0] == 'd':        # ('d', reg, [o0, o1, .., oN]): [..[reg+o0]+o1..]+oN
                    tgt = h[4]
                elif isinstance(tgt, tuple):
                    tgt = (h[1][tgt[0]] + tgt[1]) & 0xffffffff
                nov = [o for o in nov if o[0] not in (W.STUB_WR + 16 * k, W.STUB_WR + 16 * k + 4)] + [[W.STUB_WR + 16 * k, 4, tgt], [W.STUB_WR + 16 * k + 4, 4, st[3]]]
        elif kind == 'cells':       # ('cells', pc, reg, [(path, size, val), ...][, nth]): several register-relative cells with one probe; a path starting with 'A' is an absolute address ('A', addr)
            pc, reg, lst = st[1], st[2], st[3]
            nth = st[4] if len(st) > 4 else 0
            h = probe(W, row, s, nov, pc, nth, resolve=lambda regs, rd: [p[1] if p[0] == 'A' else chain(regs, rd, reg, p) for p, _, _ in lst])
            if h is None:
                return None
            for (path, size, val), addr in zip(lst, h[4]):
                nov = [o for o in nov if not (o[0] < addr + size and addr < o[0] + o[1])] + [[addr, size, val]]
        elif kind == 'shift':       # ('shift', pc, n[, nth]): the stub overrides of every callee at or after the call index reached at pc move n calls later (n new calls were inserted before them)
            pc, n = st[1], st[2]
            nth = st[3] if len(st) > 3 else 0
            h = probe(W, row, s, nov, pc, nth)
            if h is None:
                return None
            k0 = h[0]
            def sh(o):
                a = o[0]
                for base in (W.STUB_OVR, W.STUB_WR):
                    if base <= a < base + 0x10000 and (a - base) // 16 >= k0:
                        return [a + 16 * n, o[1], o[2]]
                return o
            nov = [sh(o) for o in nov]
        elif kind == 'cp':
            pc, n = st[1], st[2]
            nth = st[3] if len(st) > 3 else 0
            h = probe(W, row, s, nov, pc, nth, want_bytes=n)
            if h is None:
                return None
            src, esi = h[3]
            addrs = {esi + i for i in range(n)}
            nov = [o for o in nov if o[0] not in addrs] + [[esi + i, 1, src[i]] for i in range(n)]
        elif kind in ('cell', 'cellv'):
            pc, reg, path, size, val = st[1:6]
            nth = st[6] if len(st) > 6 else 0
            h = probe(W, row, s, nov, pc, nth, resolve=lambda regs, rd: (regs[reg] + path) & 0xffffffff if isinstance(path, int) else chain(regs, rd, reg, path))
            if h is None:
                return None
            addr = h[4]
            nov = [o for o in nov if not (o[0] < addr + size and addr < o[0] + o[1])] + [[addr, size, val]]
        else:
            raise SystemExit('bad step %r' % (st,))
    return nov


def main():
    key = sys.argv[1]
    out = sys.argv[2]
    recipes = eval(sys.argv[3])
    extra = sys.argv[4:]
    pool, W, G, row = setup(key)
    if os.environ.get('LIM'):
        W.INSTRUCTION_LIMIT = int(os.environ['LIM'])
    scen = F.known_scenarios(key, F.POOLS[pool]['world'], extra)
    if os.environ.get('SEEDS'):             # SEEDS=a-b: plain seeds a..b-1 with no overrides (the recipe builds the rest)
        a, b = os.environ['SEEDS'].split('-'); scen = [(i, []) for i in range(int(a), int(b))] + ([] if os.environ.get('NOKNOWN') else scen)
    ex = set(); ed = set(); kept = []
    for s, ov in scen:
        tr = run(W, row, s, ov)
        if tr.fault:
            continue
        if not (tr.executed <= ex and tr.edges <= ed):
            ex |= tr.executed; ed |= tr.edges; kept.append([s, [list(o) for o in ov]])
    print('base', cov(G, row, ex, ed)[:4], len(kept), flush=True)
    maxhit = int(os.environ.get('MAXHIT', '0'))
    for ri, recipe in enumerate(recipes):
        hits = 0
        for s, ov in scen:
            if maxhit and hits >= maxhit:
                break
            nov = apply_recipe(W, row, s, ov, recipe)
            if nov is None:
                continue
            hits += 1
            tr = run(W, row, s, nov)
            gc.collect()
            if tr.fault:
                if os.environ.get('DBG'):
                    print('fault', ri, s, tr.fault, flush=True)
                continue
            if os.environ.get('ALL') or not (tr.executed <= ex and tr.edges <= ed):
                ex |= tr.executed; ed |= tr.edges; kept.append([s, nov])
                print('new', ri, s, cov(G, row, ex, ed)[:4], flush=True)
    got, total, taken, dirs, missing, untaken = cov(G, row, ex, ed)
    print('final', got, total, taken, dirs, ' '.join('%x%s' % (a, 'T' if n_ == 'taken' else 'F') for a, n_ in untaken))
    json.dump({key: kept}, open(out, 'w'))


if __name__ == '__main__':
    main()
