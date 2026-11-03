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
FWD_INVARIANTS = PROJECT / 'tests' / 'fl78_forward_invariants.json'       # FL-78: loop invariants for the generalised headers of a FORWARD window, per target (checked by the prover, never trusted)


def forward_key(mark, T):
    """the name of a forward window's target in tests/fl78_forward_invariants.json: 'JCC:taken|fall' for a jump direction, 'BLOCK:ins' (the start of the block T of the instruction) for an instruction"""
    return '%#x:%s' % (mark[1], mark[2]) if mark[0] == 'dir' else '%#x:ins' % T


def load_forward_invariants(va, mark, T):
    """FL-78: {header block address: [atom, ...]} declared for the forward window of the target `mark` ('dir', jcc, 'taken'|'fall' or 'ins', address; T is its block) of the function at `va` in tests/fl78_forward_invariants.json,
    {function: {"0x49da7c:fall": {header: [atom, ...]}, "0x49da7e:ins": {...}}}. The atoms are those of tests/fl73_invariants.json. They are kept at a header only if `check_forward_invariants` proves them for this window.
    They are separate from the whole-function and backward-window invariants because they need not hold for the runs that do not go through the target."""
    import json
    try:
        data = json.loads(FWD_INVARIANTS.read_text())
    except (OSError, ValueError):
        return {}
    return {int(h, 16): atoms for h, atoms in data.get(hex(va), {}).get(forward_key(mark, T), {}).items()}


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
    """FL-75: {block: esp - ebp at its first instruction} for a function that starts `push ebp; mov ebp, esp` and changes esp only by push, pop, add or sub with an immediate, `mov esp, ebp` and calls whose
    pops are known; a block that two paths reach with different values gets none, and so does everything behind an instruction that changes ebp (`pop ebp`, `leave`: the caller's frame pointer has no known tie to esp). A window starts in a fully general state (esp and ebp unrelated); this is the relation between them that every run has there."""
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
                if m in ('push', 'pop') and (len(ops) != 1 or ops[0].size != 4):        # a 16-bit push or pop moves esp by 2
                    good = False
                    break
                if m in ('enter', 'pusha', 'popa', 'pushal', 'popal', 'pushf', 'popf', 'pushfd', 'popfd'):
                    good = False
                    break
                if m == 'push':
                    d -= 4
                elif m == 'pop':
                    if regs in (['esp'], ['ebp']):                    # pop ebp restores the caller's frame pointer: the tie to this frame ends here
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
                elif m == 'leave':                                    # restores the caller's ebp: no relation behind it
                    good = False
                    break
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
                    if wr & {'esp', 'ebp', 'sp', 'bp'}:
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


def temps_of(an, S):
    """FL-78 (round 8): (L, delta) for a window that starts at block S under the stack-discipline assumption (`Analysis.temps_info`: L, the size of the locals; delta = esp - ebp at S), or None when the function does not qualify or the tie at S is unknown."""
    L = an.temps_info()
    delta = stack_delta(an).get(S)
    return None if L is None or delta is None or delta > -L else (L, delta)       # (esp inside the locals area at S: the pushes would land on locals)


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


def run_window(an, order, S, T, query, frame=False, want_state=False, start=None):
    """execute the window; `query` is ('dir', 'taken'|'fall') or ('ins', None); returns the formula to refute"""
    M = an.M
    saved, saved_t = M.split, M.temps
    M.split = bool(frame) and an.split_ok
    M.temps = temps_of(an, S) if frame == 'temps' else None
    # FL-73/75: `frame` adds the frame assumption; the caller has checked that no frame address can have been formed on the way (Analysis.frame_safe)
    try:
        incoming = {n: [] for n in order}
        incoming[S].append(start if start else (z3.BoolVal(True), P.State.start()))      # FL-78: `start` (condition, state) for a window that begins in a given state (prove_closed_loop)
        edge = {}
        ic = {}
        escapes, esc_seen = [], set()
        arrival = None
        gen_state, hdr_in, hdr_back, done = {}, {}, {}, set()           # FL-73: loop invariants (tests/fl73_invariants.json) assumed at a generalised header, proved below
        first_visit = set()                                             # FL-78 (round 9): the target is the only back edge of a loop (a `jne` to its own header): a run takes it for the first time with the header entered only from outside the loop, so the header is not generalised
        if query[0] == 'dir':
            for u, h in an.back:
                if u == T and {x for x, hh in an.back if hh == h} == {T} and any(t == h and k == query[1] for k, t in an.blocks[T]['succ']):
                    first_visit.add(h)
        preds, tag = {}, object()                                       # FL-78 review: the predecessors of each block (for the headers a run passed before a header), and the key of this window's invariant facts
        for node in order:
            items = incoming[node]
            if not items:
                ic[node] = z3.BoolVal(False)
                continue
            st = P.merge(items)
            ic[node] = z3.Or(*[c for c, _ in items]) if len(items) > 1 else items[0][0]
            if node != S and node in an.loops and node not in first_visit and any(h == node and u in incoming for u, h in an.back):
                regs, mem, fs = an.loop_effects(node)         # a loop header with a back edge in the window: the state of any iteration
                for r in P.FULL:
                    if r in regs:
                        st.R[r] = P.fresh(32, 'sp' if r in ('esp', 'ebp') else 'lp')
                if 'esp' in regs and 'ebp' not in regs and stack_delta(an).get(node) is not None:
                    M.facts.append(z3.Implies(ic[node], st.R['esp'] == st.R['ebp'] + P.bv(stack_delta(an)[node], 32)))       # FL-75: the pushes and pops of the body balance, the tie of esp to ebp at the header holds in every iteration
                for f in P.FLAGS:
                    st.F[f] = P.fresh_bool()
                st.fp = (None, None)                                                     # FL-78 (round 7): the loop may use the x87 unit, what the header state knew of st(0) and the status word is gone
                if mem:
                    st.mem = P.fresh_array()
                    fw = an.loop_frame_writes(node) if M.split and M.temps is None else None
                    if fw is None:
                        st.frm = P.fresh_array('fr')
                    else:                                                                # FL-78 (round 9): under the frame assumption the loop writes only these locals; the other frame bytes keep their value
                        arr = st.frm
                        for disp, size in fw:
                            for k in range(size):
                                arr = z3.Store(arr, st.R['ebp'] + P.bv(disp + k, 32), P.fresh(8, 'fb'))
                        st.frm = arr
                if fs:
                    st.fs = P.fresh_array('fa')
                if node in an.inv:
                    gen_state[node], hdr_in[node] = st.copy(), list(items)
                    M.inv_facts.append(((tag, node), z3.Implies(ic[node], P.inv_formula(M, st, an.inv[node]))))        # only runs that arrive at the header satisfy it (kept apart from M.facts: the proof of a header leaves its own fact out)
            if node == T and query[0] == 'ins':
                if want_state:                                      # FL-75: the merged state and condition on arrival at T, for a forward window that continues from there (returned only after the invariant and table checks below)
                    arrival = (ic[node], st.copy())
                if not gen_state:
                    break
                # an invariant was assumed at a loop header on the way: the blocks after T that close the loop are executed too, so that the invariant is proved inductive below
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
                    c = an.table_cond(st, here, last, t)
                    if last.address in an.cut and last.address not in esc_seen:       # FL-75: a table cut at its range check: the index may not leave the kept cells (checked below)
                        esc_seen.add(last.address)
                        escapes.append(an.table_escape(st, here, last))
                else:
                    c = here
                conds[(kind, t)] = z3.Or(conds[(kind, t)], c) if (kind, t) in conds else c
            if an.blocks[node].get('tail_exit') is not None and br is not None:
                edge[(node, 'taken', ('tail', an.blocks[node]['tail_exit']))] = z3.And(here, br)       # FL-78 (round 11 review): the conditional tail call is an edge of the query (not a successor)
            for (kind, t), c in conds.items():
                edge[(node, kind, t)] = c
                if (node, t) in an.back and t in gen_state:
                    hdr_back.setdefault(t, []).append((c, st, node))
                if node == T and not gen_state:
                    continue
                if t in incoming and t != S and (node, t) not in an.back:
                    incoming[t].append((c, st))
                    preds.setdefault(t, set()).add(node)
        for h, gs in gen_state.items():                                  # FL-73: the assumed invariants are inductive, over every back edge of the loop (all their sources were executed)
            atoms = an.inv[h]
            if any(u not in done for u, hh in an.back if hh == h and u in incoming):
                raise P.Unsupported('invariant at 0x%x: a back edge was not executed' % h)
            assumed = P.inv_formula(M, gs, atoms)
            before = {(tag, n) for n in P.reach_back(preds, h) if n in gen_state}      # FL-78 review: only the headers the run passes before this one; its own fact is what is being proved
            if an.check(assumed, only=before)[0] != 'sat':
                raise P.Unsupported('invariant at 0x%x is not satisfiable' % h)
            chk = lambda f: an.check(f, only=before)[0]
            for c, st_in in hdr_in[h]:
                bad = P.inv_failures(chk, M, None, c, st_in, atoms)
                if bad:
                    raise P.Unsupported('invariant at 0x%x does not hold on an entry edge (atoms %s)' % (h, bad))
            for c, st_b, src in hdr_back.get(h, []):
                upto = {(tag, n) for n in P.reach_back(preds, src) | {src} if n in gen_state}
                bad = P.inv_failures(lambda f: an.check(f, only=upto)[0], M, assumed, c, st_b, atoms)
                if bad:
                    raise P.Unsupported('invariant at 0x%x is not preserved by a back edge (atoms %s)' % (h, bad))
        for esc in escapes:
            if an.check(esc, STEP_MS)[0] != 'unsat':
                raise P.Unsupported('table escape in a window')
        if query[0] == 'ins':
            return arrival if want_state else ic[T]
        conds = [c for (n, kind, t), c in edge.items() if n == T and kind == query[1]]
        if not conds:
            return z3.BoolVal(False)
        return z3.Or(*conds) if len(conds) > 1 else conds[0]
    finally:
        M.split, M.temps = saved, saved_t


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


def discard_facts(an, kept):
    """FL-78: a window that is refused (an invariant it assumed was not proved, a table cut that does not hold) leaves the facts it assumed in `M.facts`, where every later query of the analysis would conjoin them; they are guarded by the
    window's own arrival conditions, which are formulas over the shared start symbols, so an invariant that was never proved must not stay. Drop what the window added, and the image bytes whose constant facts went with it are read again later."""
    n, keys, m = kept
    del an.M.facts[n:]
    del an.M.inv_facts[m:]
    an.M.fact_keys = keys


def check_forward_invariants(an, inv, gen_state, hdr_in, hdr_back, tie=None, preds=None, tag=None):
    """FL-78: every invariant that run_forward assumed at a generalised header holds on each entry edge from the window (initiation) and, assumed at the header, on each back edge (consecution), and is satisfiable. `tie` is the esp-to-ebp relation of the window's start (relate), which every real run has there."""
    M = an.M
    tie = z3.BoolVal(True) if tie is None else tie
    preds = preds or {}
    for h, gs in gen_state.items():
        atoms = inv[h]
        assumed = P.inv_formula(M, gs, atoms)
        before = {(tag, n) for n in P.reach_back(preds, h) if n in gen_state}       # FL-78 review: the invariants of the headers the run passes before this one, never its own (a loop without memory effects shares its entry state, so its own fact would make "holds on entry" trivially true)
        chk = lambda f, only=before: an.check(z3.And(tie, f), only=only)[0]
        if chk(assumed) != 'sat':
            raise P.Unsupported('forward invariant at 0x%x is not satisfiable' % h)
        for c, st_in in hdr_in[h]:
            bad = P.inv_failures(chk, M, None, c, st_in, atoms)
            if bad:
                raise P.Unsupported('forward invariant at 0x%x does not hold on an entry edge (atoms %s)' % (h, bad))
        for c, st_b, src in hdr_back.get(h, []):
            upto = {(tag, n) for n in P.reach_back(preds, src) | {src} if n in gen_state}
            bad = P.inv_failures(lambda f: chk(f, upto), M, assumed, c, st_b, atoms)
            if bad:
                raise P.Unsupported('forward invariant at 0x%x is not preserved by a back edge (atoms %s)' % (h, bad))


def run_forward(an, order, S, mark, frame=False, start=None, inv=None, tie=None, temps=None):
    """FL-75: the formula "a run that starts at S in ANY state, takes the marked edge (or executes the marked block), does not fault, and reaches a ret". Unsat means every run through the target faults later."""
    M = an.M
    saved, saved_t = M.split, M.temps
    M.split = bool(frame) and an.split_ok
    M.temps = temps if frame == 'temps' else None            # FL-78 (round 8): (L, delta) of the window that `start` came from
    try:
        incoming = {n: [] for n in order}
        incoming[S].append(start if start else (z3.BoolVal(True), P.State.start()))
        completions = []
        escapes, esc_seen = [], set()
        inv = inv or {}
        gen_state, hdr_in, hdr_back = {}, {}, {}                        # FL-78: invariants assumed at a generalised header of the window, proved after the walk
        preds, tag = {}, object()                                       # FL-78 review: predecessors of each block, and the key of this window's invariant facts
        for node in order:
            items = incoming[node]
            if not items:
                continue
            st = P.merge(items)
            ic = z3.Or(*[c for c, _ in items]) if len(items) > 1 else items[0][0]
            if node in an.loops and node != S and any(h == node and u in incoming for u, h in an.back):
                regs, mem, fs = an.loop_effects(node)
                if node in inv:                                                          # FL-78: the arrival at this header is a fresh Boolean `arr` that every real arrival implies. The long path condition then stays out of the
                    arr = P.fresh_bool('arr')                                            # consecution queries of the invariant (a run that arrives satisfies `arr`, so the facts guarded by it hold for it; a model with `arr` but no real arrival
                    M.facts.append(z3.Implies(ic, arr))                                  # only has more freedom, which can only make a refutation harder, never wrong)
                    ic = arr
                for r in P.FULL:
                    if r in regs:
                        st.R[r] = P.fresh(32, 'sp' if r in ('esp', 'ebp') else 'lp')
                if 'esp' in regs and 'ebp' not in regs and stack_delta(an).get(node) is not None:
                    M.facts.append(z3.Implies(ic, st.R['esp'] == st.R['ebp'] + P.bv(stack_delta(an)[node], 32)))         # as in run_window: the body balances the stack
                for f in P.FLAGS:
                    st.F[f] = P.fresh_bool()
                st.fp = (None, None)                                                     # FL-78 (round 7): the loop may use the x87 unit, what the header state knew of st(0) and the status word is gone
                if mem:
                    st.mem = P.fresh_array()
                    st.frm = P.fresh_array('fr')
                if fs:
                    st.fs = P.fresh_array('fa')
                if node in inv:                                                          # FL-78: assumed here (only for the runs that arrive), proved in check_forward_invariants
                    gen_state[node], hdr_in[node] = st.copy(), list(items)
                    M.inv_facts.append(((tag, node), z3.Implies(ic, P.inv_formula(M, st, inv[node]))))
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
            if last.mnemonic in ('ret', 'retn') or not an.blocks[node]['succ']:
                completions.append(here)                            # a ret, or a jmp / fall-through out of the body (a tail call): the run leaves the function without a fault
            if an.blocks[node].get('tail_exit') is not None and br is not None and not (node == S and mark[0] == 'dir' and mark[2] != 'taken'):
                completions.append(z3.And(here, br))                # FL-78 (round 11 review): `jcc callee`, taken: a conditional tail call, the run leaves the function without a fault
            for kind, t in an.blocks[node]['succ']:
                if node == S and mark[0] == 'dir' and kind != ('taken' if mark[2] == 'taken' else 'fall') and last.mnemonic.startswith('j') and last.mnemonic != 'jmp':
                    continue
                if kind == 'taken':
                    c = z3.And(here, br)
                elif kind == 'fall' and br is not None:
                    c = z3.And(here, z3.Not(br))
                elif kind == 'tbl':
                    c = an.table_cond(st, here, last, t)
                    if last.address in an.cut and last.address not in esc_seen:     # a table cut at its range check: the index may not leave the kept cells (checked below)
                        esc_seen.add(last.address)
                        escapes.append(an.table_escape(st, here, last))
                else:
                    c = here
                if (node, t) in an.back and t in gen_state:
                    hdr_back.setdefault(t, []).append((c, st, node))
                if (node, t) in an.back or t not in incoming or t == S:
                    continue                                   # a back edge: the header's state was generalised, the run continues from there
                incoming[t].append((c, st))
                preds.setdefault(t, set()).add(node)
        for esc in escapes:
            if an.check(esc, STEP_MS)[0] != 'unsat':
                raise P.Unsupported('table escape in a forward window')
        if set(inv) - set(gen_state):
            raise P.Unsupported('a forward invariant names a header that is not a generalised loop header of the window')
        check_forward_invariants(an, inv, gen_state, hdr_in, hdr_back, tie, preds, tag)
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
    for frame in (False, True, 'temps') if an.split_ok else (False,):
        for D in chain[:MAX_STARTS]:
            orderA = window(an, dom, D, T)
            if orderA is None:
                continue
            if frame == 'temps':
                if temps_of(an, D) is None:                           # FL-78 (round 8): the third pass: the stack-discipline assumption, for windows that the frame assumption cannot cover (an address of the frame was formed before)
                    continue
            elif frame and not an.frame_safe(D, list(orderA) + orderB):
                continue
            kept = len(an.M.facts), set(an.M.fact_keys), len(an.M.inv_facts)
            try:
                start = run_window(an, orderA, D, T, ('ins', None), frame, want_state=True)
                tie = relate(an, D, P.State.start())
                f = run_forward(an, orderB, T, mark, frame, start=start, inv=load_forward_invariants(an.va, mark, T), tie=tie, temps=temps_of(an, D))
            except P.Unsupported as ex:
                discard_facts(an, kept)
                if VERBOSE:
                    print('   forward D=%#x T=%#x frame=%s unsupported: %s' % (D, T, frame, ex), flush=True)
                continue
            f = z3.And(f, tie)
            r, h = an.check(f, timeout_ms)
            discard_facts(an, kept)                                      # FL-78 review: the facts of an accepted window concern its own symbols and must not stay in the queries that follow
            if VERBOSE:
                print('   forward D=%#x T=%#x blocks %d+%d frame=%s -> %s' % (D, T, len(orderA), len(orderB), frame, r), flush=True)
            if r == 'unsat':
                if frame == 'temps':
                    an.stack_discipline_used = True
                return 'unsat', h
            last = (r, h)
    return last


CLOSED_LOOP_OPS = frozenset(('mov', 'movzx', 'movsx', 'lea', 'cmp', 'test', 'add', 'sub', 'and', 'or', 'xor', 'inc', 'dec', 'neg', 'not', 'nop', 'push', 'pop', 'jmp'))      # FL-78: the instructions whose semantics in Machine.step are exact and make no fresh symbol


def exact_block(insns):
    """FL-78: True when every instruction of the block has exact semantics in the model: plain moves, arithmetic, compares, pushes and pops and direct jumps; no call (which makes fresh symbols for its effects), no string instruction or prefix, no fs access,
    no memory operand at an absolute address"""
    for i in insns:
        m = i.mnemonic
        if not (m in CLOSED_LOOP_OPS or m.startswith('j') and i.operands and i.operands[0].type == P.X.X86_OP_IMM):
            return False
        if i.prefix[0] or i.prefix[1] or any(o.type == P.X.X86_OP_MEM and o.mem.segment for o in i.operands):
            return False
        if m == 'jmp' and i.operands[0].type != P.X.X86_OP_IMM:
            return False
        if any(o.type == P.X.X86_OP_MEM and not o.mem.base and not o.mem.index for o in i.operands):
            return False                                                   # review: a lint, not a proof: no operand at an absolute (global) address (which another thread or a device could change while the loop spins); a register or a shared pointer can still hold one
    return True


def prove_closed_loop(an, dom, mark, timeout_ms=STEP_MS):
    """FL-78: ('unsat', hash) when every run that takes the marked direction ('dir', jcc, 'taken'|'fall') goes round a cycle for ever, else ('unknown'|'sat'|'unsupported', '').

    The marked edge leads, through blocks with one successor each, back to a block D that dominates the jump (the header of a loop); D, the blocks between D and the jump, and the blocks of that chain contain only instructions with exact semantics (`exact_block`:
    no call, no inner loop, no string instruction), so a state at D decides EXACTLY whether the run goes from D to the jump and takes the direction. C(s) is that condition, s'(s) the state at D after one more round (the jump block and the chain, executed
    symbolically). The prover shows  C(s) and tie(s) and not C(s'(s))  unsat: whenever a round starts at D in some state and takes the direction, the next round starts in a state that takes it again.
    SOUND: take a run that takes the direction. Its last visit of D before the jump (D dominates it) has some state s0 and goes through blocks of the window, so C(s0) holds, and the claim gives C(s1) for the state s1 after the round, and so on: the run
    goes round the same cycle for ever (or faults in it) and never reaches a ret. The scenarios kept for a row are runs that return, so none takes the direction.
    Assumption (RULE_TEXT2): the memory the cycle reads is changed only by the cycle itself (no other thread, interrupt, APC or device writes it while the loop spins). No operand of the cycle is at an absolute (global) address; this is a syntactic lint only (a register can hold a global or shared address, [ecx+4] can be shared), the proof relies on the shared-memory assumption above alone.
    The direction is 'closed-loop-proved': the C translation is not compared on it (no terminating run takes it), and prove_row records it in the `plan` of the proof record."""
    jcc, kind = mark[1], mark[2]
    T = block_of(an, jcc, True)
    if T is None or T not in an.reach:
        return 'unsupported', ''
    last = an.blocks[T]['insns'][-1]
    if not (last.mnemonic.startswith('j') and last.mnemonic != 'jmp') or last.operands[0].type != P.X.X86_OP_IMM:
        return 'unsupported', ''
    t = dict(an.blocks[T]['succ']).get(kind)
    if t is None:
        return 'unsupported', ''
    chain, cur = [], t
    while cur not in dom[T]:                                              # blocks with one successor each, up to a block that dominates the jump
        succ = an.blocks[cur]['succ'] if cur in an.blocks else None
        if not succ or len(succ) != 1 or cur in chain or len(chain) > 8 or cur in an.loops or not exact_block(an.blocks[cur]['insns']):
            return 'unsupported', ''
        if an.blocks[cur]['insns'][-1].mnemonic.startswith('j') and an.blocks[cur]['insns'][-1].mnemonic != 'jmp':
            return 'unsupported', ''
        chain.append(cur)
        cur = succ[0][1]
    D = cur
    orderA = window(an, dom, D, T)
    if orderA is None or any(n != D and n in an.loops for n in orderA) or not all(exact_block(an.blocks[n]['insns']) for n in orderA):
        return 'unsupported', ''
    M = an.M
    kept = len(M.facts), set(M.fact_keys), len(M.inv_facts)
    saved = M.split
    try:
        ic, st = run_window(an, orderA, D, T, ('ins', None), False, want_state=True)
        M.split = False
        st2 = st.copy()
        st2.pc = z3.BoolVal(True)
        br = None
        for i in an.blocks[T]['insns']:
            res = M.step(st2, i)
            if res:
                br = res[1]
        here = z3.And(ic, st2.pc)
        c = z3.And(here, br) if kind == 'taken' else z3.And(here, z3.Not(br))
        st2.pc = z3.BoolVal(True)
        for b in chain:
            for i in an.blocks[b]['insns']:
                M.step(st2, i)
        chain_ok = st2.pc
        st2.pc = z3.BoolVal(True)
        M.split = saved
        again = run_window(an, orderA, D, T, ('dir', kind), False, start=(z3.BoolVal(True), st2))
        f = z3.And(c, chain_ok, relate(an, D, P.State.start()), z3.Not(again))
        r, h = an.check(f, timeout_ms)
    except P.Unsupported:
        discard_facts(an, kept)
        return 'unsupported', ''
    finally:
        M.split = saved
    discard_facts(an, kept)
    if VERBOSE:
        print('   closed loop D=%#x T=%#x chain %d blocks %d -> %s' % (D, T, len(chain), len(orderA), r), flush=True)
    return r, h


def loop_chain(an, H):
    """FL-78 (round 10): the blocks of the loop of header H in order H -> ... -> latch -> H when the loop is a single cycle (every block has one successor inside the loop; a conditional jump may have the other one outside it) with no call, string
    instruction, prefix, segment operand or operand at an absolute address; else None"""
    L = an.loops.get(H)
    if not L:
        return None
    chain, cur = [H], H
    while True:
        inside = [t for k, t in an.blocks[cur]['succ'] if t in L]
        if len(inside) != 1:
            return None
        nxt = inside[0]
        if nxt == H:
            break
        if nxt in chain:
            return None
        chain.append(nxt)
        cur = nxt
    if set(chain) != set(L):
        return None
    for b in chain:
        last = an.blocks[b]['insns'][-1]
        if [t for k, t in an.blocks[b]['succ'] if t not in L] and not (last.mnemonic.startswith('j') and last.mnemonic != 'jmp' and len(an.blocks[b]['succ']) == 2):
            return None
        if last.mnemonic.startswith('j') and last.mnemonic != 'jmp' and len(an.blocks[b]['succ']) != 2:
            return None                                                    # (FL-78 round 11: a conditional tail call has its exit edge dropped: the loop may be left there)
        for i in an.blocks[b]['insns']:
            m = i.mnemonic
            if m == 'call' or m.startswith(('int', 'rep', 'lock')) or m.split()[-1] in P.ALL_STRING_OPS or i.prefix[0] or i.prefix[1]:
                return None
            if any(o.type == P.X.X86_OP_MEM and (o.mem.segment or (not o.mem.base and not o.mem.index)) for o in i.operands):
                return None
    return chain


def prove_trap_loop(an, dom, mark, timeout_ms=STEP_MS):
    """FL-78 (round 10): ('unsat', hash) when no run that takes the marked direction ('dir', jcc, 'taken'|'fall') ever leaves the loop it enters there, else ('unknown'|'sat'|'unsupported', '').

    The marked edge leads to the header H of a loop that is one cycle of blocks (`loop_chain`), whose only ways out are conditional jumps. The state s0 at that edge is the state of the window from the entry of the function to the jump (acyclic, no loop in it).
    CANDIDATES: each register, and each memory cell that an operand of the loop names (the address taken with the registers of s0), keeps the value it has in s0. Houdini: starting from all of them, a candidate that one round of the loop from an arbitrary state
    satisfying the others (fresh registers, flags and memories) does not preserve is dropped, until none is. What is left, I, is inductive and holds at s0 (it says: equal to s0). The proof is  I and (some exit jump is taken in this round)  unsat.
    SOUND: a run that takes the edge arrives at H in a state satisfying I; by induction every round starts in a state satisfying I and takes no exit, so the run goes round the loop for ever (or faults in it) and never reaches a ret. The scenarios kept for a row are runs that return, so none takes the direction.
    Assumptions (RULE_TEXT2): as for the closed-loop rule, the memory the loop reads is changed only by the loop itself (no other thread, interrupt, APC or device writes it while it spins; a lint refuses operands at absolute addresses); and the frame assumption when the
    window from the entry to the loop and the loop form no address of the frame (`frame_safe`), which the proof may rest on (`an.trap_loop_frame`). The direction is 'closed-loop-proved': the C translation is not compared on it."""
    jcc, kind = mark[1], mark[2]
    T = block_of(an, jcc, True)
    if T is None or T not in an.reach:
        return 'unsupported', ''
    last = an.blocks[T]['insns'][-1]
    if not (last.mnemonic.startswith('j') and last.mnemonic != 'jmp') or last.operands[0].type != P.X.X86_OP_IMM:
        return 'unsupported', ''
    H = dict(an.blocks[T]['succ']).get(kind)
    chain = loop_chain(an, H) if H is not None else None
    if chain is None or T in chain:
        return 'unsupported', ''
    D = min(dom[T], key=lambda n: len(dom[n]))
    orderA = window(an, dom, D, T)
    if orderA is None or any(n != D and n in an.loops for n in orderA):
        return 'unsupported', ''
    M = an.M
    kept = len(M.facts), set(M.fact_keys), len(M.inv_facts)
    saved, saved_t = M.split, M.temps
    try:
        frame = bool(an.split_ok and an.frame_safe(D, list(orderA) + chain))
        if frame and (M.cell_ops or an.cell_users or set(an.frame_formers) - set(an.esc_addrs)):      # (the leas that the cell rule cleared from esc_addrs)
            frame = False                                                # a function with a pointer cell: the registers of the arbitrary round (fresh) may hold the frame address the cell keeps, and a store through one is classed as memory, not frame
        _, st = run_window(an, orderA, D, T, ('ins', None), frame, want_state=True)
        M.split, M.temps = frame, None
        s0 = st.copy()
        s0.pc = z3.BoolVal(True)
        for i in an.blocks[T]['insns']:
            M.step(s0, i)
        s = P.State.start()                                           # the state of an arbitrary round: nothing known (names of the frame symbols as run_window gives them)
        s.R = {r: P.fresh(32, 'sp' if r in ('esp', 'ebp') else 'lp') for r in P.FULL}
        s.F = {f: P.fresh_bool() for f in P.FLAGS}
        s.mem, s.frm, s.fs = P.fresh_array(), P.fresh_array('fr'), P.fresh_array('fa')
        s.fp = (None, None)
        cands, seen = [], set()
        for r in P.FULL:
            cands.append((lambda x, r=r: x.R[r], s0.R[r]))
        for b in chain:
            for i in an.blocks[b]['insns']:
                for o in i.operands:
                    if o.type != P.X.X86_OP_MEM:
                        continue
                    key = (o.mem.base, o.mem.index, o.mem.scale, o.mem.disp, o.size)
                    if key in seen:
                        continue
                    seen.add(key)

                    def cell(x, i=i, o=o):
                        ref = x.copy()
                        ref.R = dict(s0.R)                                # the cell the operand names at s0
                        before, M.ins = M.ins, i
                        try:
                            return M.mem_read(ref, o, o.size)
                        finally:
                            M.ins = before
                    try:
                        cands.append((cell, cell(s0)))
                    except P.Unsupported:
                        continue
        s1 = s.copy()                                                    # one round from s: the condition of staying in the loop, and of leaving it
        s1.pc = z3.BoolVal(True)
        stay, leave = z3.BoolVal(True), z3.BoolVal(False)
        for b in chain:
            br = None
            for i in an.blocks[b]['insns']:
                res = M.step(s1, i)
                if res:
                    br = res[1]
            stay = z3.And(stay, s1.pc)
            s1.pc = z3.BoolVal(True)
            outs = [k for k, t in an.blocks[b]['succ'] if t not in an.loops[H]]
            if outs:
                cond = br if outs[0] == 'taken' else z3.Not(br)
                leave = z3.Or(leave, z3.And(stay, cond))
                stay = z3.And(stay, z3.Not(cond))
        tie = relate(an, H, s)
        now = [f(s) == v0 for f, v0 in cands]
        nxt = [f(s1) == v0 for f, v0 in cands]
        active = list(range(len(cands)))
        while True:
            inv = z3.And(tie, *[now[k] for k in active])
            drop = [k for k in active if an.check(z3.And(inv, stay, z3.Not(nxt[k])), timeout_ms)[0] != 'unsat']
            if not drop:
                break
            active = [k for k in active if k not in drop]
        r, h = an.check(z3.And(tie, *[now[k] for k in active], leave), timeout_ms)
        if r != 'unsat':
            return r, ''
        if frame:
            an.trap_loop_frame = True
        return 'unsat', h
    except P.Unsupported:
        return 'unsupported', ''
    finally:
        M.split, M.temps = saved, saved_t
        discard_facts(an, kept)


def prove_target(an, dom, T, query, timeout_ms=STEP_MS):
    """('unsat', hash, S) when some dominator window refutes the target, else ('unknown'|'sat', hash, S)"""
    chain = sorted(dom[T], key=lambda n: -len(dom[n]))        # nearest dominator first (T itself, then its immediate dominator, ...)
    last = ('unknown', '', None)
    for frame in (False, True, 'temps') if an.split_ok else (False,):      # FL-73: the second pass adds the frame assumption of the full analysis (frame slots are out of reach of stores through other pointers); FL-78 (round 8): the third the stack-discipline assumption
        for S in chain[:MAX_STARTS]:
            order = window(an, dom, S, T)
            if order is None:
                continue
            if frame == 'temps':
                if temps_of(an, S) is None or an.frame_safe(S, order):         # a window that the frame assumption covers has had its pass
                    continue
            elif frame and not an.frame_safe(S, order):             # FL-75: a function that forms a frame address somewhere still has frame-safe windows in front of that point
                continue
            kept = len(an.M.facts), set(an.M.fact_keys), len(an.M.inv_facts)
            try:
                f = run_window(an, order, S, T, query, frame)
            except P.Unsupported:
                discard_facts(an, kept)
                continue
            f = z3.And(f, relate(an, S, P.State.start()))               # FL-75: esp and ebp are not independent at S
            r, h = an.check(f, timeout_ms)
            discard_facts(an, kept)                                      # FL-78 review: as in prove_faults
            if VERBOSE:
                print('   window S=%#x blocks %d frame=%s -> %s' % (S, len(order), frame, r), flush=True)
            if r == 'unsat':
                if frame == 'temps':
                    an.stack_discipline_used = True
                return 'unsat', h, S
            last = (r, h, S)
    return last


def validate_cuts(an, dom):
    """FL-75: True when every jump table that the graph keeps cut at its range check is proved, for a start state at a dominator of the jump, to be indexed inside the cut. Then no run leaves the cut graph by a discarded cell:
    take the first run step that does; the run followed cut edges until then, so it passed the dominator S in some state, which the proof covers."""
    for jump in an.cut:
        J = block_of(an, jump)
        if J not in dom:
            continue                                                       # no run from the entry reaches the jump: the cut is never taken
        ok = False
        for S in sorted(dom[J], key=lambda n: -len(dom[n]))[:MAX_STARTS]:
            order = window(an, dom, S, J)
            if order is None:
                continue
            try:
                run_window(an, order, S, J, ('dir', 'taken'), False)       # executes the jump block and checks the escape condition of every cut jump on the way
            except P.Unsupported:
                continue
            ok = True
            break
        if not ok:
            return False
    return True


def from_analysis(an):
    """the analysis with its graph and dominators; jump tables are cut at their range check only when every cut is proved (`validate_cuts`), else whole, as a window that walked a discarded cell would be unsound"""
    an.build_blocks()
    an.graph()
    dom = dominators(an)
    if an.cut:
        kept = len(an.M.facts), set(an.M.fact_keys), len(an.M.inv_facts)
        ok = validate_cuts(an, dom)
        discard_facts(an, kept)                                          # facts the validation windows assumed concern their own fresh symbols only, and the image bytes whose constant facts went with them are read again later
        if not ok:
            an.tight_tables, an.cut = False, {}
            an._stack_delta = None                                       # computed on the cut graph
            an.build_blocks()
            an.graph()
            dom = dominators(an)
    return an, dom


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
