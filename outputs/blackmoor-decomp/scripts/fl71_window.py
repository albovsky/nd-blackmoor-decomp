#!/usr/bin/env python3
"""FL-71: dominator-window infeasibility proofs for the FL-67 prover (rule T-EQ-INFEASIBLE).

The FL-67 analysis (scripts/fl67_infeasible.py) executes the WHOLE function symbolically from its entry. For a 3 KB function with loops and many calls that gives up (z3 unknown / out of memory), although the target it
is asked about is decided by a handful of instructions just in front of it (`mov eax, 1; test eax, eax; je` after a `while (1)`; the same compare twice on a register that nothing changed in between).
A window proof asks the same question about the part of the function in front of the target only:

  * the target is an untaken jump direction (the block that ends in the jump) or an unexecuted instruction (its block);
  * S is a block that DOMINATES the target block T (every path from the entry to T passes through S), tried from T itself back up the dominator chain;
  * the window is R = every block that S dominates and from which T can be reached without going through S again, with the edges into S removed. R is closed under predecessors (except S). A natural loop inside R
    is treated as the full analysis treats a loop of plan `gen`: the header's state comes from its entry edges only and every register, flag and (if the loop stores or calls) memory that some instruction of the loop
    may change is replaced by a fresh symbol; any other cycle in R makes that S unusable;
  * at S the state is FULLY GENERALISED: eight fresh registers, fresh flags, fresh data/fs memory, and the frame assumption (`Machine.split`) is OFF, so this includes every state that any run can have when it
    reaches S. The blocks of R are executed with the same instruction semantics as the full analysis (all paths at once, if-then-else merges at joins), and the question is `incoming(T) and the direction condition`.

SOUND: take a run that reaches the target. Let S be the LAST visit of the dominator S before it (it passes S, because S dominates T). From that visit to T the run stays inside R (the blocks between are dominated by
S and reach T without S), enters R at S with some concrete state, which the fully generalised start state contains, and every edge it takes is an edge of R. So the run satisfies the window formula; if the formula
is unsat there is no such run. The assumptions along the way are the full analysis's own (a faulting access, a division by zero and a quotient overflow end the run, the image below .data is constant, the
direction flag is clear after a call), none of them stronger.

  fl71_window.py ROW [ROW ...]        prove every untaken target of the rows (as `fl66_tested.py` rows), print the verdict and the S that worked
"""
import argparse
import hashlib
from pathlib import Path
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import z3
import fl67_infeasible as P

MAX_WINDOW = 300            # blocks in a window
MAX_STARTS = 14             # dominators tried per target
STEP_MS = 8000
VERBOSE = bool(__import__('os').environ.get('FL71_VERBOSE'))


def dominators(an):
    """{block: set of dominating blocks} over the blocks reachable from the entry (iterative)"""
    seen = an.reach
    dom = {n: set(seen) for n in seen}
    dom[an.va] = {an.va}
    changed = True
    while changed:
        changed = False
        for n in an.rpo:
            if n == an.va:
                continue
            ps = [p for p in an.pred[n] if p in seen]
            new = (set.intersection(*[dom[p] for p in ps]) | {n}) if ps else {n}
            if new != dom[n]:
                dom[n] = new
                changed = True
    return dom


def window(an, dom, S, T):
    """the blocks of the window (S dominates, reaches T without S again) in topological order, or None when there is a cycle or the window is too big"""
    if S == T:
        return [S]
    back = set()
    work = [T]
    while work:                                           # blocks that reach T without passing S
        n = work.pop()
        if n in back:
            continue
        back.add(n)
        for p in an.pred[n]:
            if p != S and p in an.reach and p not in back:
                work.append(p)
    region = {n for n in back if S in dom[n]} | {S}
    if len(region) > MAX_WINDOW:
        return None
    for n in region:
        if n != S and any(p in an.reach and p not in region for p in an.pred[n]):
            return None                                   # not closed (cannot happen for a dominator; checked anyway)
    indeg = {n: 0 for n in region}
    for n in region:
        for t in an.succ[n]:
            if t in region and t != S and (n, t) not in an.back:
                indeg[t] += 1
    order, ready = [], [S]
    indeg[S] = 0
    while ready:
        n = ready.pop()
        order.append(n)
        for t in an.succ[n]:
            if t in region and t != S and (n, t) not in an.back:
                indeg[t] -= 1
                if indeg[t] == 0:
                    ready.append(t)
    if len(order) != len(region):
        return None                                       # a cycle that is not a back edge of a natural loop
    return order


def run_window(an, order, S, T, query, frame=False):
    """execute the window; `query` is ('dir', 'taken'|'fall') or ('ins', None); returns the formula to refute"""
    M = an.M
    saved = M.split
    M.split = saved and frame           # FL-73: `frame` keeps the full analysis's own frame assumption (only for a function that never forms the address of its frame)
    try:
        incoming = {n: [] for n in order}
        incoming[S].append((z3.BoolVal(True), P.State.start()))
        edge = {}
        ic = {}
        gen_state, hdr_in, hdr_back, done = {}, {}, {}, set()           # FL-73: loop invariants (tests/fl73_invariants.json) assumed at a generalised header, proved below
        for node in order:
            items = incoming[node]
            if not items:
                ic[node] = z3.BoolVal(False)
                continue
            st = P.merge(items)
            ic[node] = z3.Or(*[c for c, _ in items]) if len(items) > 1 else items[0][0]
            if node != S and node in an.loops and any(h == node and u in incoming for u, h in an.back):
                regs, mem, fs = an.loop_effects(node)         # a loop header with a back edge in the window: the state of any iteration
                for r in P.FULL:
                    if r in regs:
                        st.R[r] = P.fresh(32, 'sp' if r in ('esp', 'ebp') else 'lp')
                for f in P.FLAGS:
                    st.F[f] = P.fresh_bool()
                if mem:
                    st.mem = P.fresh_array()
                    st.frm = P.fresh_array('fr')
                if fs:
                    st.fs = P.fresh_array('fa')
                if node in an.inv:
                    gen_state[node], hdr_in[node] = st.copy(), list(items)
                    M.facts.append(P.inv_formula(M, st, an.inv[node]))
            if node == T and query[0] == 'ins':
                break
            done.add(node)
            st.pc = z3.BoolVal(True)
            ins = an.blocks[node]['insns']
            br = None
            for i in ins:
                res = M.step(st, i)
                if res:
                    br = res[1]
            here = z3.And(ic[node], st.pc)
            last = ins[-1]
            conds = {}
            for kind, t in an.blocks[node]['succ']:
                if kind == 'taken':
                    c = z3.And(here, br)
                elif kind == 'fall' and br is not None:
                    c = z3.And(here, z3.Not(br))
                elif kind == 'tbl':
                    s2 = st.copy()
                    v = M.mem_read(s2, last.operands[0], 4)
                    c = z3.And(here, v == t)
                else:
                    c = here
                conds[(kind, t)] = z3.Or(conds[(kind, t)], c) if (kind, t) in conds else c
            for (kind, t), c in conds.items():
                edge[(node, kind, t)] = c
                if (node, t) in an.back and t in gen_state:
                    hdr_back.setdefault(t, []).append((c, st))
                if node == T:
                    continue
                if t in incoming and t != S and (node, t) not in an.back:
                    incoming[t].append((c, st))
        for h, gs in gen_state.items():                                  # FL-73: the assumed invariants are inductive, over every back edge of the loop (all their sources were executed)
            atoms = an.inv[h]
            if any(u not in done for u, hh in an.back if hh == h and u in incoming):
                raise P.Unsupported('invariant at 0x%x: a back edge was not executed' % h)
            assumed = P.inv_formula(M, gs, atoms)
            if an.check(assumed)[0] != 'sat':
                raise P.Unsupported('invariant at 0x%x is not satisfiable' % h)
            chk = lambda f: an.check(f)[0]
            for c, st_in in hdr_in[h]:
                bad = P.inv_failures(chk, M, None, c, st_in, atoms)
                if bad:
                    raise P.Unsupported('invariant at 0x%x does not hold on an entry edge (atoms %s)' % (h, bad))
            for c, st_b in hdr_back.get(h, []):
                bad = P.inv_failures(chk, M, assumed, c, st_b, atoms)
                if bad:
                    raise P.Unsupported('invariant at 0x%x is not preserved by a back edge (atoms %s)' % (h, bad))
        if query[0] == 'ins':
            return ic[T]
        conds = [c for (n, kind, t), c in edge.items() if n == T and kind == query[1]]
        if not conds:
            return z3.BoolVal(False)
        return z3.Or(*conds) if len(conds) > 1 else conds[0]
    finally:
        M.split = saved


def prove_target(an, dom, T, query, timeout_ms=STEP_MS):
    """('unsat', hash, S) when some dominator window refutes the target, else ('unknown'|'sat', hash, S)"""
    chain = sorted(dom[T], key=lambda n: -len(dom[n]))        # nearest dominator first (T itself, then its immediate dominator, ...)
    last = ('unknown', '', None)
    for frame in (False, True) if an.M.split else (False,):      # FL-73: the second pass adds the frame assumption of the full analysis (frame slots are out of reach of stores through other pointers)
        for S in chain[:MAX_STARTS]:
            order = window(an, dom, S, T)
            if order is None:
                continue
            try:
                f = run_window(an, order, S, T, query, frame)
            except P.Unsupported:
                continue
            r, h = an.check(f, timeout_ms)
            if VERBOSE:
                print('   window S=%#x blocks %d frame=%s -> %s' % (S, len(order), frame, r), flush=True)
            if r == 'unsat':
                return 'unsat', h, S
            last = (r, h, S)
    return last


def from_analysis(an):
    an.build_blocks()
    an.graph()
    return an, dominators(an)


def prepare(key, image=None):
    image = image or P.load_image()
    return from_analysis(P.Analysis(P.row_of(key), image, STEP_MS))


def block_of(an, addr, last_only=False):
    for a, b in an.blocks.items():
        if last_only:
            if b['insns'][-1].address == addr:
                return a
        elif any(i.address == addr for i in b['insns']):
            return a
    return None


def prove_row_windows(an, dom, targets):
    """targets as for fl67_infeasible.prove_row; {'instructions': {addr: [verdict, hash]}, 'directions': {...}} for the ones a window refutes"""
    out = {'instructions': {}, 'directions': {}}
    memo = {}
    for a, name in targets.get('untaken', []):
        a = int(a, 16) if isinstance(a, str) else a
        T = block_of(an, a, True)
        if T is None or T not in an.reach:
            continue
        q = ('dir', 'taken' if name == 'taken' else 'fall')
        v = memo.get((T, q)) or memo.setdefault((T, q), prove_target(an, dom, T, q))
        if v[0] == 'unsat':
            out['directions']['%s:%s' % (hex(a), name)] = [v[0], v[1]]
    for a in targets.get('missing', []):
        a = int(a, 16) if isinstance(a, str) else a
        T = block_of(an, a)
        if T is None or T not in an.reach:
            continue
        v = memo.get((T, 'ins')) or memo.setdefault((T, 'ins'), prove_target(an, dom, T, ('ins', None)))
        if v[0] == 'unsat':
            out['instructions'][hex(a)] = [v[0], v[1]]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--targets', help='json file {row: {"missing": [...], "untaken": [[addr, name]]}}')
    a = ap.parse_args()
    import json
    given = json.loads(Path(a.targets).read_text()) if a.targets else {}
    for key in a.rows:
        an, dom = prepare(key)
        targets = given.get(key) or P.all_targets(an.row)
        res = prove_row_windows(an, dom, targets)
        print(key, 'directions', res['directions'].keys(), 'instructions', len(res['instructions']))


if __name__ == '__main__':
    main()
