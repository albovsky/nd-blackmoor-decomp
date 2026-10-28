#!/usr/bin/env python3
"""FL-70: solver-guided scenarios for the pending rows (both worlds).

The FL-67 prover (scripts/fl67_infeasible.py) over-approximates, so its models are not runnable (callee results, loops and memory after a call are unconstrained; raw z3 pointers wrap). This
tool uses the same instruction semantics (`fl67_infeasible.Machine`, fuzzed against Unicorn by fl67_selftest) but follows ONE concrete run of the ORIGINAL bytes, so the symbolic state is exact:

  * Unicorn runs a scenario (the `watch` hook of tests/fl40_world.py and tests/fl41_world.py records, per instruction, the eight registers, the flags, the number of callee stubs run, the writes and the reads);
  * `Replay` re-executes that trace symbolically: start eax ecx edx ebx esi edi are symbols, memory is ONE z3 array (so a store through one pointer and a load through another alias exactly), every callee
    stub returns symbols (`stk<k>_eax/ecx/edx`, the cells STUB_OVR sets) and applies the stores it really made, every conditional jump adds the direction it really took, `rep cmps/scas/movs/stos` are
    unrolled (the string-equality goal "all remaining bytes equal" is a candidate of its own), an instruction the machine does not model is replaced by the concrete state after it (a resync);
  * the candidates are the jumps whose other direction no kept scenario took: z3 solves `prefix and not condition` with soft constraints that keep every input at the parent's value (pointers stay where
    they were unless the target needs them elsewhere), the model becomes extra overrides on the parent, the child runs on the original, and a child that follows a path not seen before is explored in turn
    (a repair loop: a child that diverges from the prediction is just another trace to flip from).

Only the ORIGINAL runs here; the translation is compared afterwards (`fl66_tested.py check --scen FILE`), as for every generator. Nothing the shadow says is trusted: a wrong model costs one child.

  fl70_solve.py ROW [ROW ...] --out FILE [--budget-s N] [--fresh-seeds N] [--solver-ms N] [--selfcheck]        (run from outputs/blackmoor-decomp)
"""
import argparse
import collections
import heapq
import json
from pathlib import Path
import sys
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import z3
import capstone
from capstone import x86_const as X
import fl66_tested as T
import fl67_infeasible as P
import original_differential as od

M32 = 0xffffffff
STACK_LO, STACK_HI = od.STACK_BASE, od.STACK_BASE + od.STACK_SIZE
FLAG_BIT = {'cf': 0, 'pf': 2, 'af': 4, 'zf': 6, 'sf': 7, 'of': 11}
SYMBOLIC = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')
MAX_STEPS = 6000
HANG_STEPS = 1500
SOLVE_LIMIT = 40000
LIMIT0 = {}
REP_UNROLL = 64
CONST_WINDOW = 160
EDGE_FLIPS_PER_RUN = 64
OTHER_FLIPS_PER_RUN = 12
OCCURRENCES = 3
VERBOSE = False


class Resync(Exception):
    pass


def fcheck(e):
    return z3.simplify(e)


# ---- the concrete run -------------------------------------------------------------------------------------------------------------------------------------


class Rec:
    __slots__ = ('addr', 'regs', 'eflags', 'ncalls', 'nwrites', 'nreads')

    def __init__(self, addr, regs, eflags, ncalls, nwrites, nreads):
        self.addr, self.regs, self.eflags, self.ncalls, self.nwrites, self.nreads = addr, regs, eflags, ncalls, nwrites, nreads


def trace_run(W, row, seed, ov):
    """(Trace, [Rec], [(record index, address, size, value, writes so far, calls so far)]) of the original on a scenario"""
    import unicorn
    from unicorn import x86_const as UX
    recs, reads = [], []
    names = P.FULL
    regids = [getattr(UX, 'UC_X86_REG_' + n.upper()) for n in names]
    va, body = row['va'], row['body']

    def watch(uc, ensure, trace, sp):
        def code(uc_, address, size, user):
            if len(recs) >= MAX_STEPS:
                return
            recs.append(Rec(address, tuple(uc.reg_read(r) for r in regids), uc.reg_read(UX.UC_X86_REG_EFLAGS), len(trace.calls), len(trace.writes), len(reads)))

        def rd(uc_, access, address, size, value, user):
            if len(recs) >= MAX_STEPS or size > 8:
                return
            ensure(address)
            ensure(address + size - 1)
            reads.append((len(recs) - 1, address, size, int.from_bytes(bytes(uc.mem_read(address, size)), 'little'), len(trace.writes), len(trace.calls)))
        uc.hook_add(unicorn.UC_HOOK_CODE, code, begin=va, end=va + body - 1)
        uc.hook_add(unicorn.UC_HOOK_MEM_READ, rd)
    tr = W.run_original(row, seed, [tuple(o) for o in ov], watch=watch)
    return tr, recs, reads


# ---- the symbolic replay -----------------------------------------------------------------------------------------------------------------------------


class Replay(P.Machine):
    def __init__(self, row, image, insns, tr, recs, reads):
        super().__init__(row, image)
        self.insns, self.tr, self.recs, self.reads = insns, tr, recs, reads
        self.cons = []                  # hard constraints, in the order the run made them
        self.path = []                  # flippable decisions: dicts(kind, pos, addr, cond, alt, ...)
        self.softs = []                 # (pos in cons, expr): "this address stays where it was"
        self.rep_goals = []             # (pos, goal expr, addr)
        self.stub_syms = {}             # name -> (call k, register index, concrete value)
        self.init_cells = {}            # byte address -> initial value (read before anything wrote it)
        self.resyncs = collections.Counter()
        self.i = 0
        self.nocheck = False

    # concrete helpers
    def creg(self, rec, name):
        return rec.regs[P.FULL.index(name)]

    def eac(self, op):
        m = op.mem
        rec = self.recs[self.i]
        v = m.disp
        if m.base:
            v += self.creg(rec, self.ins.reg_name(m.base))
        if m.index:
            v += self.creg(rec, self.ins.reg_name(m.index)) * m.scale
        return v & M32

    # memory: the stack (the function's frame, its arguments) is one array, everything else another, so a pointer read does not drag the frame's stores into the query; a symbolic address is put
    # in the array its concrete value belongs to, and kept there by a hard constraint. Pins keep pointers where they were.
    def ea(self, st, op):
        a = super().ea(st, op)
        if op.type == X.X86_OP_MEM and op.mem.segment != X.X86_REG_FS:
            self.last_ac = self.eac(op)
            if not self.nopin and not z3.is_bv_value(a):
                self.softs.append((len(self.cons), a == P.bv(self.last_ac, 32)))
        return a

    nopin = False

    def space(self, st, a, op=None):
        if op is not None and op.mem.segment == X.X86_REG_FS:
            return 'fs'
        return self.space_of(a, getattr(self, 'last_ac', None))

    def space_of(self, a, conc):
        a = z3.simplify(a)
        if z3.is_bv_value(a):
            return 'frm' if STACK_LO <= a.as_long() < STACK_HI else 'mem'
        inside = STACK_LO <= conc < STACK_HI
        inr = z3.And(z3.UGE(a, P.bv(STACK_LO, 32)), z3.ULT(a, P.bv(STACK_HI, 32)))
        self.cons.append(inr if inside else z3.Not(inr))
        if not inside and conc < 0xffcfff00:
            self.cons.append(z3.ULT(a, P.bv(0xffcfff00, 32)))             # FL-72: the overrides at 0xffd00000 and above are not memory (STUB_WR, STUB_OVR, registers), so a model cannot put a pointer there
        return 'frm' if inside else 'mem'

    def mem_read(self, st, op, n):
        if op.mem.segment == X.X86_REG_FS:
            for (ri, addr, size, val, nw, nc) in self.reads:
                if ri == self.i and size == n:
                    return P.bv(val, 8 * n)
            raise Resync('fs read')
        a = self.ea(st, op)
        self.assume_ok(st, a, n)
        sp = self.space(st, a, op)
        arr = getattr(st, sp)
        if z3.is_bv_value(a):
            c = a.as_long()
            if P.IMAGE_BASE <= c and c + n <= P.DATA_START:
                self.const_facts(c, n)
            return self.load(arr, a, n)
        ac = self.last_ac
        if P.IMAGE_BASE <= ac and ac + n <= P.DATA_START:                # a table read at a symbolic index: an if-chain over the neighbours
            lo, hi = max(P.IMAGE_BASE, ac - CONST_WINDOW), min(P.DATA_START - n, ac + CONST_WINDOW)
            e = self.load(arr, a, n)
            for c in range(lo, hi + 1):
                e = z3.If(a == c, P.bv(int.from_bytes(self.image[c - P.IMAGE_BASE:c - P.IMAGE_BASE + n], 'little'), 8 * n), e)
            self.cons.append(z3.And(z3.ULE(P.bv(lo, 32), a), z3.ULE(a, P.bv(hi, 32))))
            return e
        return self.load(arr, a, n)

    @staticmethod
    def load(arr, a, n):
        e = P.Machine.load(arr, a, n)
        return z3.simplify(e) if z3.is_bv_value(a) else e

    def put_byte(self, st, addr, b):
        sp = 'frm' if STACK_LO <= addr < STACK_HI else 'mem'
        setattr(st, sp, z3.Store(getattr(st, sp), P.bv(addr, 32), P.bv(b, 8)))

    def step(self, st, ins):
        """FL-72: a jump through a table (`jmp [reg*4 + table]`, a switch) is a decision with one alternative per table entry that lies inside the function"""
        if ins.mnemonic == 'jmp' and ins.operands[0].type == X.X86_OP_MEM:
            m = ins.operands[0].mem
            if m.index and not m.base and m.segment != X.X86_REG_FS:
                idx = st.R[ins.reg_name(m.index)]
                targets = []
                for k in range(256):
                    cell = (m.disp + m.scale * k) & M32
                    if cell < P.IMAGE_BASE or cell + 4 > P.DATA_START:
                        break
                    t = int.from_bytes(self.image[cell - P.IMAGE_BASE:cell - P.IMAGE_BASE + 4], 'little')
                    if t not in self.insns:
                        break
                    targets.append(t)
                if targets:
                    self.path.append(dict(kind='switch', pos=len(self.cons), addr=ins.address, idx=idx, targets=targets, taken=None, cond=None, alt=None))
        return super().step(st, ins)

    # calls: the stub's results are symbols, its stores are what it really stored
    def call(self, st, ins):
        ks = self.cur_calls
        if not ks:
            raise Resync('call without a stub')
        k = ks[0]
        for ri, r in enumerate(('eax', 'ecx', 'edx')):
            name = 'stk%d_%s' % (k, r)
            st.R[r] = z3.BitVec(name, 32)
            self.stub_syms[name] = (k, ri, None)
        for at, data in self.tr.calls[k][7]:
            for j, b in enumerate(data):
                self.put_byte(st, at + j, b)
        nxt = self.recs[self.next_i]
        st.R['esp'] = P.bv(self.creg(nxt, 'esp'), 32)
        for f, bit in FLAG_BIT.items():
            st.F[f] = z3.BoolVal(bool(nxt.eflags >> bit & 1))

    def x87(self, st, ins):
        raise Resync('x87')

    # strings: unrolled with the concrete iteration count
    def string(self, st, ins, base, rep):
        if not rep:
            return super().string(st, ins, base, rep)
        size = {'b': 1, 'w': 2, 'd': 4}[base[-1]]
        kind = base[:-1]
        pre, post = self.recs[self.i], self.recs[self.next_i]
        total = self.creg(pre, 'ecx')
        n = (total - self.creg(post, 'ecx')) & M32
        if n > REP_UNROLL:
            raise Resync('long rep')
        ecx0 = st.R['ecx']
        self.cons.append(ecx0 == P.bv(total, 32))
        esi, edi = st.R['esi'], st.R['edi']
        esi_c, edi_c = self.creg(pre, 'esi'), self.creg(pre, 'edi')
        arrs = {'mem': st.mem, 'frm': st.frm}
        flags = None
        conts = []
        U = min(total, REP_UNROLL) if kind in ('cmps', 'scas') else n
        keep = None

        def ld(a, c):
            sp = self.space_of(a, c)
            return self.load(arrs[sp], a, size)

        def stz(a, c, v):
            sp = self.space_of(a, c)
            arrs[sp] = self.store(arrs[sp], a, v, size)
        for j in range(U):
            if kind == 'stos':
                self.assume_ok(st, edi, size)
                stz(edi, edi_c + j * size, z3.Extract(8 * size - 1, 0, st.R['eax']))
                edi = edi + size
            elif kind == 'movs':
                self.assume_ok(st, esi, size)
                self.assume_ok(st, edi, size)
                v = ld(esi, esi_c + j * size)
                stz(edi, edi_c + j * size, v)
                esi, edi = esi + size, edi + size
            else:
                b = ld(edi, edi_c + j * size)
                a = z3.Extract(8 * size - 1, 0, st.R['eax']) if kind == 'scas' else ld(esi, esi_c + j * size)
                self.assume_ok(st, edi, size)
                if kind == 'cmps':
                    self.assume_ok(st, esi, size)
                tmp = st.copy()
                self.alu(tmp, 'sub', a, b, 8 * size)
                zf = tmp.F['zf']
                flags = dict(tmp.F)
                conts.append(zf if ins.mnemonic.startswith('repe') else z3.Not(zf))
                edi = edi + size
                if kind == 'cmps':
                    esi = esi + size
            if j == n - 1:
                keep = (edi, esi, dict(arrs), flags)
        if n == 0:
            return None
        edi_n, esi_n, arrs_n, flags_n = keep
        for j in range(n - 1):
            self.cons.append(conts[j] if conts else z3.BoolVal(True))
        if conts:
            goal_pos = len(self.cons)
            if self.creg(post, 'ecx') != 0:                                   # stopped on the flag: the last iteration did not continue
                self.path.append(dict(kind='rep', pos=len(self.cons), addr=ins.address, cond=z3.Not(conts[n - 1]), alt=None, i=self.i))
                self.cons.append(z3.Not(conts[n - 1]))
            if U > n:
                self.rep_goals.append((goal_pos, z3.And(*conts[n - 1:U]), ins.address))
        st.mem, st.frm = arrs_n['mem'], arrs_n['frm']
        st.R['edi'] = edi_n
        if kind in ('movs', 'cmps'):
            st.R['esi'] = esi_n
        st.R['ecx'] = ecx0 - n
        if kind in ('cmps', 'scas'):
            st.F = dict(flags_n)
        return None

    # ---- the run -------------------------------------------------------------------------------------------------------------------------------

    def run(self):
        recs = self.recs
        # collapse the per-iteration records of a rep instruction
        steps = []
        k = 0
        while k < len(recs):
            ins = self.insns.get(recs[k].addr)
            j = k + 1
            if ins is not None and ins.mnemonic.startswith('rep'):
                while j < len(recs) and recs[j].addr == recs[k].addr:
                    j += 1
            steps.append((k, j))
            k = j
        R = {}
        r0 = recs[0]
        for n in P.FULL:
            R[n] = z3.BitVec('s_' + n, 32) if n in SYMBOLIC else P.bv(self.creg(r0, n), 32)
        F = {f: z3.BoolVal(bool(r0.eflags >> bit & 1)) for f, bit in FLAG_BIT.items()}
        arr = lambda nm: z3.Array(nm, z3.BitVecSort(32), z3.BitVecSort(8))
        st = P.State(R, F, arr('s_mem'), arr('s_frm'), arr('s_fs'), z3.BoolVal(True))
        self.split = False
        self.start_regs = {n: self.creg(r0, n) for n in SYMBOLIC}
        self.compute_init_cells()
        ncalls_done = 0
        for si, (i, j) in enumerate(steps):
            if si + 1 >= len(steps):
                break                                    # the last record is the ret (or the cut): nothing follows it
            self.i = i
            self.next_i = steps[si + 1][0]
            rec, nxt = recs[i], recs[self.next_i]
            ins = self.insns.get(rec.addr)
            self.cur_calls = []
            if ins is not None and ins.mnemonic == 'call':
                self.cur_calls = list(range(ncalls_done, nxt.ncalls))
                ncalls_done = nxt.ncalls
            elif nxt.ncalls > ncalls_done:
                ncalls_done = nxt.ncalls
            self.ins = ins
            if ins is None:
                break
            backup = st.copy()
            self.nopin = ins.mnemonic == 'lea'
            cons_n, path_n, soft_n, goal_n = len(self.cons), len(self.path), len(self.softs), len(self.rep_goals)
            try:
                res = self.step(st, ins)
                if not z3.is_true(st.pc):
                    self.cons.append(st.pc)
                    st.pc = z3.BoolVal(True)
                if res:
                    br = res[1]
                    target = ins.operands[0].imm & M32 if ins.operands and ins.operands[0].type == X.X86_OP_IMM else None
                    fall = ins.address + ins.size
                    taken = nxt.addr == target
                    held = br if taken else z3.Not(br)
                    self.path.append(dict(kind='br', pos=len(self.cons), addr=ins.address, cond=held, alt=(ins.address, fall if taken else target), i=i, taken=taken))
                    self.cons.append(held)
            except Exception as ex:
                del self.cons[cons_n:], self.path[path_n:], self.softs[soft_n:], self.rep_goals[goal_n:]
                self.resyncs[ins.mnemonic + ':' + type(ex).__name__] += 1
                st = self.resync(backup, i, nxt)
        self.final = st
        return self

    def resync(self, st, i, nxt):
        rec = self.recs[i]
        for idx, n in enumerate(P.FULL):
            if rec.regs[idx] != nxt.regs[idx] or n == 'esp':
                st.R[n] = P.bv(nxt.regs[idx], 32)
        for f, bit in FLAG_BIT.items():
            st.F[f] = z3.BoolVal(bool(nxt.eflags >> bit & 1))
        w0, w1 = rec.nwrites, nxt.nwrites
        for (a, n, v) in self.tr.writes[w0:w1]:
            for b in range(n):
                self.put_byte(st, a + b, (v >> (8 * b)) & 0xff)
        st.pc = z3.BoolVal(True)
        return st

    def compute_init_cells(self):
        """bytes read before the function (or a stub) wrote them: the inputs the scenario can set"""
        wrote = set()
        wi = 0
        ci = 0
        for (ri, addr, size, val, nw, nc) in self.reads:
            while wi < nw and wi < len(self.tr.writes):
                a, n, v = self.tr.writes[wi]
                wrote.update(range(a, a + n))
                wi += 1
            while ci < nc and ci < len(self.tr.calls):
                for at, data in self.tr.calls[ci][7]:
                    wrote.update(range(at, at + len(data)))
                ci += 1
            for b in range(size):
                x = addr + b
                if x not in wrote and x not in self.init_cells and not (P.IMAGE_BASE <= x < P.DATA_START):
                    self.init_cells[x] = (val >> (8 * b)) & 0xff

    # ---- the model of the start state --------------------------------------------------------------------------------------------------------------

    def input_softs(self):
        out = [z3.BitVec('s_' + n, 32) == P.bv(v, 32) for n, v in self.start_regs.items()]
        out += [z3.Select(array_of(a), P.bv(a, 32)) == P.bv(b, 8) for a, b in sorted(self.init_cells.items())]
        for name, (k, ri, _) in self.stub_syms.items():
            call = self.tr.calls[k]
            cv = (call[4], call[5], call[6])[ri]
            out.append(z3.BitVec(name, 32) == P.bv(cv, 32))
        return out

    def selfcheck(self):
        """index of the first hard constraint that the concrete inputs do not satisfy, or None"""
        sub = [(z3.BitVec('s_' + n, 32), P.bv(v, 32)) for n, v in self.start_regs.items()]
        mems = {'mem': z3.K(z3.BitVecSort(32), P.bv(0, 8)), 'frm': z3.K(z3.BitVecSort(32), P.bv(0, 8))}
        for a, b in sorted(self.init_cells.items()):
            nm = 'frm' if STACK_LO <= a < STACK_HI else 'mem'
            mems[nm] = z3.Store(mems[nm], P.bv(a, 32), P.bv(b, 8))
        for name, (k, ri, _) in self.stub_syms.items():
            call = self.tr.calls[k]
            sub.append((z3.BitVec(name, 32), P.bv((call[4], call[5], call[6])[ri], 32)))
        sub.append((ARR['mem'], mems['mem']))
        sub.append((ARR['frm'], mems['frm']))
        for idx, c in enumerate(self.cons):
            v = z3.simplify(z3.substitute(c, *sub))
            if not z3.is_true(v):
                return idx, v
        return None


ARR = {'mem': z3.Array('s_mem', z3.BitVecSort(32), z3.BitVecSort(8)), 'frm': z3.Array('s_frm', z3.BitVecSort(32), z3.BitVecSort(8))}


def array_of(addr):
    return ARR['frm'] if STACK_LO <= addr < STACK_HI else ARR['mem']


def store_chain(e):
    out = {}
    while z3.is_store(e):
        a, v = e.arg(1), e.arg(2)
        if z3.is_bv_value(a) and z3.is_bv_value(v):
            out.setdefault(a.as_long(), v.as_long())
        e = e.arg(0)
    return out


def solve(rp, pos, goal, ms, soft=True):
    """FL-72: first with every start register that began outside the frame kept below it (a model that points a register into the frame cannot be played: the frame cells are not scenario inputs), then without"""
    keep = []
    for n, v in rp.start_regs.items():
        if v < 0xffd00000 and not STACK_LO <= v < STACK_HI:
            r = z3.BitVec('s_' + n, 32)
            keep.append(z3.And(z3.ULT(r, P.bv(0xffd00000, 32)), z3.Or(z3.ULT(r, P.bv(STACK_LO, 32)), z3.UGE(r, P.bv(STACK_HI, 32)))))
    if keep:
        m = solve0(rp, pos, goal, ms, soft, keep)
        if m is not None:
            return m
    return solve0(rp, pos, goal, ms, soft, [])


def solve0(rp, pos, goal, ms, soft, extra):
    """a model of `prefix and goal`; the soft constraints (inputs and pointers stay as they were) are assumptions, dropped by their unsat core until the query is satisfiable"""
    s = z3.Solver()
    s.set('timeout', ms)
    s.add(*rp.facts)
    s.add(*extra)
    for c in rp.cons[:pos]:
        s.add(c)
    s.add(goal)
    lits = []
    if soft:
        softs = [e for p, e in rp.softs if p <= pos] + rp.input_softs()
        for k, e in enumerate(softs):
            b = z3.Bool('soft%d' % k)
            s.add(z3.Implies(b, e))
            lits.append(b)
    t0 = time.time()
    for _ in range(12):
        r = s.check(*lits)
        if r == z3.sat:
            return s.model()
        if r != z3.unsat or not lits or time.time() - t0 > ms / 1000 * 3:
            return None
        core = {str(c) for c in s.unsat_core()}
        if not core:
            return None
        lits = [b for b in lits if str(b) not in core]
    return None


def select_indices(exprs, cap=4000):
    """the index terms of every array read in the formulas"""
    out, seen, todo = [], set(), list(exprs)
    while todo and len(out) < cap:
        e = todo.pop()
        i = e.get_id()
        if i in seen:
            continue
        seen.add(i)
        if z3.is_app(e):
            if e.decl().kind() == z3.Z3_OP_SELECT and e.num_args() == 2:
                out.append(e.arg(1))
            todo.extend(e.children())
    return out


def child_overrides(W, rp, model, parent, formulas):
    """parent overrides plus every input the model sets differently from the parent's run"""
    special, cells = {}, {}
    for a, n, v in parent:
        if a >= W.REG_OVERRIDE or W.STUB_OVR <= a < W.STUB_OVR + 0x10000 or W.STUB_WR <= a < W.STUB_WR + 0x10000:
            special[a] = v
        else:
            for k in range(n):
                cells[a + k] = (v >> (8 * k)) & 0xff
    for n, v in rp.start_regs.items():
        val = model.eval(z3.BitVec('s_' + n, 32), model_completion=False)
        if z3.is_bv_value(val) and val.as_long() != v and n in W.REG_NAMES:
            special[W.REG_OVERRIDE + 4 * W.REG_NAMES.index(n)] = val.as_long()
    for name, (k, ri, _) in rp.stub_syms.items():
        val = model.eval(z3.BitVec(name, 32), model_completion=False)
        call = rp.tr.calls[k]
        if z3.is_bv_value(val) and val.as_long() != (call[4], call[5], call[6])[ri]:
            special[W.STUB_OVR + 16 * k + 4 * ri] = val.as_long()
    addrs = set(rp.init_cells)
    for idx in select_indices(formulas):
        v = model.eval(idx, model_completion=True)
        if z3.is_bv_value(v):
            addrs.add(v.as_long())
    for a in addrs:
        if P.IMAGE_BASE <= a < P.DATA_START or a >= 0xffd00000:
            continue
        b = model.eval(z3.Select(array_of(a), P.bv(a, 32)), model_completion=True).as_long()
        if rp.init_cells.get(a) == b and a not in cells:
            continue
        cells[a] = b
    out = []
    keys = sorted(cells)
    k = 0
    while k < len(keys):
        a = keys[k]
        n = 1
        while n < 4 and k + n < len(keys) and keys[k + n] == a + n:
            n += 1
        if n == 3:
            n = 2
        v = sum(cells[a + j] << (8 * j) for j in range(n))
        out.append([a, n, v])
        k += n
    out += [[a, 4, v] for a, v in sorted(special.items())]
    return out


def length_children(rp, ov, per_run=6):
    """FL-72: a `repne scasb` (strlen) whose length feeds a compare with an immediate: children whose string is one of the lengths around that immediate. The z3 replay unrolls at most REP_UNROLL
    iterations, so a branch that needs a string of 40,000 bytes (0x4e3cd7: `cmp ecx, 0x9c40; ja`) is out of its reach; the string is plain scenario memory, so the child sets those bytes directly."""
    recs, insns = rp.recs, rp.insns
    out, seen = [], set()
    k = 0
    while k < len(recs) and len(out) < per_run:
        ins = insns.get(recs[k].addr)
        j = k + 1
        if ins is None or not (ins.mnemonic.startswith('repne') and 'scasb' in ins.mnemonic):
            k = j
            continue
        while j < len(recs) and recs[j].addr == recs[k].addr:
            j += 1
        base = rp.creg(recs[k], 'edi')
        n = (rp.creg(recs[k], 'ecx') - rp.creg(recs[j], 'ecx')) & M32 if j < len(recs) else 0
        cur = max(n - 1, 0)
        imms = set()
        a = ins.address + ins.size
        for _ in range(12):
            nx = insns.get(a)
            if nx is None:
                break
            if nx.mnemonic == 'cmp' and len(nx.operands) == 2 and nx.operands[1].type == X.X86_OP_IMM:
                imms.add(nx.operands[1].imm & M32)
            a += nx.size
        for imm in sorted(imms, reverse=True):
            for t in (imm + 1, imm, imm - 1, imm + 2):
                if t < 0 or t == cur or t > LENGTH_CAP or (ins.address, t) in seen:
                    continue
                if base + t + 1 >= 0xffc00000 or base < 0x1000 or STACK_LO - t - 4 <= base < STACK_HI or base <= P.DATA_START and base + t >= P.IMAGE_BASE:
                    continue
                seen.add((ins.address, t))
                cells = {base + b: 1 for b in range(t)}
                cells[base + t] = 0
                out.append(parent_plus(ov, cells))
        k = j
    return out[:per_run]


def parent_plus(parent, cells):
    """parent overrides with bytes of `cells` replaced (grouped like child_overrides does); the special overrides stay as they were"""
    keep, mem = [], {}
    for a, n, v in parent:
        if a >= 0xffd00000:
            keep.append([a, n, v])
        else:
            for b in range(n):
                mem[a + b] = (v >> (8 * b)) & 0xff
    mem.update(cells)
    out = []
    keys = sorted(mem)
    k = 0
    while k < len(keys):
        a = keys[k]
        n = 1
        while n < 4 and k + n < len(keys) and keys[k + n] == a + n:
            n += 1
        if n == 3:
            n = 2
        out.append([a, n, sum(mem[a + j] << (8 * j) for j in range(n))])
        k += n
    return out + keep


LENGTH_CAP = 0x30000


# ---- the search --------------------------------------------------------------------------------------------------------------------------------------


def explore(key, base_scen, budget_s=300, fresh_seeds=6, solver_ms=6000, selfcheck=False, log=print, max_runs=100000):
    pool = T.pool_of(key)
    p = T.POOLS[pool]
    W, G = T.world(p['world'])
    row = T.row_info(pool, key)
    W.INSTRUCTION_LIMIT = LIMIT0.setdefault(id(W), W.INSTRUCTION_LIMIT)
    image = P.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = row['va'] - P.IMAGE_BASE
    insns = {i.address: i for i in md.disasm(bytes(image[off:off + row['body']]), row['va'])}
    ex, ed = set(), set()
    kept = []
    queue = []
    counter = 0
    seen_children, seen_paths = set(), set()
    t0 = time.time()
    execs = []
    for seed, ov in base_scen:
        tr = W.run_original(row, seed, [tuple(o) for o in ov])
        if tr.fault:
            continue
        execs.append((seed, [list(o) for o in ov], tr.executed))
        if not (tr.executed <= ex and tr.edges <= ed):
            ex |= tr.executed
            ed |= tr.edges
            kept.append([seed, [list(o) for o in ov]])
    n_base = len(kept)
    got0, total0, taken0, dirs0, missing0, untaken0 = G.covers(row, ex, ed)
    near = {a for a, _ in untaken0}                    # a run that executes the jump of an untaken direction is where the flip happens: those start first
    for seed, ov, executed in execs:
        heapq.heappush(queue, (0 if near & executed else 2, counter, seed, ov))
        counter += 1
    for k in range(fresh_seeds):
        heapq.heappush(queue, (3, counter, 1 + k, []))
        counter += 1
    runs = solved = 0
    while queue and time.time() - t0 < budget_s and runs < max_runs:
        pr, _, seed, ov = heapq.heappop(queue)
        runs += 1
        tr, recs, reads = trace_run(W, row, seed, ov)
        hung = bool(tr.fault) and 'instruction limit' in str(tr.fault)
        if (tr.fault and not hung) or not recs:
            continue
        if hung and not ex:                                       # FL-72: a row that has never completed is a spin loop: the world's limit costs seconds per run, so the search uses a short one
            W.INSTRUCTION_LIMIT = min(W.INSTRUCTION_LIMIT, SOLVE_LIMIT)
        if hung:                                                  # FL-72: a run that never ends is not a scenario, but its first iterations still show which input holds the loop (0x44cf01: a spin on a global)
            recs = recs[:HANG_STEPS]
            reads = [r for r in reads if r[0] < HANG_STEPS]
        elif not (tr.executed <= ex and tr.edges <= ed):
            if [seed, ov] not in kept:
                kept.append([seed, ov])
            ex |= tr.executed
            ed |= tr.edges
        got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
        if not missing and not untaken:
            break
        rp = Replay(row, image, insns, tr, recs, reads)
        try:
            rp.run()
        except Exception as e:
            log('  replay failed: %s: %s' % (type(e).__name__, str(e)[:100]))
            continue
        sig = tuple((d['addr'], d.get('taken'), d['kind']) for d in rp.path)
        if sig in seen_paths:
            continue
        seen_paths.add(sig)
        if selfcheck:
            bad = rp.selfcheck()
            log('  selfcheck: %s  steps %d path %d cons %d resync %s' % ('ok' if bad is None else 'FAIL at %s %s' % (bad[0], str(bad[1])[:80]), len(recs), len(rp.path), len(rp.cons), dict(rp.resyncs)))
        for child in length_children(rp, ov):
            key2 = (seed, tuple(map(tuple, child)))
            if key2 not in seen_children:
                seen_children.add(key2)
                counter += 1
                heapq.heappush(queue, (0, counter, seed, child))
        cands = []
        firsts = collections.Counter()
        for d in rp.path:
            if d['kind'] == 'br':
                new = d['alt'] not in ed
                if new:
                    cands.append((0, d['pos'], z3.Not(d['cond']), d))
                else:
                    firsts[d['alt']] += 1
                    if firsts[d['alt']] <= OCCURRENCES:
                        cands.append((1, d['pos'], z3.Not(d['cond']), d))
            elif d['kind'] == 'rep':
                cands.append((0, d['pos'], z3.Not(d['cond']), d))
            elif d['kind'] == 'switch':
                for k, t in enumerate(d['targets']):
                    if t not in ex:
                        cands.append((0, d['pos'], d['idx'] == k, dict(kind='switch', addr=d['addr'])))
        for pos, goal, addr in rp.rep_goals:
            cands.append((0, pos, goal, dict(kind='repgoal', addr=addr)))
        cands.sort(key=lambda c: (c[0], c[1]))
        n0 = n1 = 0
        for prio, pos, goal, d in cands:
            if prio == 0 and n0 >= EDGE_FLIPS_PER_RUN or prio == 1 and n1 >= OTHER_FLIPS_PER_RUN:
                continue
            n0 += prio == 0
            n1 += prio == 1
            t1 = time.time()
            m = solve(rp, pos, goal, solver_ms)
            if VERBOSE:
                log('   flip %s %s pos %d/%d prio %d -> %s %.1fs' % (d['kind'], hex(d['addr']), pos, len(rp.cons), prio, 'sat' if m is not None else 'none', time.time() - t1))
            if m is None:
                continue
            solved += 1
            child = child_overrides(W, rp, m, ov, rp.cons[:pos] + [goal])
            key2 = (seed, tuple(map(tuple, child)))
            if key2 in seen_children:
                continue
            seen_children.add(key2)
            counter += 1
            heapq.heappush(queue, (prio, counter, seed, child))
    got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
    log('%s runs %d solved %d  instructions %d/%d directions %d/%d  kept %d (base %d)  %.0fs' % (key, runs, solved, got, total, taken, dirs, len(kept), n_base, time.time() - t0))
    return dict(kept=kept, instructions=(got, total), directions=(taken, dirs), missing=[hex(x) for x in missing], untaken=[[hex(a), n] for a, n in untaken], runs=runs)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--budget-s', type=int, default=300)
    ap.add_argument('--fresh-seeds', type=int, default=6)
    ap.add_argument('--solver-ms', type=int, default=6000)
    ap.add_argument('--selfcheck', action='store_true')
    ap.add_argument('--verbose', action='store_true')
    ap.add_argument('--scen', action='append', default=[], help='extra scenario files {row: scenarios} to start from')
    a = ap.parse_args()
    global VERBOSE
    VERBOSE = a.verbose
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    psc = json.loads((PROJECT / 'tasks/fl66-partial-scenarios.json').read_text())
    for key in a.rows:
        base = [tuple(s) for s in psc.get(key, [])]
        for f in a.scen:
            d = json.loads(Path(f).read_text())
            base += [tuple(s) for s in d.get(key, [])]
        res = explore(key, base, a.budget_s, a.fresh_seeds, a.solver_ms, a.selfcheck)
        out[key] = res['kept']
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
