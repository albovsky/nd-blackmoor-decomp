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
        kept_extra = bool(extra and W.stub_filter(STATE['row'], extra))
        if kept_extra and writes:
            writes.pop()                                  # the parent's own extra store is modelled symbolically below
        for at, data in writes:
            for j, b in enumerate(data):
                st.mem = z3.Store(st.mem, P.bv(at + j, 32), P.bv(b, 8))
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

    def input_groups(self):
        """[(soft, value)]: one soft per input GROUP (a start register, a stub result, the bytes one load read together, a callee store) and the group's value as a bit-vector (None for a store); releasing a group is one move of the scenario"""
        out = [(z3.BitVec('s_' + n, 32) == P.bv(v, 32), z3.BitVec('s_' + n, 32)) for n, v in self.start_regs.items()]
        mem = z3.Array('s_mem', z3.BitVecSort(32), z3.BitVecSort(8))

        def cells(run):
            sel = [z3.Select(mem, P.bv(x, 32)) for x, y in run]
            return z3.And(*[e == P.bv(y, 8) for e, (x, y) in zip(sel, run)]), (z3.Concat(*reversed(sel)) if len(sel) > 1 else sel[0])
        run = []
        for a_, b_ in sorted(self.init_cells.items()):
            if run and (a_ != run[-1][0] + 1 or len(run) == 4):
                out.append(cells(run))
                run = []
            run.append((a_, b_))
        if run:
            out.append(cells(run))
        for name, (k, ri, _) in self.stub_syms.items():
            call = self.tr.calls[k]
            out.append((z3.BitVec(name, 32) == P.bv((call[4], call[5], call[6])[ri], 32), z3.BitVec(name, 32)))
        for k, (E, A, V, pe, pa, pv) in self.store_syms.items():
            out.append((z3.And(E, A == P.bv(pa, 32), V == P.bv(pv, 32)) if pe else z3.Not(E), None))
        return out

    def input_softs(self):
        return [e for e, v in self.input_groups()]

    def selfcheck(self):
        return None


def child_overrides71(W, rp, model, parent, formulas):
    out = S_child_overrides(W, rp, model, parent, formulas)
    ks = {k for k in rp.store_syms}
    drop = lambda a: W.STUB_WR <= a < W.STUB_WR + 0x10000 and (a - W.STUB_WR) // 16 in ks and ((a - W.STUB_WR) % 16) < 8
    out = [o for o in out if not drop(o[0])]
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


def solve71(rp, pos, goal, ms, soft=True):
    """1. the goal alone (plain solver); a model is then pulled back to the parent scenario input group by input group (revert a group when the query stays sat), so that a child changes only what the goal needs.
    2. when that does not finish (a product of two free 32-bit loads: z3 does not finish it), every input group is pinned (a product of two pinned inputs is a constant), the pinned query is unsat in a moment, and
    the groups are released one, two, three at a time until the query is sat. A verdict `unknown` is a loss of that goal, not an answer."""
    base = list(rp.facts) + list(rp.cons[:pos]) + [goal]
    pins = [e for p, e in rp.softs if p <= pos]
    ggroups = rp.input_groups()
    groups = [e for e, v in ggroups]
    t0 = time.time()

    def attempt(fixed, ms_):
        s = z3.Solver()
        s.set('timeout', ms_)
        s.add(*base)
        s.add(*fixed)
        r = s.check()
        return r, (s.model() if r == z3.sat else None), s

    r, m, s = attempt(pins, STEP_MS)                         # (pointers stay where they were)
    if r != z3.sat:
        r, m, s = attempt([], STEP_MS)
    if r == z3.unsat:
        STATS['unsat'] += 1
        return None
    if r == z3.sat:
        STATS['sat'] += 1
        s.set('timeout', REVERT_MS)
        for g, val in ggroups:                               # pull the model back to the parent, group by group; a group that has to differ gets the smallest value that still works (a loop count of 31,582 is a run of 6,000 steps)
            if time.time() - t0 > ms / 1000.0:
                break
            s.push()
            s.add(g)
            if s.check() == z3.sat:
                m = s.model()
                continue
            s.pop()
            if val is None:
                continue
            for small in SMALL:
                s.push()
                s.add(val == small)
                if s.check() == z3.sat:
                    m = s.model()
                    break
                s.pop()
        return m
    allp = pins + groups
    r, m, s = attempt(allp, STEP_MS)
    if r == z3.sat:
        STATS['sat'] += 1
        return m
    if r != z3.unsat:
        STATS['unknown'] += 1
        return None
    keep = list(range(len(allp)))
    for size in (1, 2, 3):
        sets = itertools.combinations(keep, size) if size == 1 else itertools.islice(itertools.combinations(keep, size), PAIR_CAP)
        for rel in sets:
            if time.time() - t0 > ms / 1000.0:
                STATS['unknown'] += 1
                return None
            r, m, s = attempt([allp[k] for k in keep if k not in rel], STEP_MS)
            if r == z3.sat:
                STATS['sat'] += 1
                return m
    STATS['unknown'] += 1
    return None


REVERT_MS = 800
SMALL = (1, 2, 3, 4, 8)
PAIR_CAP = 300
STEP_MS = 1500
S.solve = solve71

S.Replay = Replay71
S.child_overrides = child_overrides71
S.trace_run = trace_run71


def main():
    global MAX_CALLS
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--budget-s', type=int, default=300)
    ap.add_argument('--fresh-seeds', type=int, default=6)
    ap.add_argument('--solver-ms', type=int, default=6000)
    ap.add_argument('--max-calls', type=int, default=MAX_CALLS)
    ap.add_argument('--scen', action='append', default=[], help='extra scenario files {row: scenarios} to start from')
    a = ap.parse_args()
    MAX_CALLS = a.max_calls
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    psc = json.loads((PROJECT / 'tasks/fl66-partial-scenarios.json').read_text())
    for key in a.rows:
        base = [tuple(s) for s in psc.get(key, [])]
        for f in a.scen:
            d = json.loads(Path(f).read_text())
            base += [tuple(s) for s in d.get(key, [])]
        res = S.explore(key, base, a.budget_s, a.fresh_seeds, a.solver_ms)
        out[key] = res['kept']
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
