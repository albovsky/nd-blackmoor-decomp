#!/usr/bin/env python3
"""FL-65: value-goal scenarios for the unexplained survivors of upper rows.

  fl65_goals.py SURV.json ROW [ROW ...] --out FILE [--seeds 12] [--budget-s 600] [--per-capture 24]          (run from outputs/blackmoor-decomp)

SURV.json is the output of scripts/fl58_classify.py. For each unexplained survivor the instruction at its line is a probe. The original is run under the FL-61 shadow (scripts/fl61_concolic.py,
z3 expressions of everything that depends on the input) on corpus scenarios; at each probe the shadow keeps the registers before and after the instruction. Goals on those expressions, which the
random draws and the one-cell-at-a-time generator of scripts/fl62_target.py cannot reach together:
  a register changed by the instruction (what a dropped statement leaves behind), bits above the low byte or half set in what it wrote or in what it replaced (a narrower read, a partial-register mask),
  the sign bit, a non-zero old value.
Each goal is solved together with the path conditions that lead to the probe (the constraints that share input variables with it), and the model becomes a child scenario. A child is kept when the
original runs it to the end and the native translation agrees with it (as scripts/fl61_concolic.py does). FILE is {row: [[seed, overrides], ...]}, the format of `fl62_onerow.py --scen`.
"""
import argparse
import collections
import json
from pathlib import Path
import re
import sys
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl61_concolic as C
import fl62_concolic as F          # swaps the world, the lifter and the coverage rule of fl61_concolic for the FL-41 family
import fl41_world as W
import z3

GP = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')
MAX_CAPTURES = 3          # per probe address and run: the first occurrences


class ProbeRun(C.Run):
    probes = frozenset()
    jumps = {}          # jump address -> [(original condition, mutant condition)] as C texts over cf zf sf of

    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        self.caps = []                 # (address, path length, before, after); before and after: {register: (z3 expression or None, concrete value)}
        self.want_after = None
        self.counts = collections.Counter()

    def snapshot(self):
        snap = {r: (self.R.get(r), self.creg(r)) for r in GP}
        snap['flags'] = {f: self.flag(f) for f in ('CF', 'ZF', 'SF', 'OF')}
        return snap

    def step(self, uc, address, size, user):
        if not self.dead:
            try:
                self.sync(address)
                if self.want_after is not None:
                    a, plen, before = self.want_after
                    self.caps.append((a, plen, before, self.snapshot()))
                    self.want_after = None
                if address in self.probes and self.counts[address] < MAX_CAPTURES:
                    self.counts[address] += 1
                    self.want_after = (address, len(self.path), self.snapshot())
            except Exception:
                pass
        super().step(uc, address, size, user)


C.Run = ProbeRun


def value(item):
    expr, conc = item
    return expr if expr is not None else z3.BitVecVal(conc, 32)


def cond_expr(text, flags):
    """a C condition over cf zf sf of (`!`, `&&`, `||`, `==`, `!=`, parentheses) as a z3 Boolean (or a Python bool when every flag is concrete)"""
    toks = re.findall(r'cf|zf|sf|of|&&|\|\||==|!=|!|\(|\)', text)
    pos = [0]

    def b(x):
        return z3.BoolVal(x) if isinstance(x, bool) else x

    def peek():
        return toks[pos[0]] if pos[0] < len(toks) else None

    def take():
        pos[0] += 1
        return toks[pos[0] - 1]

    def atom():
        t = take()
        if t == '!':
            return z3.Not(b(atom()))
        if t == '(':
            v = orr()
            take()
            return v
        return b(flags[t.upper()])

    def eq():
        a = atom()
        while peek() in ('==', '!='):
            op = take()
            c = atom()
            a = (a == c) if op == '==' else (a != c)
        return a

    def andd():
        a = eq()
        while peek() == '&&':
            take()
            a = z3.And(a, eq())
        return a

    def orr():
        a = andd()
        while peek() == '||':
            take()
            a = z3.Or(a, andd())
        return a
    return orr()


def goals_of(before, after, addr=None):
    """-> [z3 Boolean] over the register expressions of one probe"""
    out = []
    for oc, mc in ProbeRun.jumps.get(addr, ()):
        try:
            out.append(z3.Xor(cond_expr(oc, before['flags']), cond_expr(mc, before['flags'])))          # the two conditions disagree on this run's flags
        except Exception:
            pass
    for r in GP:
        b, a = before[r], after[r]
        if b[0] is None and a[0] is None:
            continue
        bv, av = value(b), value(a)
        out.append(av != bv)
        out.append(z3.Extract(31, 8, av) != 0)
        out.append(z3.Extract(31, 16, av) != 0)
        out.append(z3.Extract(31, 8, bv) != 0)
        out.append(z3.Extract(31, 16, bv) != 0)
        out.append(z3.Extract(31, 31, av) == 1)
        out.append(bv != 0)
        out.append(z3.Extract(31, 31, bv) == 1)
        out.append(bv == 0)
        out.append(z3.And(av != bv, z3.Extract(7, 0, av) == z3.Extract(7, 0, bv)))          # only the bits above the low byte change
        out.append(z3.And(av != bv, z3.Extract(15, 0, av) == z3.Extract(15, 0, bv)))
    return out


def jump_conditions(key, text, surv_all):
    """{jump address: [(original condition, mutant condition)]} of the unexplained jump mutants of the row"""
    import random
    import fl41_mutation_check as M
    import fl65_cells as K
    lines = text.split('\n')
    idents = {}
    for mk, mn, mt in M.mutants(text, int(key, 16), random.Random(int(key, 16)), 100000, True):
        idents[(mk, mn, M.line_hash(mt, mn))] = mt.split('\n')[mn]
    out = collections.defaultdict(list)
    for k, n, ident, cls in surv_all.get('__mutants__', {}).get(key, []):
        if k != 'jump' or cls is not None:
            continue
        m = re.search(r'/\* (0x[0-9a-f]+):', lines[n])
        oc, mc = K.cond_of(lines[n]), K.cond_of(idents.get((k, n, ident), ''))
        if m and oc and mc:
            out[int(m.group(1), 16)].append((oc[0], mc[0]))
    return out


def probe_addresses(text, surv):
    at = {}
    for j, line in enumerate(text.split('\n')):
        m = re.search(r'/\* (0x[0-9a-f]+):', line)
        if m:
            at[j] = int(m.group(1), 16)
    return {at[n] for kind, rule, stmt, n in surv if rule is None and n in at}


AHEAD = 4          # conditions after the probe that a goal is combined with


def children(run, ov, per_capture, solver_ms):
    """For every probe, the models of (path to the probe and a register goal) and of (path to one of the next AHEAD jumps, that jump taken the other way or the same way, and a register goal): a mutant that leaves
    bits of a register different shows only where a later jump reads them, and the seeds took those jumps one way."""
    caps = [(a, plen, goals_of(before, after, a)) for a, plen, before, after in run.caps]
    sl = C.Slices()
    out = []
    used = collections.Counter()

    def attempt(ci, goal):
        if used[ci] >= per_capture:
            return
        model = C.solve(run, sl.group(goal), goal, solver_ms)
        if model is not None:
            used[ci] += 1
            out.append(C.model_overrides(run, model, ov))

    for idx, (kind, a, cond, info) in enumerate(run.path):
        for ci, (addr, plen, goals) in enumerate(caps):
            if plen == idx:
                for g in goals:
                    attempt(ci, g)
            if kind == 'br' and plen <= idx < plen + AHEAD:
                for g in goals:
                    attempt(ci, z3.And(z3.Not(cond), g))
                    attempt(ci, z3.And(cond, g))
        sl.add(cond if kind != 'sw' else cond == z3.BitVecVal(info[1], 32))
    for ci, (addr, plen, goals) in enumerate(caps):
        if plen == len(run.path):
            for g in goals:
                attempt(ci, g)
    return out


def scenarios(rowobj, seeds, probes, budget_s, per_capture, solver_ms=3000):
    row = rowobj.info
    ProbeRun.probes = frozenset(probes)
    t0 = time.time()
    seen = {C.key_of(*s) for s in seeds}
    kept, generated = [], 0
    for seed, ov in seeds:
        if time.time() - t0 > budget_s:
            break
        C._var_cache.clear()
        tr, run = C.trace_scenario(rowobj, seed, ov)
        if tr.fault:
            continue
        for child in children(run, ov, per_capture, solver_ms):
            generated += 1
            key = C.key_of(seed, child)
            if key in seen:
                continue
            seen.add(key)
            tr2 = W.run_original(row, seed, [tuple(o) for o in child])
            if tr2.fault:
                continue
            n = W.run_native(rowobj.native_lib(), row, seed, [tuple(o) for o in child])
            if n.fault or n.digest() != tr2.digest():
                continue
            kept.append([seed, child])
    print('%s value goals: %d children, %d valid  %.0fs' % (rowobj.key, generated, len(kept), time.time() - t0), flush=True)
    return kept


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('surv')
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--seeds', type=int, default=12)
    ap.add_argument('--budget-s', type=int, default=600)
    ap.add_argument('--per-capture', type=int, default=24)
    a = ap.parse_args()
    doc = json.loads(Path(a.surv).read_text())
    surv = doc['rows_with_survivors']
    surv['__mutants__'] = doc['mutants']
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    import fl41_mutation_check as M
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    for key in a.rows:
        rowobj = F.Row41(key)
        if rowobj.inline or rowobj.indirect:
            print(key, 'skipped: inline helper or indirect calls', flush=True)
            continue
        probes = probe_addresses(funcs[key], surv.get(key, []))
        ProbeRun.jumps = jump_conditions(key, funcs[key], surv)
        seeds = [(s[0], [list(o) for o in s[1]]) for s in corpus[key]['seeds']]
        step = max(1, len(seeds) // a.seeds)
        seeds = seeds[::step][:a.seeds]
        out[key] = scenarios(rowobj, seeds, probes, a.budget_s, a.per_capture)
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
