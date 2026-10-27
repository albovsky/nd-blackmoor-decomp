#!/usr/bin/env python3
"""FL-71: FL-70's solver-guided scenario search (scripts/fl70_solve.py) with the callee's STORES as inputs too.

FL-70 replays one Unicorn run of the ORIGINAL symbolically (exact memory array, start registers and callee returns are symbols) and flips an untaken branch with z3. What it keeps concrete is what each callee
stub WROTE: a function that clears a global, calls a helper and then tests the global again can only take the other direction when the helper stores into it, and the stub of the world can store one dword at a
chosen address after the k-th call (STUB_WR + 16*k: address, + 4: value; tests/fl41_world.py, tests/fl40_world.py). The big dispatchers need exactly that move many times in a row.

Here each of the first MAX_CALLS callee calls gets a symbolic extra store `if E_k: mem[A_k .. A_k+3] = V_k` (E_k Boolean, A_k and V_k 32-bit symbols). The store lands after the stub's own writes, as in the world. A_k is
kept off the image below .data, off the stack, off the world's stub/TIB pages (above 0xffd00000) and off the function's own code (world rule `stub_filter`). The softs keep E_k, A_k and V_k at the values of the
parent scenario (no extra store when the parent has none), so a child changes only what the goal needs. The model's E_k, A_k, V_k become the STUB_WR overrides of the child; the run on the original
is the truth, a wrong model costs one child (FL-70's repair loop). Only the ORIGINAL runs here; the translation is compared afterwards by `fl66_tested.py check --scen FILE`.

  fl71_solve.py ROW [ROW ...] --out FILE [--budget-s N] [--fresh-seeds N] [--solver-ms N] [--scen FILE ...] [--max-calls N]        (run from outputs/blackmoor-decomp)
"""
import argparse
import itertools
import json
import os
import time
from pathlib import Path
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import z3
import fl66_tested as T
import fl67_infeasible as P
import fl70_solve as S

MAX_CALLS = 40
z3.set_param('memory_max_size', int(os.environ.get('FL67_MEM_MB', '3500')))
M32 = 0xffffffff
STATE = {'ov': [], 'world': None, 'row': None}


class Replay71(S.Replay):
    def __init__(self, *a, **kw):
        super().__init__(*a, **kw)
        W = STATE['world']
        self.W = W
        _, self.parent_stub = W.split_stub_overrides(STATE['ov'])
        self.store_syms = {}           # k -> (E, A, V, parent E, parent A, parent V)
        # a call through a pointer is played by the site hook BEFORE its record is written, so the record of the call already counts its stub and the run loop would count it one step early (a `call without a stub`
        # resync): the call's record gets the count in front of it
        sites = {int(a) for a in (STATE['row'].get('sites') or {})}
        for k in range(1, len(self.recs)):
            if self.recs[k].addr in sites and self.recs[k].ncalls > self.recs[k - 1].ncalls and self.insns.get(self.recs[k].addr) is not None and self.insns[self.recs[k].addr].mnemonic == 'call':
                self.recs[k].ncalls = self.recs[k - 1].ncalls

    def call(self, st, ins):
        W = self.W
        ks = self.cur_calls
        if not ks:
            raise S.Resync('call without a stub')
        k = ks[0]
        for ri, r in enumerate(('eax', 'ecx', 'edx')):
            name = 'stk%d_%s' % (k, r)
            st.R[r] = z3.BitVec(name, 32)
            self.stub_syms[name] = (k, ri, None)
        writes = list(self.tr.calls[k][7])
        extra = W.extra_stub_writes(self.parent_stub, k)
        filt = getattr(W, 'stub_filter', None)                # fl40_world has no filter: its extra store is always applied
        kept_extra = bool(extra and (filt(STATE['row'], extra) if filt else extra))
        if kept_extra and writes:
            writes.pop()                                  # the parent's own extra store is modelled symbolically below
        for at, data in writes:
            for j, b in enumerate(data):
                self.put_byte(st, at + j, b)
        if k < MAX_CALLS:
            E, A, V = z3.Bool('stE%d' % k), z3.BitVec('stA%d' % k, 32), z3.BitVec('stV%d' % k, 32)
            row = STATE['row']
            lo, hi = row['va'], row['va'] + row['body']
            ok = z3.And(z3.ULE(P.bv(0x1000, 32), A), z3.ULT(A, P.bv(W.STUB_WR - 4, 32)),
                        z3.Or(z3.ULT(A, P.bv(P.IMAGE_BASE - 3, 32)), z3.UGE(A, P.bv(P.DATA_START, 32))),
                        z3.Or(z3.ULT(A, P.bv(W.STACK_BASE - 3, 32)), z3.UGE(A, P.bv(W.STACK_BASE + W.STACK_SIZE, 32))),
                        z3.Or(z3.ULT(A, P.bv(lo - 3, 32)), z3.UGE(A, P.bv(hi, 32))))
            self.facts.append(z3.Implies(E, ok))
            new = st.mem
            for j in range(4):
                new = z3.Store(new, A + j, z3.Extract(8 * j + 7, 8 * j, V))
            st.mem = z3.If(E, new, st.mem)
            pe = kept_extra
            pa = self.parent_stub.get((k, 8), 0) if pe else 0
            pv = self.parent_stub.get((k, 9), 0) if pe else 0
            self.store_syms[k] = (E, A, V, pe, pa, pv)
        nxt = self.recs[self.next_i]
        st.R['esp'] = P.bv(self.creg(nxt, 'esp'), 32)
        for f, bit in S.FLAG_BIT.items():
            st.F[f] = z3.BoolVal(bool(nxt.eflags >> bit & 1))

    def groups(self):
        """the input groups of the parent scenario: ('reg', name, value) | ('cells', [(address, byte)]) | ('stub', symbol name, value) | ('store', k, E, A, V of the parent): releasing a group is one move of the scenario"""
        out = [('reg', n, v) for n, v in self.start_regs.items()]
        run = []
        for a_, b_ in sorted(self.init_cells.items()):
            if run and (a_ != run[-1][0] + 1 or len(run) == 4):
                out.append(('cells', run))
                run = []
            run.append((a_, b_))
        if run:
            out.append(('cells', run))
        for name, (k, ri, _) in self.stub_syms.items():
            call = self.tr.calls[k]
            out.append(('stub', name, (call[4], call[5], call[6])[ri]))
        for k, (E, A, V, pe, pa, pv) in self.store_syms.items():
            out.append(('store', k, pe, pa, pv))
        return out

    def pins(self, groups, released):
        """[(symbol, value)] for z3.substitute: every group not in `released` is replaced by its parent value; each memory array (the stack's and everything else's) becomes a store chain over a fresh array"""
        sub = []
        new = {name: z3.Array(name + 'free', z3.BitVecSort(32), z3.BitVecSort(8)) for name in ('mem', 'frm')}
        for gi, g in enumerate(groups):
            if gi in released:
                continue
            if g[0] == 'reg':
                sub.append((z3.BitVec('s_' + g[1], 32), P.bv(g[2], 32)))
            elif g[0] == 'stub':
                sub.append((z3.BitVec(g[1], 32), P.bv(g[2], 32)))
            elif g[0] == 'cells':
                for a_, b_ in g[1]:
                    nm = 'frm' if S.STACK_LO <= a_ < S.STACK_HI else 'mem'
                    new[nm] = z3.Store(new[nm], P.bv(a_, 32), P.bv(b_, 8))
            else:
                _, k, pe, pa, pv = g
                E, A, V = self.store_syms[k][:3]
                sub += [(E, z3.BoolVal(pe)), (A, P.bv(pa, 32)), (V, P.bv(pv, 32))]
        sub += [(S.ARR[name], new[name]) for name in ('mem', 'frm')]
        return sub

    def group_value(self, g):
        """the group's value as a bit-vector over the symbols (None for a callee store)"""
        if g[0] == 'reg':
            return z3.BitVec('s_' + g[1], 32)
        if g[0] == 'stub':
            return z3.BitVec(g[1], 32)
        if g[0] == 'cells':
            sel = [z3.Select(S.array_of(x), P.bv(x, 32)) for x, y in g[1]]
            return z3.Concat(*reversed(sel)) if len(sel) > 1 else sel[0]
        return None

    def group_soft(self, g):
        if g[0] == 'reg':
            return z3.BitVec('s_' + g[1], 32) == P.bv(g[2], 32)
        if g[0] == 'stub':
            return z3.BitVec(g[1], 32) == P.bv(g[2], 32)
        if g[0] == 'cells':
            return z3.And(*[z3.Select(S.array_of(x), P.bv(x, 32)) == P.bv(y, 8) for x, y in g[1]])
        _, k, pe, pa, pv = g
        E, A, V = self.store_syms[k][:3]
        return z3.And(E, A == P.bv(pa, 32), V == P.bv(pv, 32)) if pe else z3.Not(E)

    def input_softs(self):
        return [self.group_soft(g) for g in self.groups()]

    def selfcheck(self):
        return None


def child_overrides71(W, rp, model, parent, formulas):
    out = S_child_overrides(W, rp, model, parent, formulas)
    ks = {k for k in rp.store_syms}
    drop = lambda a: W.STUB_WR <= a < W.STUB_WR + 0x10000 and (a - W.STUB_WR) // 16 in ks and ((a - W.STUB_WR) % 16) < 8
    special = lambda a: W.STUB_WR <= a < W.STUB_WR + 0x10000 or W.STUB_OVR <= a < W.STUB_OVR + 0x10000 or a >= W.REG_OVERRIDE
    out = [o for o in out if not drop(o[0]) and (o[0] < 0xffd00000 or special(o[0]))]         # an address the world reserves for its own pages is not a cell the scenario can set
    for k, (E, A, V, pe, pa, pv) in sorted(rp.store_syms.items()):
        if not z3.is_true(model.eval(E, model_completion=True)):
            continue
        a = model.eval(A, model_completion=True).as_long()
        v = model.eval(V, model_completion=True).as_long()
        out.append([W.STUB_WR + 16 * k, 4, a])
        out.append([W.STUB_WR + 16 * k + 4, 4, v])
    return out


S_child_overrides = S.child_overrides
S_trace_run = S.trace_run


def trace_run71(W, row, seed, ov):
    STATE['ov'], STATE['world'], STATE['row'] = list(ov), W, row
    return S_trace_run(W, row, seed, ov)


STATS = {'sat': 0, 'unsat': 0, 'unknown': 0}


class SubModel:
    """a model of the substituted formula that answers questions about the original symbols (s_mem, the start registers, the stub symbols, E_k)"""

    def __init__(self, model, sub):
        self.model, self.sub = model, sub

    def eval(self, e, model_completion=False):
        return self.model.eval(z3.substitute(e, *self.sub), model_completion=model_completion)


def solve71(rp, pos, goal, ms, soft=True):
    """1. every input group is replaced by the value of the parent scenario (z3.substitute: the formula collapses to a constant and a product of two inputs is a product of constants); the goal is `false` there. 
    2. the groups that matter (the formula is not `false` when only that group is free) are released one, two, three at a time until the query is sat, so a child changes only what the goal needs, and a released
    value is made small if it can be (a loop count of 31,582 is a run of 6,000 steps).  3. when no small release works, the goal alone (plain solver) and the model pulled back to the parent group by group.
    A verdict `unknown` is a loss of that goal, not an answer."""
    F = z3.And(*(list(rp.facts) + list(rp.cons[:pos]) + [goal]))
    groups = rp.groups()
    t0 = time.time()

    def decide(released, ms_):
        """(verdict, solver, substitution) of the formula with every group not in `released` replaced by its parent value; the solver does the simplification under its own timeout (z3.simplify has none)"""
        sub = rp.pins(groups, released)
        s = z3.Solver()
        s.set('timeout', ms_)
        s.add(z3.substitute(F, *sub))
        return s.check(), s, sub

    def solve_released(released):
        r, s, sub = decide(released, STEP_MS)
        if r != z3.sat:
            return str(r), None
        best = s.model()
        s.set('timeout', REVERT_MS)
        for gi in sorted(released):                          # the smallest value of a released group that still works
            val = rp.group_value(groups[gi])
            if val is None:
                continue
            val = z3.substitute(val, *sub)
            for small in SMALL:
                s.push()
                s.add(val == z3.BitVecVal(small, val.size()))
                if s.check() == z3.sat:
                    best = s.model()
                    break
                s.pop()
        return 'sat', SubModel(best, sub)

    r, m = solve_released(set())
    if r == 'sat':
        STATS['sat'] += 1
        return m
    relevant = []
    for gi in range(len(groups)):
        if time.time() - t0 > ms / 1000.0:
            break
        if decide({gi}, RELEVANT_MS)[0] != z3.unsat:
            relevant.append(gi)
    for size in (1, 2, 3):
        sets = itertools.combinations(relevant, size)
        for k, rel in enumerate(sets):
            if k >= PAIR_CAP or time.time() - t0 > ms / 1000.0:
                break
            r, m = solve_released(set(rel))
            if r == 'sat':
                STATS['sat'] += 1
                return m
    base = list(rp.facts) + list(rp.cons[:pos]) + [goal]
    s = z3.Solver()
    s.set('timeout', STEP_MS)
    s.add(*base)
    r = s.check()
    if r == z3.unsat:
        STATS['unsat'] += 1
        return None
    if r != z3.sat:
        STATS['unknown'] += 1
        return None
    STATS['sat'] += 1
    m = s.model()
    s.set('timeout', REVERT_MS)
    for g in groups:                                         # pull the model back to the parent, group by group
        if time.time() - t0 > ms / 1000.0:
            break
        s.push()
        s.add(rp.group_soft(g))
        if s.check() == z3.sat:
            m = s.model()
            continue
        s.pop()
    return m


PAIR_CAP = 300
STEP_MS = 700
RELEVANT_MS = 250
MINE_STEPS = 1500                                          # a run that ends in the step limit is mined for its first steps only
REVERT_MS = 800
SMALL = (1, 2, 3, 4, 8)
S.solve = solve71

S.Replay = Replay71
S.child_overrides = child_overrides71
S.trace_run = trace_run71


def explore71(key, base_scen, out_path, budget_s=300, fresh_seeds=6, solver_ms=2500, log=print):
    """FL-70's search loop (scripts/fl70_solve.py explore) with a checkpoint of the kept scenarios after every run that adds coverage, so that a killed run keeps what it found"""
    import collections
    import heapq
    import capstone
    pool = T.pool_of(key)
    p = T.POOLS[pool]
    W, G = T.world(p['world'])
    row = T.row_info(pool, key)
    image = P.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = row['va'] - P.IMAGE_BASE
    insns = {i.address: i for i in md.disasm(bytes(image[off:off + row['body']]), row['va'])}
    ex, ed = set(), set()
    kept, queue = [], []
    counter = 0
    seen_children, seen_paths = set(), set()
    t0 = time.time()

    def save():
        out = json.loads(Path(out_path).read_text()) if Path(out_path).exists() else {}
        out[key] = kept
        Path(out_path).write_text(json.dumps(out))
    for seed, ov in base_scen:
        tr = W.run_original(row, seed, [tuple(o) for o in ov])
        if not tr.fault and not (tr.executed <= ex and tr.edges <= ed):
            ex |= tr.executed
            ed |= tr.edges
            kept.append([seed, [list(o) for o in ov]])
    n_base = len(kept)
    for s_, ov_ in [(k[0], k[1]) for k in kept] + [(1 + k, []) for k in range(fresh_seeds)]:
        heapq.heappush(queue, (0, counter, s_, [list(o) for o in ov_]))
        counter += 1
    runs = solved = 0
    while queue and time.time() - t0 < budget_s:
        pr, _, seed, ov = heapq.heappop(queue)
        runs += 1
        tr, recs, reads = S.trace_run(W, row, seed, ov)
        if not recs:
            continue                                              # a run that faults (or ends in the step limit) is not a scenario, but its trace is mined: a flip before the fault or in the loop it is stuck in may avoid it
        if not tr.fault and not (tr.executed <= ex and tr.edges <= ed):
            if [seed, ov] not in kept:
                kept.append([seed, ov])
            ex |= tr.executed
            ed |= tr.edges
            save()
        got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
        if not missing and not untaken:
            break
        if tr.fault:
            recs = recs[:MINE_STEPS]
        rp = Replay71(row, image, insns, tr, recs, reads)
        try:
            rp.run()
        except Exception as e:
            log('  replay failed: %s: %s' % (type(e).__name__, str(e)[:100]))
            continue
        sig = tuple((d['addr'], d.get('taken'), d['kind']) for d in rp.path)
        if sig in seen_paths:
            continue
        seen_paths.add(sig)
        cands = []
        firsts = collections.Counter()
        for d in rp.path:
            if d['kind'] == 'br':
                if d['alt'] not in ed:
                    cands.append((0, d['pos'], z3.Not(d['cond']), d))
                else:
                    firsts[d['alt']] += 1
                    if firsts[d['alt']] <= S.OCCURRENCES:
                        cands.append((1, d['pos'], z3.Not(d['cond']), d))
            elif d['kind'] == 'rep':
                cands.append((0, d['pos'], z3.Not(d['cond']), d))
        for pos, goal, addr in rp.rep_goals:
            cands.append((0, pos, goal, dict(kind='repgoal', addr=addr)))
        cands.sort(key=lambda c: (c[0], -c[1]))
        n0 = n1 = 0
        for prio, pos, goal, d in cands:
            if time.time() - t0 > budget_s:
                break
            if prio == 0 and n0 >= S.EDGE_FLIPS_PER_RUN or prio == 1 and n1 >= S.OTHER_FLIPS_PER_RUN:
                continue
            n0 += prio == 0
            n1 += prio == 1
            m = solve71(rp, pos, goal, solver_ms)
            if m is None:
                continue
            solved += 1
            child = child_overrides71(W, rp, m, ov, rp.cons[:pos] + [goal])
            key2 = (seed, tuple(map(tuple, child)))
            if key2 in seen_children:
                continue
            seen_children.add(key2)
            counter += 1
            heapq.heappush(queue, (prio, counter, seed, child))
    got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
    log('%s runs %d solved %d  instructions %d/%d directions %d/%d  kept %d (base %d)  %.0fs  %s' % (key, runs, solved, got, total, taken, dirs, len(kept), n_base, time.time() - t0, STATS))
    save()
    return dict(kept=kept, instructions=(got, total), directions=(taken, dirs), runs=runs)


def main():
    global MAX_CALLS
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--budget-s', type=int, default=300)
    ap.add_argument('--fresh-seeds', type=int, default=6)
    ap.add_argument('--solver-ms', type=int, default=2500)
    ap.add_argument('--max-calls', type=int, default=MAX_CALLS)
    ap.add_argument('--scen', action='append', default=[], help='extra scenario files {row: scenarios} to start from')
    a = ap.parse_args()
    MAX_CALLS = a.max_calls
    psc = json.loads((PROJECT / 'tasks/fl66-partial-scenarios.json').read_text())
    for key in a.rows:
        base = [tuple(s) for s in psc.get(key, [])]
        for f in a.scen:
            d = json.loads(Path(f).read_text())
            base += [tuple(s) for s in d.get(key, [])]
        explore71(key, base, a.out, a.budget_s, a.fresh_seeds, a.solver_ms)


if __name__ == '__main__':
    main()
