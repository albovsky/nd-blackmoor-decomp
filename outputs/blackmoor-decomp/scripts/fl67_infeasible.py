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
  * bytes of the image below .data are constants (`DATA_START`); the direction flag is clear at entry and after calls (Win32 ABI).

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
MAX_NODES = 6000
SINK_MS = 3000                 # the check that a loop cannot run past its unrolled copies; unknown counts as can
REP_EXACT = 64
FAULT_LIMIT = 0xfff00000      # an access at or above it faults in the world (tests/fl41_world.py)
DATA_START = 0x537000         # first writable page of .data; the image below it is constant
IMAGE_BASE = 0x400000
FLAGS = ('cf', 'zf', 'sf', 'of', 'pf', 'af')
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
    __slots__ = ('R', 'F', 'mem', 'frm', 'fs', 'pc')

    def __init__(self, R, F, mem, frm, fs, pc):
        self.R, self.F, self.mem, self.frm, self.fs, self.pc = R, F, mem, frm, fs, pc

    def copy(self):
        return State(dict(self.R), dict(self.F), self.mem, self.frm, self.fs, self.pc)

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
            found = n == 's_esp' or (n.startswith('sp') and n[2:].isdigit())
        elif x.decl().kind() not in (z3.Z3_OP_SELECT, z3.Z3_OP_STORE):          # a value read from memory is not a frame address (nothing ever formed one)
            todo.extend(x.children())
    if len(_frame_cache) > 200000:
        _frame_cache.clear()
    _frame_cache[key] = (e, found)
    return found


def frame_escapes(insns):
    """True if some instruction can hand out an address of the stack frame: then the frame assumption is not used for the function.
    Allowed uses of ebp/esp as registers: push ebp / mov ebp, esp / mov esp, ebp / pop ebp / leave / add or sub esp, immediate / ret / call / push or pop of other registers."""
    FR = {'ebp', 'esp'}
    for i in insns:
        m = i.mnemonic
        names = [i.reg_name(o.reg) for o in i.operands if o.type == X.X86_OP_REG]
        if m == 'lea':
            mem = i.operands[1].mem
            if i.reg_name(mem.base) in FR if mem.base else False:
                return True
            if i.reg_name(mem.index) in FR if mem.index else False:
                return True
            continue
        if not any(n in FR for n in names):
            continue
        ops = i.operands
        if m in ('push', 'pop') and names == [names[0]] and names[0] == 'ebp':
            continue
        if m == 'mov' and len(ops) == 2 and [ops[0].type, ops[1].type] == [X.X86_OP_REG, X.X86_OP_REG] and names in (['ebp', 'esp'], ['esp', 'ebp']):
            continue
        if m in ('add', 'sub') and names == ['esp'] and ops[1].type == X.X86_OP_IMM:
            continue
        if m in ('ret', 'leave', 'retn'):
            continue
        return True
    return False


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
        self.split = False      # the frame assumption holds for this function (set by Analysis)
        self.after_call = {}    # call address -> bytes the next instruction `add esp, k` removes
        self.facts = []         # facts about the START memory (constant bytes of the image), valid in every query
        self.fact_keys = set()
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

    def space(self, st, a, op=None):
        """Which memory an address belongs to. With the frame assumption (see the module text) an address that is built from the entry esp (every ebp/esp-relative
        access) is in the function's own frame, every other address is not."""
        if op is not None and op.mem.segment == X.X86_REG_FS:
            return 'fs'
        return 'frm' if self.split and has_frame_term(a) else 'mem'

    def mem_read(self, st, op, n):
        a = self.ea(st, op)
        self.assume_ok(st, a, n)
        sp = self.space(st, a, op)
        if sp == 'mem':
            c = a.as_long() if z3.is_bv_value(a) else None
            if c is not None and IMAGE_BASE <= c and c + n <= DATA_START:
                self.const_facts(c, n)
        return self.load(getattr(st, sp), a, n)

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
        sp = self.space(st, a, op)
        setattr(st, sp, self.store(getattr(st, sp), a, val, n))

    def mem_havoc(self, st, a, n):
        """A write of n unknown bytes at a."""
        self.assume_ok(st, a, n)
        sp = self.space(st, a)
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
        space = self.space(st, sp)
        setattr(st, space, self.store(getattr(st, space), sp, val, 4))

    @staticmethod
    def store(arr, a, val, n):
        for k in range(n):
            arr = z3.Store(arr, a + k, z3.Extract(8 * k + 7, 8 * k, val) if n > 1 else val)
        return arr

    def pop(self, st):
        sp = st.R['esp']
        self.assume_ok(st, sp, 4)
        v = self.load(getattr(st, self.space(st, sp)), sp, 4)
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
        sp = st.R['esp']
        for r in ('eax', 'ecx', 'edx'):
            st.R[r] = fresh(32, 'c')
        st.mem = fresh_array()
        st.fs = fresh_array('fa')
        if self.split:               # the callee may overwrite the argument slots that were pushed for it, nothing else of the frame
            span = (pops or 0) + self.after_call.get(ins.address, 0) if pops is not None else 64
            arr = st.frm
            for k in range(max(span, 0)):
                arr = z3.Store(arr, sp + k, fresh(8, 'x'))
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
        if kind == 'stos':
            v = z3.Extract(8 * size - 1, 0, st.R['eax'])
            self.assume_ok(st, edi, size)
            st.mem = self.store(st.mem, edi, v, size)
            st.R['edi'] = edi + size
        elif kind == 'movs':
            self.assume_ok(st, esi, size)
            self.assume_ok(st, edi, size)
            v = self.load(st.mem, esi, size)
            st.mem = self.store(st.mem, edi, v, size)
            st.R['esi'], st.R['edi'] = esi + size, edi + size
        else:
            raise Unsupported(base)

    def x87(self, st, ins):
        m = ins.mnemonic
        ops = ins.operands
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
        self.M.split = SPLIT and not row.get('frame') and not frame_escapes(self.insns)      # a `frame` row starts with ebp = the entry frame address
        for k, i in enumerate(self.insns[:-1]):
            nxt = self.insns[k + 1]
            if i.mnemonic == 'call' and nxt.mnemonic == 'add' and [nxt.reg_name(nxt.operands[0].reg)] == ['esp'] and nxt.operands[1].type == X.X86_OP_IMM:
                self.M.after_call[i.address] = nxt.operands[1].imm
        self.timeout_ms = timeout_ms
        self.verdict = {}

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

    def loop_effects(self, header):
        """Registers/flags/memory that some instruction of the loop may change: run each instruction on a state of unique symbols."""
        regs, mem, fs = set(), False, False
        for a in self.loops[header]:
            for ins in self.blocks[a]['insns']:
                st = State.start()
                before = State(dict(st.R), dict(st.F), st.mem, st.frm, st.fs, st.pc)
                try:
                    self.M.step(st, ins)
                except Unsupported:
                    raise
                for r in FULL:
                    if not same(st.R[r], before.R[r]):
                        regs.add(r)
                if not same(st.mem, before.mem) or not same(st.frm, before.frm):
                    mem = True
                if not same(st.fs, before.fs):
                    fs = True
        return regs, mem, fs

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
                if mem:
                    st.mem = fresh_array()
                    st.frm = fresh_array('fr')
                if fs:
                    st.fs = fresh_array('fa')
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
                    continue
                incoming[t].append((c, st))

    def run(self):
        self.build_blocks()
        self.graph()
        plan = {h: UNROLL[0] for h in self.loops}
        self.plan = plan
        for _ in range(len(UNROLL) + 1):
            self.execute(plan)
            bad = [h for h in self.loops if plan[h] != 'gen' and not self.sink_unsat(h)]
            if not bad:
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

    def check(self, formula, timeout_ms=None):
        s = z3.Solver()
        s.set('timeout', timeout_ms or self.timeout_ms)
        s.add(*self.M.facts)
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
    hexa = lambda a: int(a, 16) if isinstance(a, str) else a
    todo = {'missing': [hexa(a) for a in targets.get('missing', [])], 'untaken': [[hexa(a), n] for a, n in targets.get('untaken', [])]}
    try:                                    # FL-71: targets that a dominator window in front of them refutes (scripts/fl71_window.py); the whole-function analysis is for the rest
        import fl71_window as Wn
        an0, dom = Wn.prepare(key, image)
        win = Wn.prove_row_windows(an0, dom, todo)
        out['instructions'].update(win['instructions'])
        out['directions'].update(win['directions'])
        todo = {'missing': [a for a in todo['missing'] if hex(a) not in win['instructions']],
                'untaken': [[a, n] for a, n in todo['untaken'] if '%s:%s' % (hex(a), n) not in win['directions']]}
        if not todo['missing'] and not todo['untaken']:
            out['status'] = 'proved'
            out['plan'] = {}                # no whole-function analysis was needed, so no loop plan
            return out
    except (Unsupported, KeyError, IndexError):
        pass
    except Exception as ex:                 # the window module imports this file under its own name, so its Unsupported is another class when this file runs as __main__
        if type(ex).__name__ != 'Unsupported':
            raise
    try:
        an = Analysis(row, image, timeout_ms)
        an.run()
        out['plan'] = {hex(h): v for h, v in sorted(an.plan.items())}
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
