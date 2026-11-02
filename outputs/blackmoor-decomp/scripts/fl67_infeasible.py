#!/usr/bin/env python3
"""FL-67: machine-checked infeasibility proofs for the "tested equivalent" tier (rule T-EQ-INFEASIBLE).

A pending row that agrees with the original everywhere it was run but misses some instruction or jump direction is TESTED EQUIVALENT BY PROOF when
every missing item is provably unreachable: no start state of the function (registers, flags, memory, any behaviour of the callees) executes it
in a run that does not fault. The proof is an exhaustive symbolic execution of the ORIGINAL BYTES with z3:

  * the function is cut into basic blocks (linear disassembly of the body, exactly the instruction set `original_differential.instruction_addresses`
    and the jump set `fl28b_fixtures.conditional_edges` that the coverage check counts);
  * every block gets an incoming condition `ic(B)` (a z3 Boolean over the start symbols) and a symbolic state (eight registers, the flags, memory as
    an SMT array); at a join the states are merged with if-then-else on the edge conditions, so all paths are explored at once, none are sampled;
  * a loop header is replaced by a GENERALISED state that is sound for every iteration: every register, every flag and (if the loop stores or calls)
    memory that some instruction of the loop may change becomes a fresh unconstrained symbol; the conditions that held on the way in stay true;
  * a call returns unconstrained eax/ecx/edx, unconstrained memory (a callee may store anywhere), and esp + the bytes the callee pops (the row's
    own `callees`/`sites`/`imports` table); ebx/esi/edi/ebp are preserved (the Win32 calling convention; the world's recording stubs do the same);
  * x87 instructions are over-approximated (a store of x87 data writes unconstrained bytes, fnstsw ax gives an unconstrained ax);
  * an access whose address is at or above 0xfff00000, a division by zero and a quotient overflow FAULT in the world; a run that faults is not
    a scenario (scripts/fl66_tested.py skips it), so those conditions are assumed true on the way (a prefix of the run: this only removes states);
  * a call to a callee that the row lists as never returning (tests/fl72_noreturn.json: AfxEndThread, which ends the thread) ends the run: nothing after it is reachable (FL-72);
  * bytes of the image below .data are constants (`DATA_START`); the direction flag is clear at entry and after calls (Win32 ABI);
  * FL-75: a direct callee whose own straight-line bytes end `and eax, K; ret` returns eax <= K (`Machine.ret_bound`, e.g. the CRT rand); a jump table is cut at the range check in front of the jump (`Analysis.tighten`) and
    the prover requires, per jump, that no run can index past the cut (`table_escape` unsat), else the whole table is used as before; a window in front of the first frame address gets the frame assumption too (`Analysis.frame_safe`).

A target (instruction or jump direction) is UNREACHABLE when the solver proves `ic(block) and branch condition` unsatisfiable. A target the
solver cannot decide, or a function with an instruction the model does not know, gets NO proof. Everything over-approximates, so unsat is sound.

  fl67_infeasible.py ROW [ROW ...]            analyse the rows (as `fl66_tested.py` rows) and print the verdict per untaken target
  fl67_infeasible.py --selftest N             fuzz the instruction semantics against Unicorn on N random single instructions of the game
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import random
import re
import struct
import sys
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))

import z3
import capstone
from capstone import x86_const as X

z3.set_param('memory_max_size', int(os.environ.get('FL67_MEM_MB', '3500')))        # a query that needs more is `unknown`, never a verdict (and never an out-of-memory kill)

CHECKER_VERSION = 2
SPLIT = True                  # the frame assumption (module text), applied to functions that never hand out a frame address
UNROLL = (3, 5, 9, 17)         # trip-count bounds tried per loop; a loop that can still iterate after the last one gets a generalised header
HINT_ONLY = 33                 # FL-78 (round 7): a bound that only tests/fl75_plans.json can ask for (a loop that shifts a 32 bit register to zero runs at most 32 times); the search never tries it
MAX_NODES = 6000
SINK_MS = 3000                 # the check that a loop cannot run past its unrolled copies; unknown counts as can
REP_EXACT = 64
FAULT_LIMIT = 0xfff00000      # an access at or above it faults in the world (tests/fl41_world.py)
DATA_START = 0x537000         # first writable page of .data; the image below it is constant
IMAGE_BASE = 0x400000
FLAGS = ('cf', 'zf', 'sf', 'of', 'pf', 'af')
PLANS = PROJECT / 'tests' / 'fl75_plans.json'                     # FL-75: starting loop plan per function (a choice of abstraction, never trusted: a numeric bound is still checked by sink_unsat and bumped when it is too small)
INVARIANTS = PROJECT / 'tests' / 'fl73_invariants.json'          # FL-73: loop invariants for generalised headers (CHECKED by the prover itself, never trusted)
# FL-78 (decision taken as the recommended default under the 2-hour rule): a frame address that is handed to one of these library functions as a SOURCE argument does not switch the frame assumption off. Address -> (name, destination argument
# positions, counted from the last pushed). The assumption (RULE_TEXT2): the function writes only through its destination argument, reads through its other pointer arguments and keeps no copy of any of them. A frame address in a destination position is
# not covered (that needs a model of how far the write reaches). 0x50ca3e is the MSVC CRT sprintf (a FILE on the stack with _ptr = the buffer, _cnt = 0x7fffffff, then _output).
# Review round 3 (0x418e52): 0x50d0a9 is the CRT fopen (a thunk: push 0x40; push mode; push name; call _fsopen; it only reads its two strings); 0x50cf61 is fread(buf, size, count, stream) (lock the stream, _fread_lk: imul size*count, copy
# from the stream into buf, unlock): it writes at most size*count bytes at buf; 0x50cd72 is _makepath(path, drive, dir, fname, ext) (copies the pieces into path, the length is the sum of theirs). An entry with a third element lists a function that
# WRITES through the frame address in a destination position (an optional fourth element lists the only positions where a frame address is accepted: fread also writes through its stream argument, so there it is the buffer only): ('mul', a, b) = at most arg a * arg b bytes (both pushed as immediates), None = any bytes of the frame (the call is modelled as overwriting the whole frame and memory).
LIBRARY_WRITERS = {0x50ca3e: ('sprintf', (0,)), 0x50d0a9: ('fopen', ()), 0x50d8e0: ('strstr', ()), 0x50cf61: ('fread', (0,), ('mul', 1, 2), (0,)), 0x50cd72: ('_makepath', (0,), None)}
_INV_OPS = {'eq': lambda v, c: v == c, 'ne': lambda v, c: v != c, 'sge': lambda v, c: v >= c, 'sgt': lambda v, c: v > c, 'sle': lambda v, c: v <= c,
            'slt': lambda v, c: v < c, 'uge': z3.UGE, 'ugt': z3.UGT, 'ule': z3.ULE, 'ult': z3.ULT}
FULL = ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')
REGS = {}
for _i, _f in enumerate(FULL):
    REGS[_f] = (_f, 4, 0)
    REGS[_f[1:]] = (_f, 2, 0)
for _f, _l in (('eax', 'a'), ('ecx', 'c'), ('edx', 'd'), ('ebx', 'b')):
    REGS[_l + 'l'] = (_f, 1, 0)
    REGS[_l + 'h'] = (_f, 1, 8)

CC = {'e': 'e', 'z': 'e', 'ne': 'ne', 'nz': 'ne', 'b': 'b', 'c': 'b', 'nae': 'b', 'ae': 'ae', 'nb': 'ae', 'nc': 'ae', 'be': 'be', 'na': 'be', 'a': 'a', 'nbe': 'a',
      'l': 'l', 'nge': 'l', 'ge': 'ge', 'nl': 'ge', 'le': 'le', 'ng': 'le', 'g': 'g', 'nle': 'g', 's': 's', 'ns': 'ns', 'o': 'o', 'no': 'no', 'p': 'p', 'pe': 'p', 'np': 'np', 'po': 'np'}


class Unsupported(Exception):
    pass


_fresh = [0]


def fresh(bits, tag='h'):
    _fresh[0] += 1
    return z3.BitVec('%s%d' % (tag, _fresh[0]), bits)


def fresh_bool(tag='fb'):
    _fresh[0] += 1
    return z3.Bool('%s%d' % (tag, _fresh[0]))


def fresh_array(tag='ma'):
    _fresh[0] += 1
    return z3.Array('%s%d' % (tag, _fresh[0]), z3.BitVecSort(32), z3.BitVecSort(8))


def load_plan_hints(va):
    """{loop header: 3|5|9|17|'gen'} from tests/fl75_plans.json. The loop plan is otherwise found by trying the bounds in turn, and the 3 s sink check (SINK_MS) that bumps a bound can go either way on a busy machine, which made a few rows flip between proved and open."""
    try:
        data = json.loads(PLANS.read_text())
    except (OSError, ValueError):
        return {}
    return {int(h, 16): v for h, v in data.get(hex(va), {}).items() if v == 'gen' or v in UNROLL or v == HINT_ONLY}


def load_invariants(va):
    """{header block address: [atom, ...]} declared for the function at `va` in tests/fl73_invariants.json. An atom is {"mem": [register, displacement, size in bytes], "op": eq|ne|sge|sgt|sle|slt|uge|ugt|ule|ult, "val": n}
    (or {"reg": register, "op": ..., "val": n | "reg2": register}, FL-78: a whole register; or {"or": [atom, ...]}, FL-75) and says that the `size` bytes at register+displacement, read in the state at the head of a generalised loop, compare so with n (or, with "mem2" in place of "val", with the same-size slot [register, displacement, size]). A header with atoms keeps them only if
    `Analysis.verify_invariants` proves them: they hold on every entry edge, and every back edge preserves them (assuming them at the header)."""
    try:
        data = json.loads(INVARIANTS.read_text())
    except (OSError, ValueError):
        return {}
    return {int(h, 16): atoms for h, atoms in data.get(hex(va), {}).items()}


def inv_atom(M, st, at):
    if 'or' in at:                                                                 # FL-75: {"or": [atom, ...]} holds when any alternative does
        alts = [inv_atom(M, st, a) for a in at['or']]
        return z3.Or(*alts) if len(alts) > 1 else alts[0]
    if 'reg' in at:                                                                # FL-78 (round 7): {"reg": register, "op": ..., "val": n} compares a whole register, in the state at the head of the loop, with n (or with the register "reg2")
        other = st.R[at['reg2']] if 'reg2' in at else bv(at['val'], 32)
        return _INV_OPS[at['op']](st.R[at['reg']], other)
    reg, disp, size = at['mem']
    a = st.R[reg] + bv(disp, 32)
    v = M.load(getattr(st, M.space(st, a)), a, size)
    if 'mem2' in at:                                                               # compared with another slot of the same size
        reg2, disp2, size2 = at['mem2']
        assert size2 == size
        a2 = st.R[reg2] + bv(disp2, 32)
        other = M.load(getattr(st, M.space(st, a2)), a2, size)
    else:
        other = bv(at['val'], 8 * size)
    return _INV_OPS[at['op']](v, other)


def inv_parts(M, st, atoms):
    return [inv_atom(M, st, at) for at in atoms]


def inv_formula(M, st, atoms):
    out = inv_parts(M, st, atoms)
    return z3.And(*out) if len(out) > 1 else out[0]


def reach_back(preds, node):
    """the blocks (graph nodes) that a run passes on its way to `node`: the predecessors, transitively, over the edges that are not back edges"""
    seen, work = set(), [node]
    while work:
        n = work.pop()
        for p in preds.get(n, ()):
            if p not in seen:
                seen.add(p)
                work.append(p)
    return seen


def inv_failures(check, M, assumed, c_entry, st_in, atoms, prefix=None):
    """the atoms (by index) that a state fails to satisfy under the edge condition: `check(formula)` returns a verdict string"""
    bad = []
    for k, part in enumerate(inv_parts(M, st_in, atoms)):
        f = z3.And(c_entry, z3.Not(part)) if assumed is None else z3.And(assumed, c_entry, z3.Not(part))
        if check(f) != 'unsat':
            bad.append(k)
    return bad


def msb(e, w):
    return z3.Extract(w - 1, w - 1, e) == 1


def bv(v, w):
    return z3.BitVecVal(v & ((1 << w) - 1), w)


def same(a, b):
    return a is b or z3.eq(a, b)


def ite(c, a, b):
    return a if same(a, b) else z3.If(c, a, b)


class State:
    """Registers (eight 32-bit z3 terms), flags (z3 Booleans), the two memories (data and fs-relative) and the facts assumed along the way."""
    __slots__ = ('R', 'F', 'mem', 'frm', 'fs', 'pc', 'fp')

    def __init__(self, R, F, mem, frm, fs, pc, fp=(None, None)):
        self.R, self.F, self.mem, self.frm, self.fs, self.pc = R, F, mem, frm, fs, pc
        self.fp = fp                           # FL-78 (round 7): what is known of the x87 unit: (the 64 bits of st(0) when the last x87 instruction loaded or compared them, the status word a compare produced); (None, None) otherwise

    def copy(self):
        return State(dict(self.R), dict(self.F), self.mem, self.frm, self.fs, self.pc, self.fp)

    @staticmethod
    def start():
        R = {r: z3.BitVec('s_' + r, 32) for r in FULL}
        F = {f: z3.Bool('s_' + f) for f in FLAGS}
        arr = lambda n: z3.Array(n, z3.BitVecSort(32), z3.BitVecSort(8))
        return State(R, F, arr('s_mem'), arr('s_frm'), arr('s_fs'), z3.BoolVal(True))


_frame_cache = {}


def has_frame_term(e):
    """True if the address expression is built from the entry esp (the symbol s_esp, or the unknown esp after a call whose pops are not known)."""
    key = e.get_id()
    hit = _frame_cache.get(key)
    if hit is not None:
        return hit[1]                    # the cache keeps the expression alive: z3 recycles the ids of freed expressions
    todo, seen, found = [e], set(), False
    while todo and not found:
        x = todo.pop()
        if x.get_id() in seen:
            continue
        seen.add(x.get_id())
        if z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED:
            n = x.decl().name()
            found = n in ('s_esp', 's_ebp') or (n.startswith('sp') and n[2:].isdigit())          # FL-73: s_ebp too: a window that starts after the prologue has ebp and esp as separate symbols, both frame pointers
        elif x.decl().kind() == z3.Z3_OP_ITE:
            todo.extend(x.children()[1:])            # FL-78 (round 7): the value of `If(c, a, b)` is a or b; the condition c (the path condition of a merged state mentions s_esp) does not make the value a frame address
        elif x.decl().kind() not in (z3.Z3_OP_SELECT, z3.Z3_OP_STORE):          # a value read from memory is not a frame address (nothing ever formed one)
            todo.extend(x.children())
    if len(_frame_cache) > 200000:
        _frame_cache.clear()
    _frame_cache[key] = (e, found)
    return found


def pure_frame_term(e):
    """FL-78 (round 9): True when the 32-bit value `e` is a frame address on every path: built only from constants and the frame symbols (s_esp, s_ebp, spN) by arithmetic, extract / concat and `If` (whose condition is not looked at). A value read from memory, a register of the caller or a fresh unknown anywhere in it makes it False (on that path it is not a frame address)."""
    todo, seen = [e], set()
    while todo:
        x = todo.pop()
        if x.get_id() in seen:
            continue
        seen.add(x.get_id())
        if z3.is_bv_value(x):
            continue
        if z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED:
            n = x.decl().name()
            if n in ('s_esp', 's_ebp') or (n.startswith('sp') and n[2:].isdigit()):
                continue
            return False
        k = x.decl().kind()
        if k == z3.Z3_OP_ITE:
            todo.extend(x.children()[1:])
        elif k in (z3.Z3_OP_SELECT, z3.Z3_OP_STORE) or z3.is_const(x):
            return False
        else:
            todo.extend(x.children())
    return True


def callee_leaks(insns):
    """FL-78 review: True when a function analysed as a callee (out_param_extent, readonly_param, pure_callee) hands out its own frame base or names a 16 or 8 bit part of esp / ebp (`frame_ok`): `push ebp` is allowed only as the first instruction (the prologue) and `mov ebp, esp` only as the second; any other push of ebp or esp, `pusha`/`pushad`/`enter`, or a second `mov ebp, esp` could pass the callee's frame
    (from which its argument slots are reachable) to another function."""
    if insns and any(j.operands and j.operands[0].type == X.X86_OP_IMM and (j.mnemonic == 'jmp' or j.mnemonic.startswith('j') or j.mnemonic.startswith('loop')) and (j.operands[0].imm & 0xffffffff) == insns[0].address for j in insns):
        return True                                    # FL-78 (round 8 review): a jump back to the entry runs the prologue's `push ebp` again
    for k, i in enumerate(insns):
        m = i.mnemonic
        if not frame_ok(i, k == 0):
            return True
        if m in ('pusha', 'pushad', 'enter', 'pushal'):
            return True
        if m == 'push' and i.operands[0].type == X.X86_OP_REG:
            name = i.reg_name(i.operands[0].reg)
            if name == 'esp' or (name == 'ebp' and k != 0):
                return True
        if m == 'mov' and len(i.operands) == 2 and [o.type for o in i.operands] == [X.X86_OP_REG, X.X86_OP_REG] and i.op_str == 'ebp, esp' and k != 1:
            return True
    return False


PARTIAL_FRAME = ('sp', 'bp', 'spl', 'bpl')                                                  # the 16 and 8 bit names of esp / ebp (capstone names them so): a write to one changes the frame base without being seen as a use of esp / ebp


FRAME_NAMES = frozenset(('esp', 'ebp') + PARTIAL_FRAME)


def frame_touch(i):
    """FL-78 review (round 6): the names of esp, ebp and their 16 and 8 bit parts that the instruction reads or writes other than as the base or index of an explicit memory operand: the implicit ones too (popad, enter, leave, push, call, ret), the explicit register operands, and any 16 bit name used as an address. None when capstone cannot say (the caller refuses)."""
    try:
        rd, wr = i.regs_access()
    except capstone.CsError:
        return None
    nm = i.reg_name
    addr = set()
    explicit = set()
    for o in i.operands:
        if o.type == X.X86_OP_REG:
            explicit.add(nm(o.reg))
        elif o.type == X.X86_OP_MEM:
            addr.update(nm(r) for r in (o.mem.base, o.mem.index) if r)
    reads = {nm(r) for r in rd}
    writes = {nm(r) for r in wr}
    touched = (writes | explicit | (reads - addr) | (addr & set(PARTIAL_FRAME))) & FRAME_NAMES
    return touched


def frame_ok(i, first=False):
    """FL-78 review (round 6): a whitelist. An instruction that reads or writes esp or ebp (or a part of them) other than as the address register of a memory operand is allowed only as one of: `push ebp` / `mov ebp, esp` (prologue; the position rules are `callee_leaks`'), push or pop of another 32 bit register, an immediate or a memory operand, call, ret, leave (not with a 0x66 prefix), `mov esp, ebp` / `mov ebp, esp`, add or sub esp, immediate. Everything else (popad, popaw, enter, pushfd, xchg, lea esp, bswap ebp, a 16 bit leave, `add sp, ..`, a push or pop with an operand size prefix, ...) is refused, however its effect on the frame base is spelled."""
    touched = frame_touch(i)
    if touched is None:
        return False
    m = i.mnemonic
    ops = i.operands
    if not touched:
        return True
    if i.prefix[2] == 0x66 or i.prefix[3] == 0x67 or touched & set(PARTIAL_FRAME):
        return False
    names = [i.reg_name(o.reg) for o in ops if o.type == X.X86_OP_REG]
    if m in ('push', 'pop') and len(ops) == 1:
        if ops[0].type == X.X86_OP_REG:
            if m == 'push' and names[0] == 'ebp' and not first:
                return False                         # FL-78 (round 8 review): the frame base is never pushed, except by the prologue's `push ebp` as the first instruction: a pushed ebp is a frame address that a callee, or a pop, can take anywhere
            return names[0] != 'esp' and ops[0].size == 4
        return ops[0].type in (X.X86_OP_IMM, X.X86_OP_MEM) and not (names and names[0] == 'esp')
    if m == 'call' and len(ops) == 1:
        return ops[0].type != X.X86_OP_REG or names[0] not in FRAME_NAMES
    if m in ('ret', 'retn', 'leave') and (m == 'leave' or len(ops) <= 1):
        return True
    if m == 'mov' and len(ops) == 2 and [o.type for o in ops] == [X.X86_OP_REG, X.X86_OP_REG] and names in (['ebp', 'esp'], ['esp', 'ebp']):
        return True
    if m in ('add', 'sub') and len(ops) == 2 and ops[0].type == X.X86_OP_REG and names == ['esp'] and ops[1].type == X.X86_OP_IMM:
        return True
    return False


def frame_escapes(insns, first=None):
    """True if some instruction can hand out an address of the stack frame or move the frame base in a way the checks do not follow: then the frame assumption is not used for the function.
    A `lea` with esp or ebp as base or index forms a frame address. Every other instruction that touches esp or ebp other than as a memory address register must pass `frame_ok` (a whitelist: the prologue push / mov, push and pop of other operands, call, ret, leave, mov esp / ebp, add or sub esp immediate)."""
    for i in insns:
        if i.mnemonic == 'lea':
            mem = i.operands[1].mem
            if i.reg_name(mem.base) in FRAME_NAMES if mem.base else False:
                return True
            if i.reg_name(mem.index) in FRAME_NAMES if mem.index else False:
                return True
        if not frame_ok(i, i.address == (insns[0] if first is None else first).address):
            return True
    return False


def seh_registration(insns, ins, targets=()):
    """FL-75: `mov dword ptr fs:[0], esp`, the exception-chain registration of an MSVC prologue, is not a use of the frame address that the frame assumption must guard against when every other use of the fs segment is
    a `mov r32, fs:[0]` in front of it (the saved previous chain head) and control cannot come back to those reads: no branch of the function targets an address from the entry up to the registration, so the straight-line
    prologue runs once, in address order. The chain is read by exception dispatch, which the prover treats like a fault (a run that unwinds, or a filter that resumes, is not a run it models)."""
    ops = ins.operands
    if ins.mnemonic != 'mov' or len(ops) != 2 or ops[0].type != X.X86_OP_MEM or ops[1].type != X.X86_OP_REG or ins.reg_name(ops[1].reg) != 'esp':
        return False
    m = ops[0].mem
    if m.segment != X.X86_REG_FS or m.base or m.index or m.disp != 0 or ops[0].size != 4:
        return False
    if any(insns[0].address <= t <= ins.address for t in targets):
        return False
    for j in insns:
        if j is ins:
            continue
        if not (j.prefix[1] == 0x64 or any(o.type == X.X86_OP_MEM and o.mem.segment == X.X86_REG_FS for o in j.operands)):
            continue
        o = j.operands
        if j.mnemonic == 'mov' and len(o) == 2 and o[0].type == X.X86_OP_REG and o[1].type == X.X86_OP_MEM and o[1].mem.segment == X.X86_REG_FS and not o[1].mem.base \
                and not o[1].mem.index and o[1].mem.disp == 0 and j.address < ins.address:
            continue
        if j.mnemonic == 'mov' and len(o) == 2 and o[0].type == X.X86_OP_MEM and o[1].type == X.X86_OP_REG and ins.reg_name(o[1].reg) not in ('esp', 'ebp'):
            continue                                                       # the epilogue restores the saved chain head from a register
        return False
    return True


def _full(names):
    return {REGS[n][0] for n in names if n in REGS}


def _rw(i):
    """(registers read as full names, registers written as the names capstone gives) of one instruction"""
    rd, wr = i.regs_access()
    rd = _full(i.reg_name(r) for r in rd)
    if i.mnemonic.startswith('cmov'):
        rd |= _full(i.reg_name(r) for r in wr)                                   # FL-78 review: a conditional move keeps the old value when the condition fails, so it reads its destination and does not kill it
    return rd, {i.reg_name(r) for r in wr}


CALLEE_SAVED = ('ebx', 'esi', 'edi', 'ebp')
ALL_STRING_OPS = frozenset(op + w for op in ('movs', 'stos', 'cmps', 'scas', 'lods', 'ins', 'outs') for w in 'bwd') | {'xlat', 'xlatb'}
STRING_OPS = frozenset(op + w for op in ('movs', 'stos', 'ins') for w in 'bwd')                  # the string instructions that write memory (cmps, scas, lods, outs only read it)
X87_STORES = ('fst', 'fist', 'fnst', 'fsave', 'fnsave', 'fbst', 'fxsave')         # capstone reports the memory operand of an x87 store as read


_IAT = None


def import_slots():
    """the addresses of the import address table slots of the original image (image/imports.json, the committed import description): a call through one of them is a Win32 import"""
    global _IAT
    if _IAT is None:
        data = json.loads((PROJECT / 'image' / 'imports.json').read_text(encoding='utf-8'))
        _IAT = frozenset(IMAGE_BASE + int(d['iat_rva'], 16) + 4 * k for d in data['dlls'] for k in range(len(d['symbols'])))
    return _IAT


_REGP = {}                                                                   # register name -> (full register, the parts it covers): l = low byte, h = second byte, u = upper 16 bits
for _f in 'abcd':
    _e = 'e%sx' % _f
    _REGP[_e], _REGP['%sx' % _f], _REGP['%sl' % _f], _REGP['%sh' % _f] = (_e, {'l', 'h', 'u'}), (_e, {'l', 'h'}), (_e, {'l'}), (_e, {'h'})
for _e in ('esi', 'edi', 'ebp', 'esp'):
    _REGP[_e], _REGP[_e[1:]] = (_e, {'l', 'h', 'u'}), (_e, {'l', 'h'})
_ALL = frozenset(('l', 'h', 'u'))
_EFFECTS, _IN_PROGRESS, _CYCLES, _ASSUME = {}, set(), [0], {}
_FX = [set()]                                                                              # the assumptions call_effect relied on, per computation in progress (named in the proof record: Analysis.assumptions)                                         # call_effect: results per (image, callee, register), and the callees being followed (a cycle is not followed)
LIBRARY_POINTS_INTO_ARGUMENT = frozenset(('strstr',))                      # FL-78 (round 9 review): the listed library functions whose result is a pointer into a source argument (so into the frame buffer when that is a frame address)
LIBRARY_RETURNS = frozenset((0x50ca3e, 0x50d0a9, 0x50cf61))                 # FL-78: the listed library functions that return a value in eax (so they overwrite it)


def _rw_raw(i):
    """(register names read, register names written) of one instruction as capstone gives them; a conditional move, bsf and bsr read their destination, and `xor r, r` / `sub r, r` read nothing"""
    rd, wr = i.regs_access()
    rd = {i.reg_name(r) for r in rd}
    wr = {i.reg_name(r) for r in wr}
    if i.mnemonic.startswith('cmov') or i.mnemonic in ('bsf', 'bsr'):
        rd |= wr                                                              # FL-78 review: a conditional move keeps the old value when the condition fails (so does bsf / bsr when the source is zero)
    elif i.mnemonic in ('xor', 'sub') and len(i.operands) == 2 and i.operands[0].type == X.X86_OP_REG and i.operands[1].type == X.X86_OP_REG and i.operands[0].reg == i.operands[1].reg:
        rd = set()
    return rd, wr


def _imp_token(imports):
    """the set of import slots as a hashable value (call_effect cache key): its content"""
    return None if imports is None else frozenset(imports)


def _writer_token(writers):
    """the library table as the cache key: its content and the functions that return a value (the tests replace both)"""
    return (tuple(sorted((writers if writers is not None else LIBRARY_WRITERS).items())), frozenset(LIBRARY_RETURNS))


def call_effect(image, call, R, depth=0, imports=None, writers=None):
    """FL-78 (review): (reads, survive) for the call instruction and the register R: whether the call may read R (an unknown callee, an indirect call: yes), and the set of parts of R (`_ALL`) whose old value is still there afterwards.
    A callee-saved register is kept by every call. For eax, ecx and edx: a Win32 import (a slot of the import table, `imports`) reads none of them (arguments are on the stack) and clobbers all three (eax is the result, ecx and edx are volatile by the ABI);
    a function of LIBRARY_WRITERS reads none of them and a function of LIBRARY_RETURNS overwrites eax with its result. A direct callee in the image is followed (`scan` over its bytes, three levels): it reads R if some path reads a part of R that it has not written, and what survives is the union of the parts still held at its returns."""
    if R not in ('eax', 'ecx', 'edx'):
        _FX[-1].add('callee-saved-registers-unread-and-kept-by-callees')
        return False, _ALL
    op = call.operands[0]
    if op.type == X.X86_OP_MEM:
        slots = import_slots() if imports is None else imports
        if image is not None and not op.mem.base and not op.mem.index and not op.mem.segment and (op.mem.disp & 0xffffffff) in slots:
            _FX[-1].add('import-reads-no-register-and-clobbers-eax-ecx-edx')
            return False, frozenset()                                            # eax holds the result; ecx and edx are volatile by the Windows ABI, a caller does not rely on them (the assumption of the earlier review round)
        return True, _ALL
    if op.type != X.X86_OP_IMM or image is None:
        return True, _ALL
    t = op.imm & 0xffffffff
    if t in (LIBRARY_WRITERS if writers is None else writers):
        _FX[-1].add('listed-library-function-reads-no-register')
        return False, _ALL - (_ALL if t in LIBRARY_RETURNS and R == 'eax' else frozenset())
    key = (id(image), t, R, _imp_token(imports), _writer_token(writers))
    hit = _EFFECTS.get(key)
    if hit is not None and hit[0] is image:
        _FX[-1].update(hit[2])
        return hit[1]
    if key in _IN_PROGRESS:
        _CYCLES[0] += 1
        return False, _ASSUME[key]                                               # a recursive call: what the function being followed keeps is not known yet; the caller below iterates from the empty set to a fixed point (what the callee keeps = what the scan finds when the recursive call keeps that)
    tgt = function_insns(image, t)
    if tgt is None:
        return True, _ALL
    _IN_PROGRESS.add(key)
    cycles = _CYCLES[0]
    _FX.append(set())
    try:
        assumed = frozenset()
        while True:
            _ASSUME[key] = assumed
            rets = set()
            if not scan(tgt[1], tgt[0][0].address, R, _ALL, image, depth + 1, imports, writers, rets):
                out = (True, _ALL)
                break
            found = frozenset(rets)
            if found == assumed:
                out = (False, found)
                break
            assumed = assumed | found                                            # (the result only grows with the assumption: at most three parts, so at most four rounds)
    finally:
        _IN_PROGRESS.discard(key)
        _ASSUME.pop(key, None)
        used = _FX.pop()
        _FX[-1].update(used)
    if _CYCLES[0] != cycles:
        _FX[-1].add('recursive-call-least-fixed-point')
        used = used | {'recursive-call-least-fixed-point'}
    else:                                                                        # (a result that met a recursive call depends on where the cycle was entered: not kept)
        _EFFECTS[key] = (image, out, frozenset(used))
    return out


def _addr_only(i, fam):
    """FL-78 (round 9, pointer cell): True when the instruction reads the register `fam` only as the base or index of a memory operand (a load, a store or a compare through it) and does not compute with it: not `lea`, not as an explicit register operand that is read (`mov [eax], eax`, `push eax`, `cmp eax, 1`), not implicitly (string instructions, `mul`, `cdq`, ...)."""
    if i.mnemonic == 'lea' or i.mnemonic.split()[-1] in ALL_STRING_OPS:           # (a string instruction or xlat advances the register it addresses through: the result is still a pointer)
        return False
    explicit, addr = set(), set()
    for o in i.operands:
        if o.type == X.X86_OP_REG and o.access & capstone.CS_AC_READ:
            explicit.add(REGS[i.reg_name(o.reg)][0])
        elif o.type == X.X86_OP_MEM:
            idx = REGS[i.reg_name(o.mem.index)][0] if o.mem.index and i.reg_name(o.mem.index) in REGS else None
            if idx == fam and (o.mem.scale != 1 or o.mem.base):          # FL-78 (round 9 review): the register as a scaled index, or as the index added to another base, is not the address it holds
                return False
            addr.update(REGS[i.reg_name(r)][0] for r in (o.mem.base, o.mem.index) if r and i.reg_name(r) in REGS)
    rd, _ = _rw_raw(i)
    implicit = {REGS[n][0] for n in rd if n in REGS} - explicit - addr
    return fam not in explicit and fam not in implicit and fam in addr


def _result_use_ok(i, fam):
    """FL-78 (round 9 review): True when the instruction uses the register `fam`, which holds a pointer into a frame buffer (the result of strstr), in a way that cannot write through it or let it go: a compare or a test (flags only), or a load through it (it is the base or index of memory operands that the instruction only reads, `_addr_only`). A store through it (`mov byte [eax], 1`,
    `inc dword [eax]`, `xchg`, an x87 store, a bit-test-and-set), a copy, arithmetic, `lea`, a push and a return of it are not."""
    if i.mnemonic in ('test', 'cmp'):
        return all(o.type != X.X86_OP_MEM or not o.access & capstone.CS_AC_WRITE for o in i.operands)
    if not _addr_only(i, fam) or i.mnemonic.startswith(X87_STORES) or i.mnemonic.split()[-1] in ('bts', 'btr', 'btc', 'xchg', 'xadd', 'cmpxchg', 'cmpxchg8b'):
        return False
    for o in i.operands:
        if o.type == X.X86_OP_MEM and o.access & capstone.CS_AC_WRITE:
            return False
    return True


def scan(by_addr, start, R, parts, image=None, depth=0, imports=None, writers=None, rets=None, addr_ok=False, users=None):
    """FL-78: True when no path from the instruction at `start` reads a part of the register R that still holds the old value (`parts`, of l h u) before writing it. A write of a name covers its parts (`mov ax, 1` the l and h parts, `mov eax, ..` all);
    a call is `call_effect`; a jump with an unknown target, or a path that leaves the body, counts as a read. At a ret: with `rets` (the body of a callee) the parts still held are added to it and the path ends; without it (the function being
    analysed) the ret reads eax and the callee-saved registers, which go back to the caller."""
    seen, work = set(), [(start, frozenset(parts))]
    fam = _REGP.get(R, (R, _ALL))[0]
    while work:
        a, live = work.pop()
        while True:
            if a not in by_addr:
                return False                                                     # the path runs out of the body
            if (a, live) in seen:
                break
            seen.add((a, live))
            i = by_addr[a]
            rd, wr = _rw_raw(i)
            if any(_REGP.get(n, (None, ()))[0] == fam and _REGP[n][1] & live for n in rd):
                if not (addr_ok(i, fam) if callable(addr_ok) else addr_ok and _addr_only(i, fam)):          # (addr_ok: a read of R as the address of a memory operand is not a read of its value, for the pointer cell; or a function that says which reads are harmless)
                    return False
                if users is not None:
                    users.add(i.address)
            for n in wr:
                if _REGP.get(n, (None, ()))[0] == fam:
                    live = live - _REGP[n][1]
            if not live:
                break
            m = i.mnemonic
            if m == 'call':
                reads, surv = call_effect(image, i, R, depth, imports, writers)
                if reads:
                    return False
                live = live & surv
                if not live:
                    break
            elif m in ('ret', 'retn'):
                if rets is not None:
                    rets |= live
                elif R == 'eax' or R in CALLEE_SAVED:
                    return False
                break
            elif m == 'jmp' or m.startswith('j') or m.startswith('loop'):
                if i.operands[0].type != X.X86_OP_IMM:
                    return False
                work.append((i.operands[0].imm & 0xffffffff, live))
                if m == 'jmp':
                    break
            a += i.size
    return True


def dead_from(by_addr, start, R, image=None, depth=0, imports=None, writers=None):
    """FL-78: True when register R is dead from the instruction at `start` on every path: no part of it is read before it is written (`scan`)."""
    return scan(by_addr, start, R, _ALL, image, depth, imports, writers)


def function_insns(image, addr):
    """FL-78: ([instructions], {address: instruction}) of the function at `addr`: linear disassembly up to the first ret or jmp that no jump of the function goes beyond; None when a jump has an unknown target or leaves the instructions."""
    if not (IMAGE_BASE <= addr < DATA_START):
        return None
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = addr - IMAGE_BASE
    insns, far = [], addr
    for i in md.disasm(image[off:off + 4096], addr):
        insns.append(i)
        m = i.mnemonic
        if m == 'jmp' or m.startswith('j') or m.startswith('loop'):
            if i.operands[0].type != X.X86_OP_IMM:
                return None
            far = max(far, i.operands[0].imm & 0xffffffff)
        if (m in ('ret', 'retn') or m == 'jmp') and i.address >= far:
            break
    else:
        return None
    by_addr = {i.address: i for i in insns}
    for i in insns:
        m = i.mnemonic
        if (m == 'jmp' or m.startswith('j') or m.startswith('loop')) and (i.operands[0].imm & 0xffffffff) not in by_addr:
            return None
    return insns, by_addr


def pure_callee(image, addr):
    """FL-78 (0x4ba56a): True when the function at `addr` is shown by its bytes to write no memory but its own stack below the return address (the CRT _ftol 0x50ce04 is one: `push ebp; mov ebp,esp; add esp,-12; fnstcw [ebp-2]; ...; fistp qword [ebp-12]; ...; leave; ret`).
    Straight line (no call, no jump, no loop, no string instruction), starts `push ebp; mov ebp, esp`, `callee_leaks` and `frame_escapes` say no, ebp is written only by the prologue and restored only at the end (`leave`, followed by nothing but `ret`), no segment override. The stack depth d (entry esp minus esp) is
    followed: the only instructions that write esp are push / pop of a register, immediate or memory operand, `sub esp, K` (K > 0), `add esp, K` (K < 0 grows, K > 0 shrinks, d must stay >= 0), `mov esp, ebp` (d = 4), `leave` (d = 0) and `ret`; so every `push` stores below the return address, and anything else that writes esp (`enter`, `pushf`, `pushad`, `mov esp, r`, `xchg esp`) refuses.
    Every other store (a written operand, an x87 store, an xchg-like) is through [ebp+d] with no index and d + size <= 0, which is below the stack pointer of the caller. Such a call changes eax, ecx, edx, the flags and the x87 state and the dead stack below the caller's esp, nothing else the caller can read.
    The assumption (RULE_TEXT2): nothing else reads that dead stack. An image scan finds four such functions: 0x50ce04, 0x514569, 0x51457b, 0x515a7f."""
    got = function_insns(image, addr)
    if got is None:
        return False
    insns, _ = got
    if len(insns) < 3 or not (insns[0].mnemonic == 'push' and insns[0].op_str == 'ebp' and insns[1].mnemonic == 'mov' and insns[1].op_str == 'ebp, esp') or frame_escapes(insns) or callee_leaks(insns):
        return False
    depth, restored = 0, False
    for k, i in enumerate(insns):
        m = i.mnemonic
        if restored and m not in ('ret', 'retn'):
            return False                                                         # after `leave` ebp is the caller's: nothing but the return may follow
        if m in ('call', 'int', 'int3', 'into', 'sysenter', 'syscall', 'hlt', 'in', 'out', 'xlat', 'ins', 'outs', 'enter', 'pushf', 'pushfd', 'popf', 'popfd', 'pusha', 'pushad', 'popa', 'popad') or m.startswith(('j', 'loop', 'rep', 'lock')) or 'movs' in m or 'stos' in m or 'cmps' in m or 'scas' in m or 'lods' in m:
            return False
        if m in ('ret', 'retn') and k != len(insns) - 1:
            return False
        try:
            rd, wr = _rw_raw(i)
        except capstone.CsError:
            return False
        ops = i.operands
        if 'ebp' in wr and not (k == 1 or m == 'leave'):
            return False
        if m == 'leave':
            depth, restored = 0, True
        elif m == 'pop':
            if ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) == 'esp':
                return False
            depth -= 4
            if depth < 0:
                return False
        elif m == 'push':
            depth += 4                                                           # (d >= 0 before, so the store is below the return address)
        elif 'esp' in wr:
            if m in ('sub', 'add') and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) == 'esp' and ops[1].type == X.X86_OP_IMM:
                k_ = ops[1].imm if ops[1].imm < 0x80000000 else ops[1].imm - (1 << 32)
                depth += k_ if m == 'sub' else -k_
                if depth < 0:
                    return False
            elif m == 'mov' and i.op_str == 'esp, ebp':
                depth = 4
            elif m in ('ret', 'retn'):
                pass
            else:
                return False
        for o in ops:
            if o.type != X.X86_OP_MEM:
                continue
            m_ = o.mem
            if m_.segment or (m_.base and i.reg_name(m_.base) == 'esp') or (m_.index and i.reg_name(m_.index) == 'esp'):
                return False
            if o.access & capstone.CS_AC_WRITE or m.startswith(X87_STORES) or m in ('xchg', 'cmpxchg', 'xadd', 'fbstp'):
                if not (m_.base and i.reg_name(m_.base) == 'ebp' and not m_.index and m_.disp + o.size <= 0):
                    return False
    return insns[-1].mnemonic in ('ret', 'retn')


def out_param_extent(image, addr, argoff, imports=None):
    """FL-78: read from the bytes of the function at `addr` (a frame-based one: `push ebp; mov ebp, esp`) how far it writes through the pointer in its stack argument [ebp+argoff]; None when it cannot be shown that this is all it does with it.
    Shown: the slot is read only by `mov r32, [ebp+argoff]` into eax, ecx or edx; on every path from such a load the register is used only as the base of an x87 store `fst/fstp [r+d]` (d >= 0), nothing else reads it (not a push, a copy, a compare, an index),
    until it is overwritten or a call kills it (`call_effect`: an import or a direct callee whose bytes overwrite the register and do not read it); a path may return with the pointer still in a register (the caller must treat eax, ecx, edx as dead). The function forms no frame address
    (`frame_escapes`), has no access through esp and no ebp-indexed access, writes through ebp only below it (its own locals), and every jump has a known target inside the body. The extent is the largest d + size of those stores."""
    got = function_insns(image, addr)
    if got is None:
        return None
    insns, by_addr = got
    if len(insns) < 3 or not (insns[0].mnemonic == 'push' and insns[0].op_str == 'ebp' and insns[1].mnemonic == 'mov' and insns[1].op_str == 'ebp, esp'):
        return None
    if frame_escapes(insns) or callee_leaks(insns):
        return None
    loads, extent = [], 0
    for i in insns:
        m = i.mnemonic
        if (m.startswith('j') or m.startswith('loop')) and m != 'jmp' or m == 'jmp':
            if (i.operands[0].imm & 0xffffffff) not in by_addr:
                return None
        for o in i.operands:
            if o.type != X.X86_OP_MEM:
                continue
            base = i.reg_name(o.mem.base) if o.mem.base else None
            if base == 'esp' or (o.mem.index and i.reg_name(o.mem.index) == 'esp'):
                return None
            if base != 'ebp':
                continue
            if o.mem.index or o.mem.segment:
                return None
            lo, hi = o.mem.disp, o.mem.disp + o.size
            if lo < argoff + 4 and argoff < hi:
                if not (m == 'mov' and o is i.operands[1] and o.size == 4 and lo == argoff and i.operands[0].type == X.X86_OP_REG and i.reg_name(i.operands[0].reg) in ('eax', 'ecx', 'edx')):
                    return None
                loads.append(i)
            elif (o.access & capstone.CS_AC_WRITE or m.startswith(X87_STORES)) and hi > 0:
                return None                                                      # a write at or above the saved ebp: the caller's side
    seen = set()
    for load in loads:
        r = load.reg_name(load.operands[0].reg)
        work = [load.address + load.size]
        while work:
            a = work.pop()
            while True:
                if a not in by_addr:
                    return None
                if (a, r) in seen:
                    break
                seen.add((a, r))
                i = by_addr[a]
                if i.mnemonic in ('ret', 'retn'):                                # the pointer may stay in the register; the caller treats eax, ecx, edx as dead
                    break
                rd, wr = _rw(i)
                if r in rd:
                    mem = [o for o in i.operands if o.type == X.X86_OP_MEM]
                    if not (i.mnemonic in ('fst', 'fstp') and len(i.operands) == 1 and len(mem) == 1 and mem[0].mem.base and i.reg_name(mem[0].mem.base) == r):
                        return None
                    o = mem[0]
                    if o.mem.index or o.mem.segment or o.mem.disp < 0 or o.size not in (4, 8):
                        return None
                    extent = max(extent, o.mem.disp + o.size)
                elif r in wr:
                    break
                if i.mnemonic == 'call':
                    reads, surv = call_effect(image, i, r, 0, imports)
                    if reads or surv:                                                   # a call that may read the register, or leave the pointer in it for a later store, is not followed
                        return None
                    break
                if i.mnemonic in ('ret', 'retn'):
                    break
                if i.mnemonic == 'jmp' or i.mnemonic.startswith('j') or i.mnemonic.startswith('loop'):
                    work.append(i.operands[0].imm & 0xffffffff)
                    if i.mnemonic == 'jmp':
                        break
                a += i.size
    return extent


def library_arg_lea(insns, ins, targets, by_addr, writers=None, image=None, callees=None, imports=None):
    """FL-78: a description (a dict) when `lea R, [ebp+disp]` forms a frame address that stays in R and goes only where it can be followed, else None. R is eax, ecx or edx and the straight line from the lea to the use has no jump, call or branch target. Three cases:
      * 'source': the first thing that touches R is `push R`, then only 4-byte pushes and register loads (no esp, none reads R) up to a direct `call` of a function of LIBRARY_WRITERS, in a position that is not a destination position. The assumption
        (RULE_TEXT2): such a function writes only through its destination argument, reads through its other pointer arguments and keeps no copy of them.
      * 'out': the same shape, but the callee is not on the list; `out_param_extent` reads its bytes and shows that it only stores floats through the pointer, at most `extent` bytes. The call is then modelled as writing exactly [pointer, pointer+extent) of the frame.
        For both, the pops of the callee plus the `add esp, K` after the call cover the pushed arguments (the model overwrites those slots after a call, so no copy of the address stays in the frame), and eax, ecx, edx (for 'source' only R) are dead after the call (`dead_from`).
      * 'copy': the first thing that touches R is `mov edi, R`; the destination of the `rep movs/stos` instructions that follow. The model (`Machine.string`) lets such a store write any byte of the frame (and of mem), and edi and R must be dead where the straight line ends;
        so the address goes nowhere else. No assumption beyond the frame assumption itself.
    The callee's or the instruction's own behaviour is the assumption of LIBRARY_WRITERS only for 'source'."""
    try:
        return _library_arg_lea(insns, ins, targets, by_addr, LIBRARY_WRITERS if writers is None else writers, image, callees or {}, imports)
    except capstone.CsError:                                                     # an instruction whose register accesses are not known
        return None


FORMAT_SPEC = re.compile(rb'%[-+ #0]*[0-9]*(?:\.[0-9]*)?(?:h|l|L|I64)?[dioxXucsfeEgG%]')       # flags, width, precision (no `*`, no `$`), length h l L I64, the conversions that only read their arguments (no n, p, a, S, C, Z)
_FORMAT_REFS = {}


def format_text_ok(text):
    """FL-78 review: True when `text` (the bytes of a format string, without the NUL) is non-empty printable ASCII and every `%` starts a conversion specification of FORMAT_SPEC: so no `n` (also `%hn`, `%ln`, `%5n`), no `%1$n`, no `*` width that would take
    an argument the format does not name, no unknown conversion"""
    if not text or any(not (0x20 <= b < 0x7f or b in (9, 10, 13)) for b in text):
        return False
    k = text.find(b'%')
    while k >= 0:
        m = FORMAT_SPEC.match(text, k)
        if not m:
            return False
        k = text.find(b'%', m.end())
    return True


def format_references_ok(image, a, end, writers):
    """FL-78 review: the string at [a, end] (end is the NUL) is referenced in the whole image (code and data, any alignment) only by `push imm32` of its start `a`, directly in front of the destination push of a call of a function of `writers`
    named sprintf: `push a; push <dest>; call sprintf` (register set-ups -- `mov`/`add`/`sub`/`lea` into a register other than esp/ebp from anything but a frame address -- may stand between), the string being argument 1. So no instruction writes it by an absolute address, no pointer to it is stored or passed to anything else (strcpy, memset, a table of pointers). Not shown: that nothing
    writes the bytes through an address computed from another base (the residual assumption of the sprintf rule)."""
    key = (id(image), a, end)
    if key in _FORMAT_REFS and _FORMAT_REFS[key][0] is image:                  # (the image object is kept, so that a recycled id cannot return the answer for another image)
        return _FORMAT_REFS[key][1]
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    ok = True
    for x in range(a, end + 1):
        pat, k = struct.pack('<I', x), image.find(struct.pack('<I', x))
        while k >= 0 and ok:
            if x != a or k == 0 or image[k - 1] != 0x68:
                ok = False
                break
            pushes, call = 0, None
            for i in md.disasm(image[k - 1:k - 1 + 40], IMAGE_BASE + k - 1):
                if i.address == IMAGE_BASE + k - 1:
                    continue                                                     # the push of the format itself
                if i.mnemonic == 'push':
                    pushes += 1
                elif i.mnemonic == 'call':
                    call = i
                    break
                elif not _reg_setup(i):
                    break
            if call is None or pushes != 1 or call.operands[0].type != X.X86_OP_IMM or writers.get(call.operands[0].imm & 0xffffffff, ('',))[0] != 'sprintf':
                ok = False
                break
            k = image.find(pat, k + 1)
        if not ok:
            break
    _FORMAT_REFS[key] = (image, ok)
    return ok


def constant_format(image, pushes, n, writers=None):
    """FL-78 review: for the sprintf rule, the format (argument 1) is a `push imm` of the address of a string literal inside the image, the string is non-empty printable ASCII ended by a NUL within 256 bytes and every conversion of it only reads
    (`format_text_ok`), the string is referenced in the image only as the format of sprintf calls (`format_references_ok`), and the frame address is not itself the format (n == 1) -- `pushes` are the pushes behind the one of the frame address, the last of them argument 0.
    The residual assumption (RULE_TEXT2) is that nothing writes the bytes of the literal through an address computed from another base."""
    if image is None or n < 2 or len(pushes) < n - 1:
        return False
    fmt = pushes[n - 2]
    if fmt.operands[0].type != X.X86_OP_IMM:
        return False
    a = fmt.operands[0].imm & 0xffffffff
    if not (IMAGE_BASE <= a < IMAGE_BASE + len(image)):
        return False
    off = a - IMAGE_BASE
    end = image.find(b'\0', off, off + 256)
    return end > off and format_text_ok(bytes(image[off:end])) and format_references_ok(image, a, IMAGE_BASE + end, LIBRARY_WRITERS if writers is None else writers)


def _reg_setup(i):
    """True for an instruction that only computes a value into a 32-bit register other than esp/ebp from something that is not a frame address: `mov`, `add`, `sub`, `lea` from anything but ebp/esp"""
    o = i.operands
    if i.mnemonic not in ('mov', 'add', 'sub', 'lea') or len(o) != 2 or o[0].type != X.X86_OP_REG or o[0].size != 4 or i.reg_name(o[0].reg) in ('esp', 'ebp'):
        return False
    if o[1].type == X.X86_OP_REG:
        return i.reg_name(o[1].reg) not in ('esp', 'ebp')
    if o[1].type == X.X86_OP_MEM:
        m = o[1].mem
        if m.segment or (m.base and i.reg_name(m.base) == 'esp') or (m.index and i.reg_name(m.index) == 'esp'):
            return False
        return not (i.mnemonic == 'lea' and ((m.base and i.reg_name(m.base) == 'ebp') or (m.index and i.reg_name(m.index) == 'ebp')))
    return o[1].type == X.X86_OP_IMM


def _pushes_to_call(seq, j, R, targets):
    """FL-78: from `seq[j]` (the instruction behind `push R`) the pushes and register set-ups up to the next call: (n, pushes, call index) with n the number of pushes behind the one of R, or None when something else comes first, an instruction is a branch target, R is
    read or written, or the frame base is pushed."""
    n, pushes = 0, []
    while True:
        if j >= len(seq):
            return None
        i = seq[j]
        if i.address in targets:
            return None
        if i.mnemonic == 'call':
            return n, pushes, j
        rd, wr = _rw(i)
        if R in rd or R in _full(wr) or 'esp' in rd and i.mnemonic != 'push':
            return None
        if i.mnemonic == 'push':
            o = i.operands[0]
            if o.size != 4 or o.type == X.X86_OP_MEM and (o.mem.segment or (o.mem.base and i.reg_name(o.mem.base) == 'esp') or (o.mem.index and i.reg_name(o.mem.index) == 'esp')):
                return None
            if o.type == X.X86_OP_REG and i.reg_name(o.reg) in ('esp', 'ebp'):          # FL-78 review: pushing the frame base would pass another frame address to the call
                return None
            pushes.append(i)
            n += 1
        elif not _reg_setup(i):
            return None
        j += 1


def _push_arg(insns, pos, lea, first, targets, pushes, n, k):
    """the immediate that was pushed as argument k of the call (argument 0 is the last pushed): behind the push of the frame address (`first`, with the `n` pushes after it in `pushes`) or in the straight line in front of it (the lea itself is stepped over, nothing else
    but pushes and `_reg_setup` instructions, no branch target); None when it is not an immediate or not found"""
    if k < n:
        p = pushes[n - 1 - k]
    else:
        need, cur, j = k - n, first, pos[first.address] - 1
        while True:
            if j < 0 or cur.address in targets:
                return None
            prev = insns[j]
            if prev.address == lea.address:
                pass
            elif prev.mnemonic == 'push':
                need -= 1
                if need == 0:
                    p = prev
                    break
            elif not _reg_setup(prev):
                return None
            cur, j = prev, j - 1
    return p.operands[0].imm & 0xffffffff if p.operands[0].type == X.X86_OP_IMM else None


def readonly_param(image, addr, argoff, writers, imports=None):
    """FL-78: True when the function at `addr` (a frame-based one) is shown by its bytes to only read through the pointer in its stack argument [ebp+argoff]: the slot is read only by `mov r32, [ebp+argoff]` (r in eax, ecx, edx), and each such register is next
    pushed as a source argument of a call of a function of `writers` (with its add esp), then overwritten or dead (`scan`). Nothing is stored through it, kept or passed anywhere else. The same preconditions as `out_param_extent` on the body."""
    got = function_insns(image, addr)
    if got is None:
        return False
    insns, by_addr = got
    if len(insns) < 3 or not (insns[0].mnemonic == 'push' and insns[0].op_str == 'ebp' and insns[1].mnemonic == 'mov' and insns[1].op_str == 'ebp, esp') or frame_escapes(insns) or callee_leaks(insns):
        return False
    targets = set()
    for i in insns:
        if (i.mnemonic == 'jmp' or i.mnemonic.startswith('j') or i.mnemonic.startswith('loop')) and i.operands[0].type == X.X86_OP_IMM:
            targets.add(i.operands[0].imm & 0xffffffff)
    loads = []
    for k, i in enumerate(insns):
        for o in i.operands:
            if o.type != X.X86_OP_MEM:
                continue
            base = i.reg_name(o.mem.base) if o.mem.base else None
            if base == 'esp' or (o.mem.index and i.reg_name(o.mem.index) == 'esp'):
                return False
            if base != 'ebp':
                continue
            if o.mem.index or o.mem.segment:
                return False
            lo, hi = o.mem.disp, o.mem.disp + o.size
            if lo < argoff + 4 and argoff < hi:
                if not (i.mnemonic == 'mov' and o is i.operands[1] and o.size == 4 and lo == argoff and i.operands[0].type == X.X86_OP_REG and i.reg_name(i.operands[0].reg) in ('eax', 'ecx', 'edx')):
                    return False
                loads.append(k)
            elif (o.access & capstone.CS_AC_WRITE or i.mnemonic.startswith(X87_STORES)) and hi > 0:
                return False
    for k in loads:
        R = insns[k].reg_name(insns[k].operands[0].reg)
        seq = insns[k + 1:]
        j = 0
        while j < len(seq):                                                      # up to the first instruction that touches R, in a straight line
            rd, wr = _rw(seq[j])
            if R in rd or R in _full(wr):
                break
            if seq[j].mnemonic == 'call' or seq[j].mnemonic in ('ret', 'retn') or seq[j].mnemonic.startswith('j') or seq[j].address in targets:
                return False
            j += 1
        if j >= len(seq) or seq[j].address in targets:
            return False
        first = seq[j]
        if not (first.mnemonic == 'push' and first.operands[0].type == X.X86_OP_REG and first.reg_name(first.operands[0].reg) == R and first.operands[0].size == 4):
            return False
        got2 = _pushes_to_call(seq, j + 1, R, targets)
        if got2 is None:
            return False
        n, pushes, jc = got2
        call = seq[jc]
        nxt = seq[jc + 1] if jc + 1 < len(seq) else None
        add = nxt.operands[1].imm if nxt is not None and nxt.mnemonic == 'add' and nxt.op_str.split(',')[0].strip() == 'esp' and nxt.operands[1].type == X.X86_OP_IMM and nxt.address not in targets else 0
        if call.operands[0].type != X.X86_OP_IMM:
            return False
        entry = writers.get(call.operands[0].imm & 0xffffffff)
        if entry is None or n in entry[1] or add < 4 * (n + 1) or len(entry) > 3 and n not in entry[3] or entry[0] in LIBRARY_POINTS_INTO_ARGUMENT:         # (the positions where a frame address is accepted: fread also writes through its stream; strstr hands a pointer into the buffer back, which this callee could return)
            return False
        if entry[0] == 'sprintf' and not constant_format(image, pushes, n, writers):
            return False
        held = set()
        if not scan(by_addr, call.address, R, _ALL, image, 1, imports, writers, held) or held:          # from the call on: the callee of the call reads none of it (listed), the pointer is overwritten on every path and none of it is left in the register at a ret
            return False
    return True


def _library_arg_lea(insns, ins, targets, by_addr, writers, image, callees, imports=None):
    ops = ins.operands
    if ins.mnemonic != 'lea' or ops[0].type != X.X86_OP_REG or ops[0].size != 4:
        return None
    R = ins.reg_name(ops[0].reg)
    mem = ops[1].mem
    if R not in ('eax', 'ecx', 'edx', 'esi') or not mem.base or ins.reg_name(mem.base) != 'ebp' or mem.index or mem.segment:
        return None
    pos = {i.address: k for k, i in enumerate(insns)}
    seq = insns[pos[ins.address] + 1:]

    def straight(i):
        return not (i.mnemonic == 'call' or i.mnemonic in ('ret', 'retn', 'jmp') or i.mnemonic.startswith('j') or i.mnemonic.startswith('loop') or i.address in targets)

    j = 0
    while True:                                                                  # up to the first instruction that touches R
        if j >= len(seq):
            return None
        i = seq[j]
        rd, wr = _rw(i)
        if R in rd or R in _full(wr):
            break
        if not straight(i):
            return None
        j += 1
    first = seq[j]
    if first.address in targets:
        return None
    if R == 'esi':                                                               # the source of a comparison of strings: repe cmpsb reads through esi and never writes the frame
        parts = first.mnemonic.split()
        if parts[-1] not in ('cmpsb', 'cmpsw', 'cmpsd') or parts[:-1] not in ([], ['repe'], ['repne']) or not dead_from(by_addr, first.address + first.size, 'esi', image, imports=imports, writers=writers):
            return None
        return {'kind': 'cmps'}
    if first.mnemonic == 'mov' and first.op_str == 'edi, ' + R:                    # the destination of an inline copy
        k = j + 1
        while k < len(seq):
            i = seq[k]
            parts = i.mnemonic.split()
            if len(parts) == 2 and parts[0] == 'rep' and parts[1][:-1] in ('movs', 'stos') and i.address not in targets:
                k += 1
                continue
            rd, wr = _rw(i)
            if i.address in targets or not straight(i) or 'edi' in rd or 'edi' in _full(wr):
                break
            k += 1
        if k >= len(seq):
            return None
        if not dead_from(by_addr, seq[j + 1].address, R, image, imports=imports, writers=writers) or not dead_from(by_addr, seq[k].address, 'edi', image, imports=imports, writers=writers):
            return None
        return {'kind': 'copy'}
    if not (first.mnemonic == 'push' and first.operands[0].type == X.X86_OP_REG and first.reg_name(first.operands[0].reg) == R and first.operands[0].size == 4):
        return None
    got = _pushes_to_call(seq, j + 1, R, targets)
    if got is None:
        return None
    n, pushes, jc = got
    call = seq[jc]
    if call.operands[0].type != X.X86_OP_IMM:
        return None
    callee = call.operands[0].imm & 0xffffffff
    nxt = seq[jc + 1] if jc + 1 < len(seq) else None
    add = nxt.operands[1].imm if nxt is not None and nxt.mnemonic == 'add' and nxt.op_str.split(',')[0].strip() == 'esp' and nxt.operands[1].type == X.X86_OP_IMM and nxt.address not in targets else 0
    pops = callees.get(callee)
    if pops is None and add == 0 or (pops or 0) + add < 4 * (n + 1):
        return None
    entry = writers.get(callee)
    if entry is not None:
        if add < 4 * (n + 1) or len(entry) > 3 and n not in entry[3]:
            return None
        if n in entry[1]:                                                        # a destination position: only a function with a write model (a third element)
            if len(entry) < 3:
                return None
            spec = entry[2]
            ext = None
            if spec is not None:
                a, b = _push_arg(insns, pos, ins, first, targets, pushes, n, spec[1]), _push_arg(insns, pos, ins, first, targets, pushes, n, spec[2])
                if a is None or b is None:
                    return None
                ext = a * b if a * b <= 4096 else None
            regs, info = (R,), {'kind': 'dest', 'call': call.address, 'off': 4 * n, 'extent': ext, 'fn': entry[0]}
        else:
            if entry[0] == 'sprintf' and not constant_format(image, pushes, n, writers):
                return None
            if entry[0] in LIBRARY_POINTS_INTO_ARGUMENT and not scan(by_addr, call.address + call.size, 'eax', _ALL, image, 1, imports, writers, None, addr_ok=_result_use_ok):          # FL-78 (round 9 review): eax is a pointer into the buffer: only compared, tested or read through
                return None
            regs, info = (R,), {'kind': 'source', 'fn': entry[0]}
    else:
        if image is None:
            return None
        ext = out_param_extent(image, callee, 8 + 4 * n, imports)
        if ext:
            got2 = function_insns(image, callee)
            if got2 is None or not scan(got2[1], got2[0][0].address, R, _ALL, image, 1, imports, writers, set()):             # FL-78 review: R still holds the frame address at the call; the callee must not read it (it could store through it, or keep it)
                return None
            regs, info = ('eax', 'ecx', 'edx'), {'kind': 'out', 'call': call.address, 'off': 4 * n, 'extent': ext}
        elif readonly_param(image, callee, 8 + 4 * n, writers, imports):         # a member function that only passes the pointer on as a source argument of a listed library function and keeps no copy of it in a register
            regs, info = (R,), {'kind': 'ro'}
        else:
            return None
    after = call.address if info['kind'] in ('source', 'dest', 'ro') else call.address + call.size       # (a listed function or a read-only callee: R holds the frame address AT the call, so the scan starts there; it reads none, and a result may overwrite R)
    if any(not dead_from(by_addr, after, r, image, imports=imports, writers=writers) for r in regs):
        return None
    return info


def cell_lea(insns, ins, targets, by_addr, image=None, imports=None, writers=None):
    """FL-78 (round 9): a description when `lea R, [ebp+disp]` (R in eax, ecx, edx) is followed in a straight line (no jump, call or branch target) by `mov dword ptr [ebp+c], R` (c <= -4: a 4 byte local) as the first instruction that touches R, and R is dead after the store:
    the frame address goes into the local `c` (a pointer cell) and nowhere else. `pointer_cell` checks that the cell is used only as a pointer."""
    try:
        ops = ins.operands
        if ins.mnemonic != 'lea' or ops[0].type != X.X86_OP_REG or ops[0].size != 4:
            return None
        R = ins.reg_name(ops[0].reg)
        mem = ops[1].mem
        if R not in ('eax', 'ecx', 'edx') or not mem.base or ins.reg_name(mem.base) != 'ebp' or mem.index or mem.segment:
            return None
        pos = {i.address: k for k, i in enumerate(insns)}
        j = pos[ins.address] + 1
        while True:
            if j >= len(insns):
                return None
            i = insns[j]
            if i.address in targets:
                return None
            rd, wr = _rw(i)
            if R in rd or R in _full(wr):
                break
            if i.mnemonic in ('call', 'ret', 'retn', 'jmp') or i.mnemonic.startswith('j') or i.mnemonic.startswith('loop'):
                return None
            j += 1
        first = insns[j]
        o = first.operands
        if first.mnemonic != 'mov' or len(o) != 2 or o[0].type != X.X86_OP_MEM or o[1].type != X.X86_OP_REG or first.reg_name(o[1].reg) != R or o[0].size != 4:
            return None
        m = o[0].mem
        if not m.base or first.reg_name(m.base) != 'ebp' or m.index or m.segment or m.disp > -4:
            return None
        if not dead_from(by_addr, first.address + first.size, R, image, imports=imports, writers=writers):
            return None
        return {'kind': 'cell', 'cell': m.disp, 'store': first.address}
    except capstone.CsError:
        return None


def pointer_cell(insns, leas, kinds, by_addr, image=None, imports=None, writers=None):
    """FL-78 (round 9): the pointer-cell rule for a function whose only unexplained frame addresses are the `cell_lea`s `leas` ({lea address: description}); `kinds` are the kinds of the frame addresses that library_arg_lea followed. The result is {'loads': [...], 'rmw': [...]} (the addresses of the
    instructions that read the cell) or None. Conditions: the leas share one cell (a 4 byte local); the other frame addresses are only read (library source, read-only callee, string comparison); no memory operand with esp as base, or ebp or esp as index (it could reach the cell); every
    access to the cell's bytes through ebp+disp is one of: the stores of the leas, `mov r32, [cell]` (r in eax, ecx, edx) after which r is used only as the address of memory operands until it is overwritten (`scan` with addr_ok: not computed with, not stored, not passed, not live at a ret or across a call that
    could read it), or `add dword ptr [cell], imm`. So the cell holds a frame address only, and every register that holds a copy of it is used as an address."""
    cells = {v['cell'] for v in leas.values()}
    if len(cells) != 1 or any(k not in ('source', 'ro', 'cmps') for k in kinds):
        return None
    c = next(iter(cells))
    stores = {v['store'] for v in leas.values()}
    loads, rmw, users = [], [], set()
    for i in insns:
        for o in i.operands:
            if o.type != X.X86_OP_MEM or o.mem.segment == X.X86_REG_FS:
                continue
            m = o.mem
            base = i.reg_name(m.base) if m.base else None
            index = i.reg_name(m.index) if m.index else None
            if base == 'esp' or index in ('esp', 'ebp') or (base == 'ebp' and index):
                return None
            if base != 'ebp' or not (m.disp < c + 4 and c < m.disp + o.size):
                continue
            if i.address in stores and i.mnemonic == 'mov' and o is i.operands[0]:
                continue
            if i.mnemonic == 'mov' and o is i.operands[1] and o.size == 4 and m.disp == c and i.operands[0].type == X.X86_OP_REG and i.operands[0].size == 4 and i.reg_name(i.operands[0].reg) in ('eax', 'ecx', 'edx'):
                r = i.reg_name(i.operands[0].reg)
                if not scan(by_addr, i.address + i.size, r, _ALL, image, 1, imports, writers, None, addr_ok=True, users=users):
                    return None
                loads.append(i.address)
                continue
            if i.mnemonic == 'add' and o is i.operands[0] and o.size == 4 and m.disp == c and i.operands[1].type == X.X86_OP_IMM:
                rmw.append(i.address)
                continue
            return None
    return {'loads': loads, 'rmw': rmw, 'users': users}


def merge(items):
    """items: [(edge condition, State)] with mutually exclusive conditions. The merged state selects the value of the edge taken."""
    if len(items) == 1:
        return items[0][1].copy()
    out = items[-1][1].copy()
    for c, s in reversed(items[:-1]):
        for r in FULL:
            out.R[r] = ite(c, s.R[r], out.R[r])
        for f in FLAGS:
            out.F[f] = ite(c, s.F[f], out.F[f])
        out.mem = ite(c, s.mem, out.mem)
        out.frm = ite(c, s.frm, out.frm)
        out.fs = ite(c, s.fs, out.fs)
        out.fp = tuple(None if a is None or b is None else ite(c, a, b) for a, b in zip(s.fp, out.fp))
    out.pc = z3.BoolVal(True)
    return out


class Machine:
    """Symbolic semantics of the instructions of the pending game functions; `Unsupported` for anything else."""

    def __init__(self, row, image):
        self.row = row
        self.image = image
        self.callees = {int(k): v for k, v in row.get('callees', {}).items()}
        self.imports = {int(k): v for k, v in row.get('imports', {}).items()}
        self.sites = {int(k): v for k, v in (row.get('sites') or {}).items()}
        self.noreturn = {int(a) for a in row.get('noreturn', ())}          # FL-72: callees that never return (tests/fl72_noreturn.json): a path that calls one ends there
        self.bounds = {}        # FL-75: callee address -> the bound on eax that its bytes prove (ret_bound)
        self.split = False      # the frame assumption holds for this function (set by Analysis)
        self.temps = None       # FL-78 (round 8): (L, delta) in a window run under the stack-discipline assumption (`Analysis.temps_info`): only the call temporaries (addresses below ebp - L) are in `frm`; delta = esp - ebp at the window's start
        self.cell_ops = set()   # FL-78 (round 9): the instructions that read a pointer cell (pointer_cell): the value they read must be a frame address (mem_read raises Unsupported otherwise)
        self.after_call = {}    # call address -> bytes the next instruction `add esp, k` removes
        self.out_writes = {}    # FL-78: call address -> [(offset of the pushed frame pointer from esp at the call, bytes the callee writes through it)] (library_arg_lea kind 'out')
        self.pure = {}          # FL-78: callee address -> pure_callee (memoised): a call of one leaves memory as it was
        self.facts = []         # facts about the START memory (constant bytes of the image), valid in every query
        self.fact_keys = set()
        self.inv_facts = []     # FL-78: the loop invariants assumed at generalised headers, [(key, guarded formula)]; kept apart from `facts` so that the check of an invariant can leave out the facts it must not use (Analysis.check `only`)
        self.ins = None

    # ---- registers -------------------------------------------------------------------------------------------------------------------------

    def reg_get(self, st, name):
        if name not in REGS:
            raise Unsupported('register ' + name)
        full, s, shift = REGS[name]
        e = st.R[full]
        return e if s == 4 else z3.Extract(shift + 8 * s - 1, shift, e)

    def reg_set(self, st, name, val):
        if name not in REGS:
            raise Unsupported('register ' + name)
        full, s, shift = REGS[name]
        if s == 4:
            st.R[full] = val
            return
        old = st.R[full]
        parts = []
        if shift + 8 * s < 32:
            parts.append(z3.Extract(31, shift + 8 * s, old))
        parts.append(val)
        if shift:
            parts.append(z3.Extract(shift - 1, 0, old))
        st.R[full] = z3.Concat(*parts) if len(parts) > 1 else parts[0]

    # ---- memory ----------------------------------------------------------------------------------------------------------------------------

    def ea(self, st, op):
        m = op.mem
        a = bv(m.disp, 32)
        if m.base:
            a = a + self.reg_get(st, self.ins.reg_name(m.base))
        if m.index:
            a = a + self.reg_get(st, self.ins.reg_name(m.index)) * m.scale
        return z3.simplify(a)

    def assume_ok(self, st, addr, n):
        st.pc = z3.And(st.pc, z3.ULE(addr, bv(FAULT_LIMIT - n, 32)))

    def space(self, st, a, op=None, n=1):
        """Which memory an address belongs to. With the frame assumption (see the module text) an address that is built from the entry esp (every ebp/esp-relative
        access) is in the function's own frame, every other address is not."""
        if op is not None and op.mem.segment == X.X86_REG_FS:
            return 'fs'
        if not (self.split and has_frame_term(a)):
            return 'mem'
        return 'frm' if self.temps is None or self.is_temp(a, n) else 'mem'

    def is_temp(self, a, n=1):
        """FL-78 (round 8), stack-discipline mode: True for a frame address below the locals (ebp - L), a call temporary: a pushed slot or an argument slot of a call. False for a frame address in the locals or the arguments of the function (then it is in `mem`, where
        any pointer, an escaped `lea [ebp - X]` among them, may reach it). A frame address whose offset is not a constant is not modelled."""
        L, delta = self.temps
        s_esp, s_ebp = z3.BitVec('s_esp', 32), z3.BitVec('s_ebp', 32)
        c = z3.simplify(z3.substitute(a, (s_esp, s_ebp + bv(delta, 32))) - s_ebp)
        if not z3.is_bv_value(c):
            raise Unsupported('a frame address with an offset that is not constant')
        c = c.as_long()
        c = c - (1 << 32) if c >= 1 << 31 else c
        if c < -L < c + n:
            raise Unsupported('an access that straddles the bottom of the locals')
        return c < -L

    def temp_value(self, val):
        """FL-78 (round 8 review): in stack-discipline mode a value that is an address of a call temporary is not stored or pushed anywhere (the pointer could then be read back as an ordinary value and followed as one). Other values that contain a frame address are pointers to the locals."""
        if self.temps is not None and self.split and has_frame_term(val) and (val.size() != 32 or self.is_temp(val)):
            raise Unsupported('the address of a call temporary is stored')

    def mem_read(self, st, op, n):
        a = self.ea(st, op)
        self.assume_ok(st, a, n)
        sp = self.space(st, a, op, n)
        if sp == 'mem':
            c = a.as_long() if z3.is_bv_value(a) else None
            if c is not None and IMAGE_BASE <= c and c + n <= DATA_START:
                self.const_facts(c, n)
        v = self.load(getattr(st, sp), a, n)
        if self.split and self.ins is not None and self.ins.address in self.cell_ops:
            v = z3.simplify(v)                                      # FL-78 (round 9): a read of the pointer cell must give a frame address, else the registers that take it would be followed as ordinary pointers (their stores would go to `mem`)
            if sp != 'frm' or n != 4 or not pure_frame_term(v):
                raise Unsupported('the pointer cell does not hold a frame address on every path here')
        return v

    def const_facts(self, c, n):
        for k in range(n):
            if c + k not in self.fact_keys:
                self.fact_keys.add(c + k)
                self.facts.append(z3.Select(z3.Array('s_mem', z3.BitVecSort(32), z3.BitVecSort(8)), bv(c + k, 32)) == bv(self.image[c + k - IMAGE_BASE], 8))

    @staticmethod
    def load(arr, a, n):
        return z3.Concat(*[z3.Select(arr, a + k) for k in reversed(range(n))]) if n > 1 else z3.Select(arr, a)

    def mem_write(self, st, op, val, n):
        a = self.ea(st, op)
        self.assume_ok(st, a, n)
        sp = self.space(st, a, op, n)
        self.temp_value(val)
        setattr(st, sp, self.store(getattr(st, sp), a, val, n))

    def mem_havoc(self, st, a, n):
        """A write of n unknown bytes at a."""
        self.assume_ok(st, a, n)
        sp = self.space(st, a, None, n)
        arr = getattr(st, sp)
        for k in range(n):
            arr = z3.Store(arr, a + k, fresh(8, 'x'))
        setattr(st, sp, arr)

    # ---- operands --------------------------------------------------------------------------------------------------------------------------

    def read(self, st, op, size=None):
        if op.type == X.X86_OP_REG:
            return self.reg_get(st, self.ins.reg_name(op.reg))
        if op.type == X.X86_OP_IMM:
            return bv(op.imm, 8 * (size or op.size))
        if op.type == X.X86_OP_MEM:
            return self.mem_read(st, op, size or op.size)
        raise Unsupported('operand type')

    def write(self, st, op, val):
        if op.type == X.X86_OP_REG:
            self.reg_set(st, self.ins.reg_name(op.reg), val)
        elif op.type == X.X86_OP_MEM:
            self.mem_write(st, op, val, op.size)
        else:
            raise Unsupported('write operand')

    def push(self, st, val):
        sp = st.R['esp'] - 4
        st.R['esp'] = sp
        self.assume_ok(st, sp, 4)
        space = self.space(st, sp, None, 4)
        self.temp_value(val)
        setattr(st, space, self.store(getattr(st, space), sp, val, 4))

    @staticmethod
    def store(arr, a, val, n):
        for k in range(n):
            arr = z3.Store(arr, a + k, z3.Extract(8 * k + 7, 8 * k, val) if n > 1 else val)
        return arr

    def pop(self, st):
        sp = st.R['esp']
        self.assume_ok(st, sp, 4)
        v = self.load(getattr(st, self.space(st, sp, None, 4)), sp, 4)
        st.R['esp'] = sp + 4
        return v

    # ---- flags -----------------------------------------------------------------------------------------------------------------------------

    @staticmethod
    def unknown_flags(st, names=FLAGS):
        for f in names:
            st.F[f] = fresh_bool()

    def set_zsp(self, st, r, w):
        st.F['zf'] = r == 0
        st.F['sf'] = msb(r, w)
        st.F['pf'] = fresh_bool()
        st.F['af'] = fresh_bool()

    def alu(self, st, op, a, b, w, carry=None):
        """Result and flags of add/sub/adc/sbb/and/or/xor/cmp/test at width w."""
        if op in ('add', 'adc'):
            c = z3.If(carry, bv(1, w), bv(0, w)) if op == 'adc' else bv(0, w)
            r = a + b + c
            wide = z3.ZeroExt(1, a) + z3.ZeroExt(1, b) + z3.ZeroExt(1, c)
            st.F['cf'] = z3.Extract(w, w, wide) == 1
            st.F['of'] = msb((a ^ r) & (b ^ r), w)
        elif op in ('sub', 'sbb', 'cmp'):
            c = z3.If(carry, bv(1, w), bv(0, w)) if op == 'sbb' else bv(0, w)
            r = a - b - c
            st.F['cf'] = z3.ULT(z3.ZeroExt(1, a), z3.ZeroExt(1, b) + z3.ZeroExt(1, c))
            st.F['of'] = msb((a ^ b) & (a ^ r), w)
        else:
            r = a & b if op in ('and', 'test') else a | b if op == 'or' else a ^ b
            st.F['cf'] = z3.BoolVal(False)
            st.F['of'] = z3.BoolVal(False)
        self.set_zsp(st, r, w)
        return r

    @staticmethod
    def cond(st, cc):
        F = st.F
        c = CC[cc]
        return {'e': F['zf'], 'ne': z3.Not(F['zf']), 'b': F['cf'], 'ae': z3.Not(F['cf']), 'be': z3.Or(F['cf'], F['zf']), 'a': z3.And(z3.Not(F['cf']), z3.Not(F['zf'])),
                'l': F['sf'] != F['of'], 'ge': F['sf'] == F['of'], 'le': z3.Or(F['zf'], F['sf'] != F['of']), 'g': z3.And(z3.Not(F['zf']), F['sf'] == F['of']),
                's': F['sf'], 'ns': z3.Not(F['sf']), 'o': F['of'], 'no': z3.Not(F['of']), 'p': F['pf'], 'np': z3.Not(F['pf'])}[c]

    # ---- one instruction -------------------------------------------------------------------------------------------------------------------

    def step(self, st, ins):
        """Apply one instruction to `st` (in place). Returns None, or ('br', condition) for a conditional jump (the state is the state on BOTH edges)."""
        self.ins = ins
        m = ins.mnemonic
        ops = ins.operands
        if m.startswith('rep'):
            parts = m.split()
            if len(parts) != 2 or parts[1] not in ('movsb', 'movsw', 'movsd', 'stosb', 'stosw', 'stosd', 'scasb', 'cmpsb', 'cmpsd', 'cmpsw', 'scasd', 'scasw'):
                raise Unsupported(m)
            return self.string(st, ins, parts[1], parts[0])
        if m in ('movsb', 'movsw', 'movsd', 'stosb', 'stosw', 'stosd', 'scasb', 'cmpsb'):
            if any(o.type == X.X86_OP_REG and ins.reg_name(o.reg).startswith('xmm') for o in ops):
                raise Unsupported(m)                 # SSE2 movsd xmm
            return self.string(st, ins, m, None)
        if m == 'mov':
            self.write(st, ops[0], self.read(st, ops[1], ops[0].size))
        elif m in ('movzx', 'movsx'):
            v = self.read(st, ops[1])
            w = 8 * ops[0].size
            self.write(st, ops[0], z3.ZeroExt(w - 8 * ops[1].size, v) if m == 'movzx' else z3.SignExt(w - 8 * ops[1].size, v))
        elif m == 'lea':
            self.write(st, ops[0], self.ea(st, ops[1]) if ops[0].size == 4 else z3.Extract(8 * ops[0].size - 1, 0, self.ea(st, ops[1])))
        elif m == 'push':
            if ops[0].type == X.X86_OP_IMM:
                if ops[0].size != 4:
                    raise Unsupported('push size')
                self.push(st, bv(ops[0].imm, 32))
            elif ops[0].size != 4:
                raise Unsupported('push size')
            else:
                self.push(st, self.read(st, ops[0], 4))
        elif m == 'pop':
            if ops[0].size != 4:
                raise Unsupported('pop size')
            v = self.pop(st)
            self.write(st, ops[0], v)
        elif m in ('add', 'sub', 'and', 'or', 'xor', 'cmp', 'test', 'adc', 'sbb'):
            w = 8 * ops[0].size
            a = self.read(st, ops[0])
            b = self.read(st, ops[1], ops[0].size)
            if ops[1].type == X.X86_OP_IMM:
                b = bv(ops[1].imm, w)
            r = self.alu(st, m, a, b, w, st.F['cf'] if m in ('adc', 'sbb') else None)
            if m not in ('cmp', 'test'):
                self.write(st, ops[0], r)
        elif m in ('inc', 'dec'):
            w = 8 * ops[0].size
            a = self.read(st, ops[0])
            cf = st.F['cf']
            r = self.alu(st, 'add' if m == 'inc' else 'sub', a, bv(1, w), w)
            st.F['cf'] = cf
            self.write(st, ops[0], r)
        elif m == 'neg':
            w = 8 * ops[0].size
            a = self.read(st, ops[0])
            r = self.alu(st, 'sub', bv(0, w), a, w)
            st.F['cf'] = a != 0
            self.write(st, ops[0], r)
        elif m == 'not':
            self.write(st, ops[0], ~self.read(st, ops[0]))
        elif m in ('shl', 'shr', 'sar'):
            self.shift(st, m, ops)
        elif m in ('rcl', 'rcr'):
            self.rotate_carry(st, m, ops)
        elif m == 'imul':
            self.imul(st, ops)
        elif m in ('mul', 'div', 'idiv'):
            self.muldiv(st, m, ops[0])
        elif m == 'cdq':
            st.R['edx'] = z3.If(msb(st.R['eax'], 32), bv(0xffffffff, 32), bv(0, 32))
        elif m.startswith('set'):
            self.write(st, ops[0], z3.If(self.cond(st, m[3:]), bv(1, 8), bv(0, 8)))
        elif m == 'nop':
            pass
        elif m == 'leave':
            st.R['esp'] = st.R['ebp']
            st.R['ebp'] = self.pop(st)
        elif m == 'call':
            self.call(st, ins)
        elif m == 'sahf':                                              # FL-78 (round 7): CF, PF, AF, ZF, SF from bits 0, 2, 4, 6, 7 of ah
            ah = st.R['eax']
            for flag, bit in (('cf', 8), ('pf', 10), ('af', 12), ('zf', 14), ('sf', 15)):
                st.F[flag] = z3.Extract(bit, bit, ah) == 1
        elif m.startswith('f') or m == 'wait':
            self.x87(st, ins)
        elif m in ('jmp', 'ret'):
            return None
        elif m.startswith('j') or m.startswith('loop'):
            return ('br', self.branch(st, ins))
        else:
            raise Unsupported('instruction ' + m)
        return None

    def branch(self, st, ins):
        m = ins.mnemonic
        if m in ('jecxz', 'jcxz'):
            return st.R['ecx'] == 0
        if m.startswith('loop'):
            st.R['ecx'] = st.R['ecx'] - 1
            c = st.R['ecx'] != 0
            if m == 'loope':
                c = z3.And(c, st.F['zf'])
            elif m == 'loopne':
                c = z3.And(c, z3.Not(st.F['zf']))
            return c
        cc = m[1:]
        if cc not in CC:
            raise Unsupported('jump ' + m)
        return self.cond(st, cc)

    def rotate_carry(self, st, m, ops):
        """FL-78 (round 7): `rcl` / `rcr` by the immediate 1 of a register or memory operand (the multi-word shift of an unsigned 64 bit division): the carry flag goes in at one end and the bit that leaves goes to cf. The overflow flag is left unknown, zf sf pf af are unchanged."""
        if len(ops) != 2 or ops[1].type != X.X86_OP_IMM or ops[1].imm & 31 != 1:
            raise Unsupported(m)
        w = 8 * ops[0].size
        a = self.read(st, ops[0])
        cin = z3.If(st.F['cf'], bv(1, 1), bv(0, 1))
        if m == 'rcr':
            r = z3.Concat(cin, z3.Extract(w - 1, 1, a))
            out = z3.Extract(0, 0, a) == 1
        else:
            r = z3.Concat(z3.Extract(w - 2, 0, a), cin)
            out = z3.Extract(w - 1, w - 1, a) == 1
        st.F['cf'] = out
        st.F['of'] = fresh_bool()
        self.write(st, ops[0], r)

    def shift(self, st, m, ops):
        w = 8 * ops[0].size
        a = self.read(st, ops[0])
        if ops[1].type == X.X86_OP_IMM:
            n = ops[1].imm & 31
            if n == 0:
                return
            if n >= w:                   # undefined flags; the result of a shift by >= width of a narrow operand is not modelled
                raise Unsupported('shift count')
            c = bv(n, w)
            r = a << c if m == 'shl' else z3.LShR(a, c) if m == 'shr' else a >> c
            if m == 'shl':
                st.F['cf'] = z3.Extract(w - n, w - n, a) == 1
            else:
                st.F['cf'] = z3.Extract(n - 1, n - 1, a) == 1
            if n == 1:
                st.F['of'] = (msb(r, w) != st.F['cf']) if m == 'shl' else (msb(a, w) if m == 'shr' else z3.BoolVal(False))
            else:
                st.F['of'] = fresh_bool()
            self.set_zsp(st, r, w)
            self.write(st, ops[0], r)
        else:                            # count in cl
            cnt = z3.ZeroExt(w - 8, self.reg_get(st, 'cl')) & bv(31, w)
            r = a << cnt if m == 'shl' else z3.LShR(a, cnt) if m == 'shr' else a >> cnt
            old = dict(st.F)
            self.unknown_flags(st)
            for f in FLAGS:
                st.F[f] = ite(cnt == 0, old[f], st.F[f])
            if w < 32:
                raise Unsupported('shift by cl of a narrow operand')
            self.write(st, ops[0], r)

    def imul(self, st, ops):
        w = 8 * ops[0].size
        if len(ops) == 1:
            raise Unsupported('one-operand imul')
        if len(ops) == 2:
            a, b = self.read(st, ops[0]), self.read(st, ops[1], ops[0].size)
        else:
            a, b = self.read(st, ops[1]), bv(ops[2].imm, w)
        wide = z3.SignExt(w, a) * z3.SignExt(w, b)
        r = a * b
        ov = z3.SignExt(w, r) != wide
        self.unknown_flags(st)
        st.F['cf'] = ov
        st.F['of'] = ov
        self.write(st, ops[0], r)

    def muldiv(self, st, m, op):
        if op.size != 4:
            raise Unsupported('narrow ' + m)
        v = self.read(st, op)
        eax, edx = st.R['eax'], st.R['edx']
        if m == 'mul':
            wide = z3.ZeroExt(32, eax) * z3.ZeroExt(32, v)
            st.R['eax'], st.R['edx'] = z3.Extract(31, 0, wide), z3.Extract(63, 32, wide)
            self.unknown_flags(st)
            st.F['cf'] = st.F['of'] = st.R['edx'] != 0
            return
        st.pc = z3.And(st.pc, v != 0)
        num = z3.Concat(edx, eax)
        if m == 'div':
            q = z3.UDiv(num, z3.ZeroExt(32, v))
            rem = z3.URem(num, z3.ZeroExt(32, v))
            st.pc = z3.And(st.pc, z3.Extract(63, 32, q) == 0)
        else:
            d = z3.SignExt(32, v)
            q = num / d
            rem = z3.SRem(num, d)
            st.pc = z3.And(st.pc, z3.SignExt(32, z3.Extract(31, 0, q)) == q)
        st.R['eax'], st.R['edx'] = z3.Extract(31, 0, q), z3.Extract(31, 0, rem)
        self.unknown_flags(st)

    def ret_bound(self, addr):
        """FL-75: K when the code at `addr` is straight-line (no jump, no second ret, a call at most) and ends `and eax, K; ret` with 0 <= K < 2**31: every return from it has 0 <= eax <= K (an unsigned compare, so also
        non-negative). The CRT rand() is of this form. None otherwise. This reads the callee's own bytes, nothing is trusted."""
        if addr in self.bounds:
            return self.bounds[addr]
        out = None
        if IMAGE_BASE <= addr < DATA_START:
            md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
            md.detail = True
            prev = None
            for n, i in enumerate(md.disasm(self.image[addr - IMAGE_BASE:addr - IMAGE_BASE + 256], addr)):
                if i.mnemonic in ('ret', 'retn'):
                    if (i.operands == [] or i.mnemonic == 'ret') and prev is not None and prev.mnemonic == 'and' and prev.operands[1].type == X.X86_OP_IMM \
                            and prev.operands[0].type == X.X86_OP_REG and prev.reg_name(prev.operands[0].reg) == 'eax' and 0 <= prev.operands[1].imm < 2 ** 31:
                        out = prev.operands[1].imm
                    break
                if i.mnemonic.startswith('j') or i.mnemonic.startswith('loop') or i.mnemonic in ('int', 'int3', 'ud2', 'hlt', 'iret'):
                    break
                prev = i
        self.bounds[addr] = out
        return out

    def is_pure(self, addr):
        if self.image is None:
            return False
        if addr not in self.pure:
            self.pure[addr] = pure_callee(self.image, addr)
        return self.pure[addr]

    def call(self, st, ins):
        op = ins.operands[0]
        pops = None
        if op.type == X.X86_OP_IMM:
            pops = self.callees.get(op.imm & 0xffffffff)
        elif op.type == X.X86_OP_MEM and not op.mem.base and not op.mem.index and (op.mem.disp & 0xffffffff) in self.imports:
            pops = self.imports[op.mem.disp & 0xffffffff]
        if pops is None:
            pops = self.sites.get(ins.address)
        if op.type != X.X86_OP_IMM:
            self.read(st, op, 4)                     # the pointer is read (and must not fault)
        st.fp = (None, None)                         # the callee may use the x87 unit
        sp = st.R['esp']
        ptrs = [(z3.simplify(self.load(st.frm, sp + off, 4)), ext) for off, ext in self.out_writes.get(ins.address, ())] if self.split else []         # FL-78: frame pointers the callee writes through (read before the argument slots are overwritten)
        for r in ('eax', 'ecx', 'edx'):
            st.R[r] = fresh(32, 'c')
        if op.type == X.X86_OP_IMM:
            k = self.ret_bound(op.imm & 0xffffffff)
            if k is not None:
                st.pc = z3.And(st.pc, z3.ULE(st.R['eax'], bv(k, 32)))      # FL-75: the callee's own code bounds what it returns (a prefix of the run: this only removes states)
        if not (op.type == X.X86_OP_IMM and self.is_pure(op.imm & 0xffffffff)):
            st.mem = fresh_array()
            st.fs = fresh_array('fa')
        if self.split:               # the callee may overwrite the argument slots that were pushed for it, nothing else of the frame
            span = (pops or 0) + self.after_call.get(ins.address, 0) if pops is not None else 64
            arr = st.frm
            for k in range(max(span, 0)):
                arr = z3.Store(arr, sp + k, fresh(8, 'x'))
            for ptr, ext in ptrs:                    # FL-78: exactly the bytes that out_param_extent read from the callee's code (or size * count of a listed function); no extent: any byte of the frame
                if ext is None:
                    arr = fresh_array('fr')
                    break
                for k in range(ext):
                    arr = z3.Store(arr, ptr + k, fresh(8, 'x'))
            st.frm = arr
        st.R['esp'] = sp + pops if pops is not None else fresh(32, 'sp')
        self.unknown_flags(st)
        if op.type == X.X86_OP_IMM and (op.imm & 0xffffffff) in self.noreturn:
            st.pc = z3.BoolVal(False)                  # the callee never returns: no run continues past this call

    def string(self, st, ins, base, rep):
        """movs/stos/cmps/scas, single or repeated. Over-approximated: a repeated one stores unknown bytes through unknown pointers (ecx ends at 0 for movs/stos)."""
        size = {'b': 1, 'w': 2, 'd': 4}[base[-1]]
        kind = base[:-1]
        edi, esi = st.R['edi'], st.R['esi']
        frame_dest = self.split and kind in ('movs', 'stos') and has_frame_term(edi)             # FL-78: the destination is a frame address that library_arg_lea followed (a copy into a local buffer)
        if self.temps is not None and self.split and any(has_frame_term(r) for r in (edi, esi)):
            raise Unsupported('a string instruction on a frame address in stack-discipline mode')       # FL-78 (round 8)
        if rep and frame_dest:
            self.assume_ok(st, edi, 1)
            st.mem = fresh_array()                                                                  # a store of unknown length through a frame address may write any byte of the frame (and, if the length
            st.frm = fresh_array('fr')                                                              # overruns, anything else): both memories are unknown, and edi stays a frame address
            st.R['edi'] = edi + fresh(32, 'rn')
            if kind == 'movs':
                st.R['esi'] = fresh(32, 'rs')
            st.R['ecx'] = bv(0, 32)
            return
        if rep:
            ecx = z3.simplify(st.R['ecx'])
            if kind in ('movs', 'stos') and z3.is_bv_value(ecx) and ecx.as_long() <= REP_EXACT:         # FL-70: a repeated store with a constant count is exact (the count is a known constant, the direction flag is clear)
                for _ in range(ecx.as_long()):
                    if kind == 'stos':
                        self.assume_ok(st, edi, size)
                        st.mem = self.store(st.mem, edi, z3.Extract(8 * size - 1, 0, st.R['eax']), size)
                        edi = edi + size
                    else:
                        self.assume_ok(st, esi, size)
                        self.assume_ok(st, edi, size)
                        st.mem = self.store(st.mem, edi, self.load(st.mem, esi, size), size)
                        esi, edi = esi + size, edi + size
                st.R['edi'] = edi
                if kind == 'movs':
                    st.R['esi'] = esi
                st.R['ecx'] = bv(0, 32)
                return
            if kind in ('movs', 'stos'):
                st.mem = fresh_array()
                st.R['edi'] = fresh(32, 'rd')
                if kind == 'movs':
                    st.R['esi'] = fresh(32, 'rs')
                st.R['ecx'] = bv(0, 32)
            else:
                st.R['ecx'] = fresh(32, 'rc')
                st.R['edi'] = fresh(32, 'rd')
                if kind == 'cmps':
                    st.R['esi'] = fresh(32, 'rs')
                self.unknown_flags(st)
            return
        dst = 'frm' if frame_dest else 'mem'
        if kind == 'stos':
            v = z3.Extract(8 * size - 1, 0, st.R['eax'])
            self.assume_ok(st, edi, size)
            setattr(st, dst, self.store(getattr(st, dst), edi, v, size))
            st.R['edi'] = edi + size
        elif kind == 'movs':
            self.assume_ok(st, esi, size)
            self.assume_ok(st, edi, size)
            v = self.load(getattr(st, self.space(st, esi, None, size)), esi, size)
            setattr(st, dst, self.store(getattr(st, dst), edi, v, size))
            st.R['esi'], st.R['edi'] = esi + size, edi + size
        else:
            raise Unsupported(base)

    def x87_compare(self, st, ins):
        """FL-78 (round 7): the one x87 pattern the prover models: `fld qword ptr [m]` or `fldz` puts 64 known bits in st(0); `fcom` / `fcomp qword ptr [m]` of those bits sets the condition codes (C0 st0 < m or unordered, C2 unordered, C3 st0 == m or unordered;
        the other bits of the status word are unknown) and `fnstsw ax` then gives that status word, so `sahf` and a conditional jump see an exact compare. Everything else on the x87 unit stays over-approximated, and forgets what is known.
        The assumptions (RULE_TEXT2): the x87 stack does not overflow or underflow at these instructions and the floating-point exceptions are masked. True when the instruction was handled."""
        m, ops = ins.mnemonic, ins.operands
        top, sw = st.fp
        if m == 'fld' and len(ops) == 1 and ops[0].type == X.X86_OP_MEM and ops[0].size == 8 and not ops[0].mem.segment:
            st.fp = (self.mem_read(st, ops[0], 8), None)
            return True
        if m == 'fldz' and not ops:
            st.fp = (bv(0, 64), None)
            return True
        if m in ('fcom', 'fcomp') and len(ops) == 1 and ops[0].type == X.X86_OP_MEM and ops[0].size == 8 and not ops[0].mem.segment and top is not None:
            other = self.mem_read(st, ops[0], 8)
            sort = z3.FPSort(11, 53)
            x, y = z3.fpBVToFP(top, sort), z3.fpBVToFP(other, sort)
            unordered = z3.Or(z3.fpIsNaN(x), z3.fpIsNaN(y))
            word = fresh(16, 'fs')
            word = word & bv(~0x4500, 16)
            word = word | z3.If(z3.Or(z3.fpLT(x, y), unordered), bv(0x0100, 16), bv(0, 16))
            word = word | z3.If(unordered, bv(0x0400, 16), bv(0, 16))
            word = word | z3.If(z3.Or(z3.fpEQ(x, y), unordered), bv(0x4000, 16), bv(0, 16))
            st.fp = (top if m == 'fcom' else None, word)
            return True
        if m in ('fnstsw', 'fstsw') and len(ops) == 1 and ops[0].type == X.X86_OP_REG and sw is not None:
            self.reg_set(st, 'ax', sw)
            return True
        return False

    def x87(self, st, ins):
        m = ins.mnemonic
        ops = ins.operands
        if self.x87_compare(st, ins):
            return
        st.fp = (None, None)                                           # any other x87 instruction may change st(0) and the status word
        for op in ops:
            if op.type == X.X86_OP_MEM:
                a = self.ea(st, op)
                if m in ('fnsave', 'fsave', 'fnstenv', 'fstenv', 'fxsave', 'fbstp', 'frstor', 'fldenv', 'fxrstor'):
                    raise Unsupported(m)
                if m.startswith(('fst', 'fist', 'fnst')):
                    self.mem_havoc(st, a, op.size)
                else:
                    self.assume_ok(st, a, op.size)
        if m in ('fnstsw', 'fstsw'):
            if ops and ops[0].type == X.X86_OP_REG:
                self.reg_set(st, 'ax', fresh(16, 'fs'))
        elif m in ('fcomi', 'fcomip', 'fucomi', 'fucomip'):
            raise Unsupported(m)

    def terminator(self, ins):
        m = ins.mnemonic
        return m == 'jmp' or m == 'ret' or m == 'retn' or m.startswith('j') or m.startswith('loop')


# ---- the function ----------------------------------------------------------------------------------------------------------------------------------

def disassemble(image, va, body):
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = va - IMAGE_BASE
    insns = list(md.disasm(image[off:off + body], va))
    return md, insns


class Analysis:
    """Blocks, edges, incoming conditions of one function."""

    def __init__(self, row, image, timeout_ms=30000):
        self.row = row
        self.image = image
        self.va, self.body = row['va'], row['body']
        self.md, self.insns = disassemble(image, self.va, self.body)
        self.by_addr = {i.address: i for i in self.insns}
        self.M = Machine(row, image)
        targets = self.branch_targets()
        self.split_ok = SPLIT and not row.get('frame') and self.va not in targets             # a `frame` row starts with ebp = the entry frame address; a jump back to the entry runs the prologue again (FL-78 round 8 review: the frame base is pushed once per run only)
        self.esc_addrs = []                                                                   # FL-75: where the function forms an address of its frame
        self.cell_users = set()
        self.used = set()                                                                     # FL-78 review: the assumptions the frame-address rules relied on (named in the proof record)
        _FX.append(set())
        kinds = []
        for i in (self.insns if self.split_ok else ()):
            if frame_escapes([i], self.insns[0]) and not seh_registration(self.insns, i, targets):
                info = library_arg_lea(self.insns, i, targets, self.by_addr, image=image, callees=self.M.callees, imports=import_slots() | set(self.M.imports))       # FL-78: a frame address that is followed to its end (library_arg_lea) is not one
                if info and info['kind'] in ('out', 'dest'):
                    self.M.out_writes.setdefault(info['call'], []).append((info['off'], info['extent']))
                if info:
                    kinds.append(info['kind'])
                    self.used.add({'source': 'library-source:%s', 'dest': 'library-destination:%s'}.get(info['kind'], '%s-rule') % (info.get('fn') or info['kind']))
                if not info:
                    self.esc_addrs.append(i.address)
        self.frame_formers = list(self.esc_addrs)                                              # FL-78 (round 9 review): where the function forms an address of its frame that the frame assumption does not follow to its end; kept when the pointer cell rule clears esc_addrs (frame_safe: a window that can run after such a `lea` has had a frame address handed out)
        if self.esc_addrs and self.split_ok:                                                  # FL-78 (round 9): frame addresses that only go into one pointer cell (cell_lea / pointer_cell)
            imps = import_slots() | set(self.M.imports)
            leas = {a: cell_lea(self.insns, self.by_addr[a], targets, self.by_addr, image=image, imports=imps) for a in self.esc_addrs if self.by_addr[a].mnemonic == 'lea'}
            if len(leas) == len(self.esc_addrs) and all(leas.values()):
                got = pointer_cell(self.insns, leas, kinds, self.by_addr, image=image, imports=imps)
                if got:
                    self.esc_addrs = []
                    self.M.cell_ops = set(got['loads']) | set(got['rmw'])
                    self.cell_users = got['users']                                        # the instructions that read a register holding a copy of the cell (an address); a store among them writes the frame at an address not known statically
                    self.used.add('pointer-cell-frame-address')
        self.M.split = self.split_ok and not self.esc_addrs
        self.used |= _FX.pop()
        for k, i in enumerate(self.insns[:-1]):
            nxt = self.insns[k + 1]
            if i.mnemonic == 'call' and nxt.mnemonic == 'add' and [nxt.reg_name(nxt.operands[0].reg)] == ['esp'] and nxt.operands[1].type == X.X86_OP_IMM:
                self.M.after_call[i.address] = nxt.operands[1].imm
        self.timeout_ms = timeout_ms
        self.verdict = {}
        self.inv = load_invariants(self.va)
        self.gen_state, self.hdr_in, self.hdr_back = {}, {}, {}      # FL-73: per generalised header with invariants: its state, its entry edges, its back edges
        self.tight_tables, self.cut, self.escapes = True, {}, []      # FL-75: tables cut at the range check (self.cut: jump -> the longer table that was cut); escapes: index-outside-the-cut conditions

    def assumptions(self):
        """FL-78 review: the assumptions of RULE_TEXT2 that this function's analysis relied on, sorted: the frame assumption, the frame-address rules used (listed library source / destination, read-only callee, string comparison, inline copy, out-parameter callee), the least fixed point over recursive callees, the callees read to be memory-pure that are called"""
        out = set(self.used)
        if self.M.split:
            out.add('frame-assumption')
        regs = {a['reg'] for atoms in self.inv.values() for at in atoms for a in (at.get('or') or [at]) if 'reg' in a}
        if regs:                                                                     # FL-78 (round 7): a register atom of a loop invariant (proved by the prover itself) holds across the calls of the loop only if callees keep it
            out.add('register-loop-invariant-checked')
            if regs & set(CALLEE_SAVED):
                out.add('callee-saved-registers-unread-and-kept-by-callees')
            if any(i.mnemonic == 'call' and i.operands[0].type == X.X86_OP_MEM for i in self.insns):
                out.add('import-reads-no-register-and-clobbers-eax-ecx-edx')
        for i in self.insns:                                                        # every direct call target of the body, listed in the row or not
            if i.mnemonic in ('fcom', 'fcomp') and i.operands and i.operands[0].type == X.X86_OP_MEM and i.operands[0].size == 8:
                out.add('x87-compare-model')
            if i.mnemonic == 'call' and i.operands[0].type == X.X86_OP_IMM and self.M.is_pure(i.operands[0].imm & 0xffffffff):
                out.add('pure-callee:0x%x' % (i.operands[0].imm & 0xffffffff))
        return sorted(out)

    def branch_targets(self):
        """addresses that some branch of the body can jump to: direct jumps and jump tables (calls leave the body)"""
        out = set()
        for i in self.insns:
            m = i.mnemonic
            if (m == 'jmp' or m.startswith('j') or m.startswith('loop')) and i.operands:
                if i.operands[0].type == X.X86_OP_IMM:
                    out.add(i.operands[0].imm & 0xffffffff)
                elif m == 'jmp':
                    tt = self.table_targets(i)
                    out.update(t for _, t in (tt or ()))
        return out

    def jump_targets(self):
        """every address that a jump of the function can land on (direct targets and, when the table is readable, the targets of computed jumps)"""
        out = set()
        for i in self.insns:
            if i.mnemonic.startswith('j') or i.mnemonic.startswith('loop'):
                if i.operands[0].type == X.X86_OP_IMM:
                    out.add(i.operands[0].imm)
                else:
                    tt = self.table_targets(i)
                    out.update(t for _, t in tt) if tt else out.update(x.address for x in self.insns)      # an unreadable computed jump may land anywhere
        return out

    def table_targets(self, ins):
        """Targets of `jmp [index*4 + table]` read from the constant table; None if the jump is not of that form."""
        op = ins.operands[0]
        if op.type != X.X86_OP_MEM or op.mem.base or not op.mem.index or op.mem.scale != 4:
            return None
        base = op.mem.disp & 0xffffffff
        out = []
        for k in range(4096):
            a = base + 4 * k
            if a + 4 > DATA_START or a < IMAGE_BASE:
                break
            t = int.from_bytes(self.image[a - IMAGE_BASE:a - IMAGE_BASE + 4], 'little')
            if not (self.va <= t < self.va + self.body) or t not in self.by_addr:
                break
            out.append((a, t))
        return out or None

    def tighten(self, ins, tt):
        """FL-75: the table runs on into the next switch's table (every cell is a valid target), which makes spurious edges and irreducible loops. Cut it at the bound of the range check just in front of the jump
        (`cmp X, K; ja/jae default`): K+1 (K for jae) cells. This is only a PROPOSAL: execute() collects, per jump, the condition that the index falls outside the kept cells and run() requires it unsat."""
        if not self.tight_tables:
            return tt
        k = self.insns.index(ins)
        for j in range(k - 1, max(k - 14, 0), -1):
            g = self.insns[j]
            c = self.insns[j - 1]
            if g.mnemonic in ('ja', 'jae', 'jnb', 'jnbe') and c.mnemonic == 'cmp' and c.operands[1].type == X.X86_OP_IMM:
                n = (c.operands[1].imm & 0xffffffff) + (1 if g.mnemonic in ('ja', 'jnbe') else 0)
                if 0 < n < len(tt):
                    self.cut[ins.address] = tt
                    return tt[:n]
                return tt
        return tt

    def build_blocks(self):
        leaders = {self.va}
        self.table = {}
        for ins in self.insns:
            m = ins.mnemonic
            end = ins.address + ins.size
            if m == 'jmp' and ins.operands[0].type == X.X86_OP_IMM:
                leaders.add(ins.operands[0].imm)
                leaders.add(end)
            elif m == 'jmp':
                tt = self.table_targets(ins)
                if tt is None:
                    raise Unsupported('indirect jump at 0x%x' % ins.address)
                tt = self.tighten(ins, tt)
                self.table[ins.address] = tt
                for cell, _ in tt:
                    self.M.const_facts(cell, 4)
                leaders.update(t for _, t in tt)
                leaders.add(end)
            elif m in ('ret', 'retn'):
                leaders.add(end)
            elif m.startswith('j') or m.startswith('loop'):
                leaders.add(ins.operands[0].imm)
                leaders.add(end)
        leaders = sorted(a for a in leaders if a in self.by_addr)
        self.blocks = {}
        order = [i.address for i in self.insns]
        starts = set(leaders)
        cur = None
        for ins in self.insns:
            if ins.address in starts:
                cur = {'start': ins.address, 'insns': []}
                self.blocks[ins.address] = cur
            if cur is None:
                continue
            cur['insns'].append(ins)
        for b in self.blocks.values():
            last = b['insns'][-1]
            m = last.mnemonic
            end = last.address + last.size
            succ = []
            if m == 'jmp' and last.operands[0].type == X.X86_OP_IMM:
                succ = [('jmp', last.operands[0].imm)]
            elif m == 'jmp':
                succ = [('tbl', t) for _, t in self.table[last.address]]
            elif m in ('ret', 'retn'):
                succ = []
            elif m.startswith('j') or m.startswith('loop'):
                succ = [('taken', last.operands[0].imm), ('fall', end)]
            else:
                succ = [('fall', end)]
            keep = [(k, t) for k, t in succ if t in self.blocks]
            if len(keep) != len(succ) and (m.startswith('j') and m != 'jmp' or m.startswith('loop') or m == 'jmp' and last.operands[0].type != X.X86_OP_IMM
                                           or any(self.va <= t < self.va + self.body for k, t in succ if t not in self.blocks)):
                raise Unsupported('a jump edge leaves the instruction set at 0x%x' % last.address)
            b['succ'] = keep           # only a jmp or a fall-through out of the body ends the path here
        return

    def graph(self):
        succ = {a: [t for _, t in b['succ']] for a, b in self.blocks.items()}
        pred = {a: [] for a in self.blocks}
        for a, ts in succ.items():
            for t in ts:
                pred[t].append(a)
        # depth first search from the entry: reverse postorder, retreating edges
        seen, post, back = set(), [], set()
        onstack = set()
        stack = [(self.va, iter(succ[self.va]))]
        seen.add(self.va)
        onstack.add(self.va)
        while stack:
            n, it = stack[-1]
            for t in it:
                if t in onstack:
                    back.add((n, t))
                elif t not in seen:
                    seen.add(t)
                    onstack.add(t)
                    stack.append((t, iter(succ[t])))
                    break
            else:
                stack.pop()
                onstack.discard(n)
                post.append(n)
        rpo = list(reversed(post))
        # dominators (iterative) to check that every retreating edge is a back edge of a natural loop
        dom = {n: set(seen) for n in seen}
        dom[self.va] = {self.va}
        changed = True
        while changed:
            changed = False
            for n in rpo:
                if n == self.va:
                    continue
                ps = [p for p in pred[n] if p in seen]
                new = set.intersection(*[dom[p] for p in ps]) | {n} if ps else {n}
                if new != dom[n]:
                    dom[n] = new
                    changed = True
        for u, h in back:
            if h not in dom[u]:
                raise Unsupported('irreducible loop at 0x%x' % h)
        self.succ, self.pred, self.rpo, self.back, self.reach = succ, pred, rpo, back, seen
        loops = {}
        for u, h in back:
            body = {h, u}
            work = [u]
            while work:
                n = work.pop()
                if n == h:                       # the predecessors of the header are not in the loop
                    continue
                for p in pred[n]:
                    if p not in body and p in seen:
                        body.add(p)
                        work.append(p)
            loops.setdefault(h, set()).update(body)
        self.loops = loops

    def temps_info(self):
        """FL-78 (round 8): L, the size of the locals, when the stack-discipline assumption can be used for this function, else None. The function starts `push ebp; mov ebp, esp; sub esp, L` and every place where it forms an address of its frame is `lea r, [ebp + d]` with no index and d >= -L (a pointer to its own locals or
        arguments; `ebp` is only changed by the prologue and `leave`, see `frame_ok`). Anything else that forms a frame address (a `lea` of esp, `mov r, esp`, an index, an address below the locals) makes it None."""
        if not self.split_ok:
            return None
        ins = self.insns
        if len(ins) < 3 or [(i.mnemonic, i.op_str) for i in ins[:2]] != [('push', 'ebp'), ('mov', 'ebp, esp')]:
            return None
        sub = ins[2]
        if sub.mnemonic != 'sub' or sub.op_str.split(',')[0].strip() != 'esp' or sub.operands[1].type != X.X86_OP_IMM or not 0 < sub.operands[1].imm < 0x10000:
            return None
        L = sub.operands[1].imm
        for a in self.frame_formers:
            i = self.by_addr[a]
            if i.mnemonic != 'lea':
                return None
            m = i.operands[1].mem
            if i.reg_name(m.base) != 'ebp' if m.base else True:
                return None
            if m.index or m.disp < -L:
                return None
        return L

    def frame_safe(self, S, region):
        """FL-75: the frame assumption holds in a window that starts at block S and executes the blocks `region` when no instruction that forms an address of the frame is in the region or can run before S
        (no path from it to S). Then no run that reaches the window has handed out a pointer into its own frame yet, so only the argument slots of a call can be reached by other pointers (as in the whole-function case)."""
        if not self.split_ok:
            return False
        if not self.frame_formers:
            return True
        esc = {a for a, b in self.blocks.items() if any(i.address in self.esc_addrs for i in b['insns'])}
        if esc & set(region):
            return False
        seen, work = {S}, [S]
        while work:
            n = work.pop()
            if n in esc:
                return False
            for p in self.pred[n]:
                if p not in seen:
                    seen.add(p)
                    work.append(p)
        cells = {a for a, b in self.blocks.items() if any(i.address in self.frame_formers for i in b['insns'])} - esc
        if cells:                                                    # FL-78 (round 9 review): the `lea` of a pointer cell may be in the window (it sets the cell and the registers loaded from it come after it) but not run before it: then the cell and the registers that copy it hold anything
            seen, work = set(), list(self.pred[S])
            while work:
                n = work.pop()
                if n in cells:
                    return False
                if n not in seen:
                    seen.add(n)
                    work.extend(p for p in self.pred[n] if p not in seen)
        return True

    def loop_effects(self, header):
        """Registers/flags/memory that some instruction of the loop may change: run each instruction on a state of unique symbols."""
        key = ('loop_effects', header)
        if key in self.__dict__.setdefault('_effects_memo', {}):
            return self._effects_memo[key]
        regs, mem, fs = set(), False, False
        for a in self.loops[header]:
            for ins in self.blocks[a]['insns']:
                st = State.start()
                before = State(dict(st.R), dict(st.F), st.mem, st.frm, st.fs, st.pc)
                cells, self.M.cell_ops = self.M.cell_ops, set()            # FL-78 (round 9): an instruction on a state of unique symbols: a pointer cell holds nothing known here
                try:
                    self.M.step(st, ins)
                except Unsupported:
                    raise
                finally:
                    self.M.cell_ops = cells
                for r in FULL:
                    if not same(st.R[r], before.R[r]):
                        regs.add(r)
                if not same(st.mem, before.mem) or not same(st.frm, before.frm):
                    mem = True
                if not same(st.fs, before.fs):
                    fs = True
        self._effects_memo[key] = (regs, mem, fs)
        return regs, mem, fs

    def loop_frame_writes(self, header):
        """FL-78 (round 9): under the frame assumption, the frame bytes that the loop of `header` may write, as [(displacement from ebp, size)], or None when that cannot be said and the frame memory at the header is wholly unknown. Only a loop whose every memory write is
        either through ebp + a constant (the locals) or through an address that is not a frame address qualifies: no call, push, pop, string instruction that writes (movs, stos, ins), `enter`, `leave`, `ret`, no esp based or ebp-with-index operand, and no store through a register that holds a copy of a pointer cell
        (`cell_users`). A store through any other address lands in `mem` under the frame assumption, which the header forgets anyway."""
        out = []
        for a in self.loops[header]:
            for ins in self.blocks[a]['insns']:
                m = ins.mnemonic
                if m.split()[0] == 'lock' or m.split()[-1] in STRING_OPS or m in ('push', 'pop', 'call', 'ret', 'retn', 'leave', 'enter', 'pusha', 'pushad', 'popa', 'popad', 'pushfd', 'popfd', 'pushf', 'popf', 'xchg', 'cmpxchg', 'xadd') \
                        or m.startswith(('fsave', 'fnsave', 'frstor', 'fxsave', 'fxrstor', 'xsave', 'xrstor')):
                    return None
                try:
                    rd, wr = ins.regs_access()
                except capstone.CsError:
                    return None
                if {'esp', 'ebp', 'sp', 'bp', 'spl', 'bpl'} & {ins.reg_name(r) for r in wr}:                  # (round 9 review: a loop that writes ebp moves every frame address)
                    return None
                if m.split()[-1] in ('bts', 'btr', 'btc', 'cmpxchg8b', 'cmpxchg16b') and any(o.type == X.X86_OP_MEM for o in ins.operands):          # (capstone reports their memory operand as read only)
                    return None
                for o in ins.operands:
                    if o.type != X.X86_OP_MEM or o.mem.segment == X.X86_REG_FS:
                        continue
                    base = ins.reg_name(o.mem.base) if o.mem.base else None
                    index = ins.reg_name(o.mem.index) if o.mem.index else None
                    if base == 'esp' or index in ('esp', 'ebp'):
                        return None
                    written = bool(o.access & capstone.CS_AC_WRITE) or m.startswith(X87_STORES)
                    if base == 'ebp':
                        if index:
                            return None
                        if written:
                            out.append((o.mem.disp, o.size))
                    elif written and ins.address in self.cell_users:
                        return None
        return out

    # ---- loops: exact unrolling when the trip count is provably small, else a generalised header ---------------------------------------------------

    def instance_graph(self, plan):
        """Nodes are (block address, context); a loop with plan N is copied N times (back edges of copy k go to copy k+1, those of the last copy to a sink
        node ('sink', header)); a loop with plan 'gen' keeps its back edges and gets a generalised header state. Innermost loops first."""
        succ = {(a, ()): [(k, (t, ())) for k, t in [(k, t) for k, t in b['succ']]] for a, b in self.blocks.items()}
        for h in sorted(self.loops, key=lambda h: (len(self.loops[h]), h)):
            n = plan[h]
            if n == 'gen':
                continue
            body_addrs = self.loops[h]
            body = {u for u in succ if u[0] in body_addrs}
            headers = {u for u in body if u[0] == h}
            new = {u: list(vs) for u, vs in succ.items() if u not in body}
            for k in range(n):
                for u in body:
                    cu = (u[0], u[1] + ((h, k),))
                    out = []
                    for kind, v in succ[u]:
                        if v in body:
                            if v in headers and True:                     # an edge into the header from inside the loop is a back edge
                                out.append((kind, (v[0], v[1] + ((h, k + 1),)) if k + 1 < n else ('sink', h)))
                            else:
                                out.append((kind, (v[0], v[1] + ((h, k),))))
                        else:
                            out.append((kind, v))
                    new[cu] = out
            for u, vs in list(new.items()):
                if u in body:
                    continue
                new[u] = [(kind, (v[0], v[1] + ((h, 0),)) if v in headers else v) for kind, v in vs]
            succ = new
        return succ

    def execute(self, plan):
        succ = self.instance_graph(plan)
        entry = (self.va, ())
        for h in self.loops:
            if plan[h] != 'gen' and self.va in self.loops[h] and self.va == h:
                entry = (self.va, ((h, 0),))
        if len(succ) > MAX_NODES:
            raise Unsupported('unrolled graph too large')
        # depth first search: reverse postorder; the only retreating edges left are the back edges of generalised loops
        seen, post, back, onstack = set(), [], set(), set()
        stack = [(entry, iter([v for _, v in succ[entry]]))]
        seen.add(entry)
        onstack.add(entry)
        while stack:
            n, it = stack[-1]
            for t in it:
                if t[0] == 'sink':
                    continue
                if t in onstack:
                    back.add((n, t))
                elif t not in seen:
                    seen.add(t)
                    onstack.add(t)
                    stack.append((t, iter([v for _, v in succ[t]])))
                    break
            else:
                stack.pop()
                onstack.discard(n)
                post.append(n)
        rpo = list(reversed(post))
        self.nodes, self.nsucc, self.nreach = rpo, succ, seen
        self.ic, self.edge, self.sink_cond = {}, {}, {}
        self.gen_state, self.hdr_in, self.hdr_back = {}, {}, {}
        self.preds = {}
        self.M.inv_facts = [kf for kf in self.M.inv_facts if kf[0][0] != 'exec']
        incoming = {n: [] for n in succ}
        incoming[entry].append((z3.BoolVal(True), State.start()))
        for node in rpo:
            a = node[0]
            items = incoming[node]
            if not items:
                self.ic[node] = z3.BoolVal(False)
                continue
            st = merge(items)
            self.ic[node] = z3.Or(*[c for c, _ in items]) if len(items) > 1 else items[0][0]
            if a in self.loops and plan[a] == 'gen' and a == node[0]:
                regs, mem, fs = self.loop_effects(a)
                for r in regs:
                    st.R[r] = fresh(32, 'sp' if r in ('esp', 'ebp') else 'lp')      # a stack register stays a frame term
                for f in FLAGS:
                    st.F[f] = fresh_bool()
                st.fp = (None, None)
                if mem:
                    st.mem = fresh_array()
                    st.frm = fresh_array('fr')
                if fs:
                    st.fs = fresh_array('fa')
                if a in self.inv:                                                          # FL-73: assumed here, proved in verify_invariants
                    self.gen_state[node], self.hdr_in[node] = st.copy(), list(items)
                    self.M.inv_facts.append((('exec', node), z3.Implies(self.ic[node], inv_formula(self.M, st, self.inv[a]))))        # only runs that arrive at the header satisfy it; used by the queries, and by the proof of other headers' invariants only for the headers before them
            st.pc = z3.BoolVal(True)
            ins = self.blocks[a]['insns']
            br = None
            for i in ins:
                res = self.M.step(st, i)
                if res:
                    br = res[1]
            last = ins[-1]
            here = z3.And(self.ic[node], st.pc)
            conds = {}
            tgt_addr = {k: t for k, t in self.blocks[a]['succ']}
            if last.address in self.cut:                     # FL-75: the run may not index past the cells that the cut table keeps
                self.escapes.append(self.table_escape(st, here, last))
            for kind, t in succ[node]:
                if kind == 'taken':
                    c = z3.And(here, br)
                elif kind == 'fall' and br is not None:
                    c = z3.And(here, z3.Not(br))
                elif kind == 'tbl':
                    op = last.operands[0]
                    s2 = st.copy()
                    v = self.M.mem_read(s2, op, 4)
                    c = z3.And(here, v == t[0])
                else:
                    c = here
                conds[(kind, t)] = z3.Or(conds[(kind, t)], c) if (kind, t) in conds else c
            for (kind, t), c in conds.items():
                self.edge[(node, kind, t)] = c
                if t[0] == 'sink':
                    self.sink_cond.setdefault(t[1], []).append(c)
                    continue
                if (node, t) in back:
                    self.hdr_back.setdefault(t, []).append((c, st, node))
                    continue
                incoming[t].append((c, st))
                self.preds.setdefault(t, set()).add(node)

    def table_escape(self, st, here, last):
        """the condition under which the (cut) table jump `last` reads a cell outside the kept ones"""
        s2 = st.copy()
        addr = self.M.ea(s2, last.operands[0])
        return z3.And(here, *[addr != c for c, _ in self.table[last.address]])

    def verify_escapes(self):
        for k, esc in enumerate(self.escapes):
            r, _ = self.check(esc)
            if r != 'unsat':
                raise Unsupported('table escape (%s)' % r)

    def verify_invariants(self):
        """FL-73: every invariant that execute() assumed at a generalised header is inductive: it holds on each entry edge (initiation) and, assumed at the header, on each back edge (consecution).
        The assumed facts must also be satisfiable (a contradictory invariant would make every query unsat). Raises Unsupported otherwise."""
        for node, gs in self.gen_state.items():
            atoms = self.inv[node[0]]
            assumed = inv_formula(self.M, gs, atoms)
            before = {('exec', n) for n in reach_back(self.preds, node) if n in self.gen_state}      # FL-78 review: the headers the run passes before this one; the header's own fact is the thing to prove (a loop without memory effects shares its entry state)
            r, _ = self.check(assumed, only=before)
            if r != 'sat':
                raise Unsupported('invariant at 0x%x is not satisfiable (%s)' % (node[0], r))
            chk = lambda f: self.check(f, only=before)[0]
            for c, st_in in self.hdr_in[node]:
                bad = inv_failures(chk, self.M, None, c, st_in, atoms)
                if bad:
                    raise Unsupported('invariant at 0x%x does not hold on an entry edge (atoms %s)' % (node[0], bad))
            for c, st_b, src in self.hdr_back.get(node, []):
                upto = {('exec', n) for n in reach_back(self.preds, src) | {src} if n in self.gen_state}       # the headers passed on the way round the loop, this one included (its assumption is the induction hypothesis)
                bad = inv_failures(lambda f: self.check(f, only=upto)[0], self.M, assumed, c, st_b, atoms)
                if bad:
                    raise Unsupported('invariant at 0x%x is not preserved by a back edge (atoms %s)' % (node[0], bad))

    def run(self):
        self.build_blocks()
        self.graph()
        hints = load_plan_hints(self.va)
        plan = {h: hints.get(h, UNROLL[0]) for h in self.loops}
        self.plan = plan
        for _ in range(len(UNROLL) + 1):
            self.escapes = []
            self.execute(plan)
            bad = [h for h in self.loops if plan[h] != 'gen' and not self.sink_unsat(h)]
            if not bad:
                self.verify_invariants()
                self.verify_escapes()
                return
            for h in bad:
                nxt = [u for u in UNROLL if u > plan[h]]
                plan[h] = nxt[0] if nxt else 'gen'
        raise Unsupported('loop plan did not settle')

    def sink_unsat(self, h):
        """The last copy of the loop must not be able to run another iteration (then the unrolled copies are the whole loop)."""
        conds = self.sink_cond.get(h, [])
        if not conds:
            return True
        r, _ = self.check(z3.Or(*conds), min(self.timeout_ms, SINK_MS))
        return r == 'unsat'

    # ---- queries ---------------------------------------------------------------------------------------------------------------------------

    def check(self, formula, timeout_ms=None, only=None):
        """`only`: None conjoins every assumed loop invariant (the queries that use them); a set of keys conjoins just those (the checks that prove an invariant: initiation of a header may rest only on the invariants of the headers the run passed before it,
        and never on its own, which is the thing being proved; FL-78 review)"""
        s = z3.Solver()
        s.set('timeout', timeout_ms or self.timeout_ms)
        s.add(*self.M.facts)
        s.add(*[f for k, f in self.M.inv_facts if only is None or k in only])
        s.add(formula)
        r = s.check()
        return str(r), hashlib.sha256(s.to_smt2().encode()).hexdigest()

    def direction(self, jcc, name):
        """('unsat'|'sat'|'unknown', hash of the query) for the taken / fall-through edge of the conditional jump at `jcc`."""
        kind = 'taken' if name == 'taken' else 'fall'
        block = [a for a, b in self.blocks.items() if b['insns'][-1].address == jcc]
        if not block:
            raise KeyError(jcc)
        conds = [c for (n, k, t), c in self.edge.items() if n[0] == block[0] and k == kind]
        if not conds:
            return 'unsat', 'unreachable block'
        return self.check(z3.Or(*conds) if len(conds) > 1 else conds[0])

    def instruction(self, addr):
        block = [a for a, b in self.blocks.items() if any(i.address == addr for i in b['insns'])]
        if not block:
            return 'unsat', 'not in any block'
        conds = [c for n, c in self.ic.items() if n[0] == block[0]]
        if not conds:
            return 'unsat', 'unreachable block'
        return self.check(z3.Or(*conds) if len(conds) > 1 else conds[0])


def row_of(key):
    import fl66_tested as T
    pool = T.pool_of(key)
    return T.row_info(pool, key)


def load_image():
    import original_differential as od
    return od.load_image().image


def prove_row(key, targets, timeout_ms=30000, image=None, fail_fast=False):
    """targets: {'missing': [instruction addresses], 'untaken': [[jcc address, 'taken'|'fall-through']]}.
    Returns {'status': 'proved'|'open'|'unsupported', 'reason': ..., 'instructions': {addr: [verdict, hash]}, 'directions': {'addr:name': [verdict, hash]}}."""
    image = image or load_image()
    row = row_of(key)
    out = {'checker': CHECKER_VERSION, 'instructions': {}, 'directions': {}}
    try:
        out['assumptions_used'] = Analysis(row, image, 1000).assumptions()
    except Unsupported:
        out['assumptions_used'] = []
    closed = []                             # FL-78: directions proved by the closed-loop rule: noted in out['plan'] (the proof record keeps it in the ledger)
    hexa = lambda a: int(a, 16) if isinstance(a, str) else a
    todo = {'missing': [hexa(a) for a in targets.get('missing', [])], 'untaken': [[hexa(a), n] for a, n in targets.get('untaken', [])]}
    try:                                    # FL-71: targets that a dominator window in front of them refutes (scripts/fl71_window.py); the whole-function analysis is for the rest
        import fl71_window as Wn
        an0, dom = Wn.prepare(key, image)
        win = Wn.prove_row_windows(an0, dom, todo)
        if getattr(an0, 'stack_discipline_used', False):
            out['assumptions_used'] = sorted(set(out['assumptions_used']) | {'stack-discipline-assumption'})        # FL-78 (round 8): a window ran with only the call temporaries kept apart
        out['instructions'].update(win['instructions'])
        out['directions'].update(win['directions'])
        todo = {'missing': [a for a in todo['missing'] if hex(a) not in win['instructions']],
                'untaken': [[a, n] for a, n in todo['untaken'] if '%s:%s' % (hex(a), n) not in win['directions']]}
        if (todo['missing'] or todo['untaken']) and any(i.mnemonic in ('div', 'idiv') for i in an0.insns):      # FL-75: what every run reaching it faults after (a division by a divisor just shown to be zero)
            memo = {}
            for a in list(todo['missing']):
                S = Wn.block_of(an0, a)
                v = memo.get(('i', S)) or memo.setdefault(('i', S), Wn.prove_faults(an0, dom, ('ins', a)))
                if v[0] == 'unsat':
                    out['instructions'][hex(a)] = [v[0], v[1]]
                    todo['missing'].remove(a)
            for a, n in list(todo['untaken']):
                kind = 'taken' if n == 'taken' else 'fall'
                v = memo.get(('d', a, kind)) or memo.setdefault(('d', a, kind), Wn.prove_faults(an0, dom, ('dir', a, kind)))
                if v[0] == 'unsat':
                    out['directions']['%s:%s' % (hex(a), n)] = [v[0], v[1]]
                    todo['untaken'].remove([a, n])
        for a, n in list(todo['untaken']):          # FL-78: a direction after which every run goes round a loop for ever (the scenarios are runs that return)
            v = Wn.prove_closed_loop(an0, dom, ('dir', a, 'taken' if n == 'taken' else 'fall'))
            if v[0] != 'unsat':
                v = Wn.prove_trap_loop(an0, dom, ('dir', a, 'taken' if n == 'taken' else 'fall'))          # FL-78 (round 10): a loop that the run enters there and never leaves
            if v[0] == 'unsat':
                out['directions']['%s:%s' % (hex(a), n)] = [v[0], v[1]]
                todo['untaken'].remove([a, n])
                closed.append('%s:%s' % (hex(a), n))
        if getattr(an0, 'stack_discipline_used', False):                 # the same for a proof by the fault windows
            out['assumptions_used'] = sorted(set(out['assumptions_used']) | {'stack-discipline-assumption'})
        if getattr(an0, 'trap_loop_frame', False):
            out['assumptions_used'] = sorted(set(out['assumptions_used']) | {'frame-assumption'})                # (a trap loop proof that rests on the frame assumption)
        if not todo['missing'] and not todo['untaken']:
            if closed:
                out['assumptions_used'] = sorted(set(out['assumptions_used']) | {'closed-loop-wait-semantics'})
            out['status'] = 'proved'
            out['plan'] = {'closed-loop:' + k: 'closed-loop-proved: no terminating run takes it, wait semantics assumed, the translation is not compared on it' for k in closed}      # no whole-function analysis was needed, so no loop plan
            return out
    except (Unsupported, KeyError, IndexError):
        pass
    except Exception as ex:                 # the window module imports this file under its own name, so its Unsupported is another class when this file runs as __main__
        if type(ex).__name__ != 'Unsupported':
            raise
    try:
        an = Analysis(row, image, timeout_ms)
        try:
            an.run()
        except Unsupported:
            if not an.cut:
                raise
            an = Analysis(row, image, timeout_ms)       # FL-75: the cut of a jump table could not be justified (or did not help): the whole table, as before
            an.tight_tables = False
            an.run()
        out['plan'] = {hex(h): v for h, v in sorted(an.plan.items())}
        if closed:
            out['assumptions_used'] = sorted(set(out['assumptions_used']) | {'closed-loop-wait-semantics'})
        out['plan'].update({'closed-loop:' + k: 'closed-loop-proved: no terminating run takes it, wait semantics assumed, the translation is not compared on it' for k in closed})
    except Unsupported as ex:
        out.update(status='unsupported', reason=str(ex))
        return out
    open_ = 0
    for a in todo['missing']:
        v = an.instruction(a)
        out['instructions'][hex(a)] = list(v)
        open_ += v[0] != 'unsat'
        if fail_fast and open_:
            break
    for a, name in todo['untaken']:
        v = an.direction(a, name)
        out['directions']['%s:%s' % (hex(a), name)] = list(v)
        open_ += v[0] != 'unsat'
        if fail_fast and open_:
            break
    out['status'] = 'proved' if not open_ else 'open'
    return out


def all_targets(row):
    import original_differential as od
    import fl28b_fixtures as F
    insns = sorted(od.instruction_addresses(row['va'], row['body']))
    dirs = []
    for address, _, _, _ in F.conditional_edges(row['va'], row['body']):
        dirs += [[address, 'taken'], [address, 'fall-through']]
    return {'missing': insns, 'untaken': dirs}


def validate_one(key):
    """Oracle: a row whose scenarios cover everything must get NO 'unsat' for any instruction or direction."""
    t0 = time.time()
    try:
        out = prove_row(key, all_targets(row_of(key)), timeout_ms=5000)
    except Exception as ex:
        return key, 'error', '%s: %s' % (type(ex).__name__, str(ex)[:120]), 0, 0, 0, time.time() - t0
    vs = [v[0] for v in list(out['instructions'].values()) + list(out['directions'].values())]
    return key, out['status'], out.get('reason', ''), vs.count('unsat'), vs.count('sat'), vs.count('unknown'), time.time() - t0


def validate(args):
    import multiprocessing as mp
    import fl66_tested as T
    rows = json.loads(T.MANIFEST.read_text())['rows']
    keys = sorted(rows, key=lambda k: (rows[k]['body'], int(k, 16)))
    i, n = map(int, args.shard.split('/'))
    keys = keys[i::n][args.skip:][:args.limit or None]
    bad = 0
    with mp.Pool(args.jobs, maxtasksperchild=20) as pool:
        for key, status, reason, un, sat, unk, dt in pool.imap_unordered(validate_one, keys):
            flag = 'UNSOUND' if un else ''
            bad += bool(un)
            print(key, status, reason, 'unsat %d sat %d unknown %d' % (un, sat, unk), '%.1fs' % dt, flag, flush=True)
    print('validated %d rows, %d with an unsat verdict on covered items' % (len(keys), bad))
    return 1 if bad else 0


def sweep_one(arg):
    key, timeout_ms = arg
    t0 = time.time()
    res = json.loads((PROJECT / 'tasks/fl66/rows' / (key + '.json')).read_text())
    try:
        out = prove_row(key, {'missing': res.get('missing', []), 'untaken': res.get('untaken', [])}, timeout_ms, fail_fast=True)
    except Exception as ex:
        out = {'status': 'error', 'reason': '%s: %s' % (type(ex).__name__, str(ex)[:200]), 'instructions': {}, 'directions': {}}
    out['truncated'] = len(res.get('untaken', [])) >= 20 or len(res.get('missing', [])) >= 40
    return key, out, time.time() - t0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='*')
    ap.add_argument('--timeout-ms', type=int, default=30000)
    ap.add_argument('--validate', action='store_true', help='run the oracle over the tested-equivalent rows of the committed manifest')
    ap.add_argument('--shard', default='0/1')
    ap.add_argument('--jobs', type=int, default=2)
    ap.add_argument('--limit', type=int, default=0)
    ap.add_argument('--skip', type=int, default=0)
    ap.add_argument('--sweep', action='store_true', help='prove the missing items of every partial row in tasks/fl66/rows (results in tasks/fl67/proofs, not committed)')
    a = ap.parse_args()
    if a.validate:
        sys.exit(validate(a))
    if a.sweep:
        import multiprocessing as mp
        keys = a.rows or sorted(p.stem for p in (PROJECT / 'tasks/fl66/rows').glob('*.json'))
        keys = [k for k in keys if json.loads((PROJECT / 'tasks/fl66/rows' / (k + '.json')).read_text()).get('status') == 'partial']
        i, n = map(int, a.shard.split('/'))
        out = PROJECT / 'tasks/fl67/proofs'
        out.mkdir(parents=True, exist_ok=True)
        with mp.Pool(a.jobs, maxtasksperchild=10) as pool:
            for key, res, dt in pool.imap_unordered(sweep_one, [(k, a.timeout_ms) for k in keys[i::n]]):
                (out / (key + '.json')).write_text(json.dumps(res, sort_keys=True) + '\n')
                vs = [v[0] for v in list(res['instructions'].values()) + list(res['directions'].values())]
                print(key, res['status'], res.get('reason', ''), 'unsat %d sat %d unknown %d' % (vs.count('unsat'), vs.count('sat'), vs.count('unknown')), '%.1fs' % dt, flush=True)
        return
    for key in a.rows:
        res = json.loads((PROJECT / 'tasks/fl66/rows' / (key + '.json')).read_text())
        t0 = time.time()
        out = prove_row(key, {'missing': res.get('missing', []), 'untaken': res.get('untaken', [])}, a.timeout_ms)
        verdicts = [v[0] for v in list(out['instructions'].values()) + list(out['directions'].values())]
        print(key, out['status'], out.get('reason', ''), 'unsat %d sat %d unknown %d' % (verdicts.count('unsat'), verdicts.count('sat'), verdicts.count('unknown')), '%.1fs' % (time.time() - t0), flush=True)


if __name__ == '__main__':
    main()
