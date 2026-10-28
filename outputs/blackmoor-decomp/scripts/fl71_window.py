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


def stack_delta(an):
    """FL-75: {block: esp - ebp at its first instruction} for a function that starts `push ebp; mov ebp, esp` and changes esp only by push, pop, add or sub with an immediate, `mov esp, ebp`, leave and calls whose
    pops are known; a block that two paths reach with different values gets none. A window starts in a fully general state (esp and ebp unrelated); this is the relation between them that every run has there."""
    cached = getattr(an, '_stack_delta', None)
    if cached is not None:
        return cached
    out = {}
    first, second = an.insns[0], an.insns[1] if len(an.insns) > 1 else None
    ok = bool(second) and first.mnemonic == 'push' and first.op_str == 'ebp' and second.mnemonic == 'mov' and second.op_str == 'ebp, esp'
    if ok:
        E = -4                                                             # ebp - esp_entry after the prologue
        bad = set()
        entry = an.va
        # d = esp - esp_entry at the block start; the entry block starts at 0
        dd = {entry: 0}
        work = [entry]
        while work:
            b = work.pop()
            d = dd[b]
            good = True
            for i in an.blocks[b]['insns']:
                m = i.mnemonic
                ops = i.operands
                regs = [i.reg_name(o.reg) for o in ops if o.type == P.X.X86_OP_REG]
                if m == 'push':
                    d -= 4
                elif m == 'pop':
                    if regs == ['esp']:
                        good = False
                        break
                    d += 4
                elif m in ('sub', 'add') and regs[:1] == ['esp'] and ops[1].type == P.X.X86_OP_IMM:
                    d += (-1 if m == 'sub' else 1) * ops[1].imm
                elif m == 'mov' and regs == ['esp', 'ebp']:
                    d = E
                elif m == 'mov' and regs == ['ebp', 'esp']:
                    if i.address != second.address:
                        good = False
                        break
                elif m == 'leave':
                    d = E + 4
                elif m == 'call':
                    op = ops[0]
                    pops = None
                    if op.type == P.X.X86_OP_IMM:
                        pops = an.M.callees.get(op.imm & 0xffffffff)
                    elif op.type == P.X.X86_OP_MEM and not op.mem.base and not op.mem.index and (op.mem.disp & 0xffffffff) in an.M.imports:
                        pops = an.M.imports[op.mem.disp & 0xffffffff]
                    if pops is None:
                        pops = an.M.sites.get(i.address)
                    if pops is None:
                        good = False
                        break
                    d += pops
                else:
                    _, wr, _ = FPR(i)
                    if 'esp' in wr:
                        good = False
                        break
            if not good:
                bad.add(b)
                continue
            for t in an.succ[b]:
                if t in dd and dd[t] != d:
                    bad.add(t)
                elif t not in dd:
                    dd[t] = d
                    work.append(t)
        for b, d in dd.items():
            if b not in bad and b != an.va:
                out[b] = d - E
        # a block that was entered with a conflict (bad) has no entry; blocks only reachable through a bad block may carry a wrong value: drop everything downstream of a bad block
        down, work = set(), list(bad)
        while work:
            n = work.pop()
            for t in an.succ[n]:
                if t not in down:
                    down.add(t)
                    work.append(t)
        out = {b: v for b, v in out.items() if b not in down and b not in bad}
    an._stack_delta = out
    return out


def FPR(ins):
    rd, wr = ins.regs_access()
    names = lambda ids: {ins.reg_name(r) for r in ids}
    return names(rd), names(wr), None


def relate(an, S, st):
    """the formula  s_esp == s_ebp + delta  for the start state of a window at block S (True when the delta is unknown)"""
    delta = stack_delta(an).get(S)
    if delta is None:
        return z3.BoolVal(True)
    return st.R['esp'] == st.R['ebp'] + P.bv(delta, 32)


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


def run_window(an, order, S, T, query, frame=False, want_state=False):
    """execute the window; `query` is ('dir', 'taken'|'fall') or ('ins', None); returns the formula to refute"""
    M = an.M
    saved = M.split
    M.split = frame and an.split_ok     # FL-73/75: `frame` adds the frame assumption; the caller has checked that no frame address can have been formed on the way (Analysis.frame_safe)
    try:
        incoming = {n: [] for n in order}
        incoming[S].append((z3.BoolVal(True), P.State.start()))
        edge = {}
        ic = {}
        escapes, esc_seen = [], set()
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
                if want_state:                                      # FL-75: the merged state and condition on arrival at T, for a forward window that continues from there
                    return ic[node], st
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
                    if last.address in an.cut and last.address not in esc_seen:       # FL-75: a table cut at its range check: the index may not leave the kept cells (checked below)
                        esc_seen.add(last.address)
                        escapes.append(an.table_escape(st, here, last))
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
        for esc in escapes:
            if an.check(esc, STEP_MS)[0] != 'unsat':
                raise P.Unsupported('table escape in a window')
        if query[0] == 'ins':
            return ic[T]
        conds = [c for (n, kind, t), c in edge.items() if n == T and kind == query[1]]
        if not conds:
            return z3.BoolVal(False)
        return z3.Or(*conds) if len(conds) > 1 else conds[0]
    finally:
        M.split = saved


def forward_region(an, S):
    """FL-75: the blocks reachable from S in topological order (back edges of natural loops left out), or None when S lies on a cycle or a cycle that is not a natural loop is in the way"""
    seen, work = {S}, [S]
    while work:
        n = work.pop()
        for t in an.succ[n]:
            if t not in seen:
                seen.add(t)
                work.append(t)
    if len(seen) > MAX_WINDOW:
        return None
    if any(S in an.succ[n] for n in seen):                      # S is on a cycle: a later visit would take the other edge too
        return None
    indeg = {n: 0 for n in seen}
    for n in seen:
        for t in an.succ[n]:
            if (n, t) not in an.back:
                indeg[t] += 1
    order, ready = [], [S]
    while ready:
        n = ready.pop()
        order.append(n)
        for t in an.succ[n]:
            if (n, t) not in an.back:
                indeg[t] -= 1
                if indeg[t] == 0:
                    ready.append(t)
    return order if len(order) == len(seen) else None


def run_forward(an, order, S, mark, frame=False, start=None):
    """FL-75: the formula "a run that starts at S in ANY state, takes the marked edge (or executes the marked block), does not fault, and reaches a ret". Unsat means every run through the target faults later."""
    M = an.M
    saved = M.split
    M.split = frame and an.split_ok
    try:
        incoming = {n: [] for n in order}
        incoming[S].append(start if start else (z3.BoolVal(True), P.State.start()))
        completions = []
        for node in order:
            items = incoming[node]
            if not items:
                continue
            st = P.merge(items)
            ic = z3.Or(*[c for c, _ in items]) if len(items) > 1 else items[0][0]
            if node in an.loops and node != S and any(h == node and u in incoming for u, h in an.back):
                regs, mem, fs = an.loop_effects(node)
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
            st.pc = z3.BoolVal(True)
            ins = an.blocks[node]['insns']
            br = None
            for i in ins:
                if i.mnemonic == 'call' and i.operands[0].type == P.X.X86_OP_IMM and (i.operands[0].imm & 0xffffffff) in M.noreturn:
                    raise P.Unsupported('a call that never returns: runs can end without a ret')
                res = M.step(st, i)
                if res:
                    br = res[1]
            here = z3.And(ic, st.pc)
            last = ins[-1]
            if last.mnemonic in ('ret', 'retn'):
                completions.append(here)
            for kind, t in an.blocks[node]['succ']:
                if node == S and mark[0] == 'dir' and kind != ('taken' if mark[2] == 'taken' else 'fall') and last.mnemonic.startswith('j') and last.mnemonic != 'jmp':
                    continue
                if kind == 'taken':
                    c = z3.And(here, br)
                elif kind == 'fall' and br is not None:
                    c = z3.And(here, z3.Not(br))
                elif kind == 'tbl':
                    s2 = st.copy()
                    c = z3.And(here, M.mem_read(s2, last.operands[0], 4) == t)
                else:
                    c = here
                if (node, t) in an.back or t not in incoming or t == S:
                    continue                                   # a back edge: the header's state was generalised, the run continues from there
                incoming[t].append((c, st))
        if not completions:
            return z3.BoolVal(False)
        return z3.Or(*completions) if len(completions) > 1 else completions[0]
    finally:
        M.split = saved


def prove_faults(an, dom, mark, timeout_ms=STEP_MS):
    """FL-75: ('unsat', hash) when a dominator window in front of the target followed by a forward window from the target shows that no run which reaches the target returns without a fault, else
    ('unknown'|'sat'|'unsupported', ''). The first part is the backward window of prove_target (a fully general state at the dominator D, the blocks from D to the target), the second runs on from the target over the
    blocks it reaches; the formula is "arrive at the target, take the marked edge (or execute the marked block), and reach a ret with every fault assumption true"."""
    if mark[0] == 'dir':
        T = block_of(an, mark[1], True)
    else:
        T = block_of(an, mark[1])
    if T is None or T not in an.reach:
        return 'unsat', 'unreachable block'
    orderB = forward_region(an, T)
    if orderB is None:
        return 'unsupported', ''
    chain = sorted(dom[T], key=lambda n: -len(dom[n]))
    last = ('unknown', '')
    for frame in (False, True) if an.split_ok else (False,):
        for D in chain[:MAX_STARTS]:
            orderA = window(an, dom, D, T)
            if orderA is None:
                continue
            if frame and not an.frame_safe(D, list(orderA) + orderB):
                continue
            try:
                start = run_window(an, orderA, D, T, ('ins', None), frame, want_state=True)
                f = run_forward(an, orderB, T, mark, frame, start=start)
            except P.Unsupported:
                continue
            f = z3.And(f, relate(an, D, P.State.start()))
            r, h = an.check(f, timeout_ms)
            if VERBOSE:
                print('   forward D=%#x T=%#x blocks %d+%d frame=%s -> %s' % (D, T, len(orderA), len(orderB), frame, r), flush=True)
            if r == 'unsat':
                return 'unsat', h
            last = (r, h)
    return last


def prove_target(an, dom, T, query, timeout_ms=STEP_MS):
    """('unsat', hash, S) when some dominator window refutes the target, else ('unknown'|'sat', hash, S)"""
    chain = sorted(dom[T], key=lambda n: -len(dom[n]))        # nearest dominator first (T itself, then its immediate dominator, ...)
    last = ('unknown', '', None)
    for frame in (False, True) if an.split_ok else (False,):      # FL-73: the second pass adds the frame assumption of the full analysis (frame slots are out of reach of stores through other pointers)
        for S in chain[:MAX_STARTS]:
            order = window(an, dom, S, T)
            if order is None:
                continue
            if frame and not an.frame_safe(S, order):             # FL-75: a function that forms a frame address somewhere still has frame-safe windows in front of that point
                continue
            try:
                f = run_window(an, order, S, T, query, frame)
            except P.Unsupported:
                continue
            f = z3.And(f, relate(an, S, P.State.start()))               # FL-75: esp and ebp are not independent at S
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
