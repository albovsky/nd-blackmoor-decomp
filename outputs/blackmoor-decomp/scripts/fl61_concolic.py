#!/usr/bin/env python3
"""FL-61: concolic coverage generator for the translated lower rows (tests/fl40_world.py).

A scenario is (seed, overrides) as in tests/fl40_corpus.json. The tracer runs the ORIGINAL bytes of a row under Unicorn (tests/fl40_world.run_original with the `watch` hook) and, instruction by
instruction, keeps a shadow of every register, flag and memory byte that depends on an input of the scenario. An input is a start register (eax ecx edx), a byte of memory that the function reads
before it (or a callee stub) wrote it and that a scenario override can set (stack arguments, .data globals, object pages, the TIB), never code, constants or what a stub wrote. Each conditional
jump on a symbolic flag becomes a path condition, each address that depends on an input is pinned (path condition `address == value`), a table of constants read at a symbolic index is an `If`
chain over its neighbours, an indirect jump through such a table is a switch. Unicorn stays the truth: it executes every instruction; the shadow only decides which inputs to change.

The search is a generational one: for a path condition whose other direction (or a switch target never run) is not covered yet, z3 solves `prefix and not condition`, the model becomes extra
overrides on top of the parent scenario, and the child runs on the original bytes. Every child that adds coverage is checked against the translation (original == translation, as fl56_cover.py) and
kept. Nothing is trusted from the shadow: a wrong shadow only costs a child that does not reach its goal. `--selfcheck` re-solves the path of each run under the concrete inputs and names the first
instruction whose shadow disagrees with Unicorn.

  fl61_concolic.py ROW [ROW ...] [--budget-s N] [--max-runs N] [--out FILE] [--fresh-seeds N] [--selfcheck]        (run from outputs/blackmoor-decomp)

--out FILE (JSON) maps each row to the scenarios that give the coverage ([[seed, [[address, size, value], ...]], ...]); it feeds `fl56_add_rows.py ROW --scen FILE`.
"""
from __future__ import annotations

import argparse
import collections
import heapq
import json
from pathlib import Path
import sys
import tempfile
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import capstone
from capstone import x86_const as CX
import z3

import fl28b_fixtures as F
import fl40_world as W
import fl40_generate as G
import lift_function as L

MASK = {1: 0xff, 2: 0xffff, 4: 0xffffffff, 8: 0xffffffffffffffff}
FULL = ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')
REGS = {}
for _i, _n in enumerate(FULL):
    REGS[_n] = (_n, 4, 0)
    REGS[_n[1:]] = (_n, 2, 0)
for _b, _n in zip('acdb', FULL[:4]):
    REGS[_b + 'l'] = (_n, 1, 0)
    REGS[_b + 'h'] = (_n, 1, 8)
SYMBOLIC_START = ('eax', 'ecx', 'edx')            # start registers that become inputs (the others hold the sentinels of the world)
FLAG_BIT = {'CF': 0, 'PF': 2, 'AF': 4, 'ZF': 6, 'SF': 7, 'OF': 11}
CONST_WINDOW = 160                                # entries on each side of a constant-table read at a symbolic index
JCC = {'je': 'ZF', 'jne': '~ZF', 'jb': 'CF', 'jae': '~CF', 'jbe': 'CF|ZF', 'ja': '~CF&~ZF', 'js': 'SF', 'jns': '~SF', 'jo': 'OF', 'jno': '~OF',
       'jl': 'SF^OF', 'jge': 'SF==OF', 'jle': 'ZF|SF^OF', 'jg': '~ZF&SF==OF', 'jp': 'PF', 'jnp': '~PF'}
JCC['jz'], JCC['jnz'], JCC['jc'], JCC['jnc'], JCC['jnae'], JCC['jnb'], JCC['jna'], JCC['jnbe'] = JCC['je'], JCC['jne'], JCC['jb'], JCC['jae'], JCC['jb'], JCC['jae'], JCC['jbe'], JCC['ja']
JCC['jnge'], JCC['jnl'], JCC['jng'], JCC['jnle'] = JCC['jl'], JCC['jge'], JCC['jle'], JCC['jg']
SETCC = {'set' + k[1:]: v for k, v in JCC.items()}
CMOV = {'cmov' + k[1:]: v for k, v in JCC.items()}


def sym(x):
    return not isinstance(x, int)


def E(x, s):
    return z3.BitVecVal(x & MASK[s], 8 * s) if isinstance(x, int) else x


def trunc(x, s):
    return x & MASK[s] if isinstance(x, int) else z3.Extract(8 * s - 1, 0, x)


def zext(x, s, t):
    return x & MASK[s] if isinstance(x, int) else z3.ZeroExt(8 * (t - s), x)


def sext(x, s, t):
    if isinstance(x, int):
        x &= MASK[s]
        if x >> (8 * s - 1):
            x |= MASK[t] ^ MASK[s]
        return x
    return z3.SignExt(8 * (t - s), x)


def msb(x, s):
    return z3.Extract(8 * s - 1, 8 * s - 1, x) == 1


def binop(fn, a, b, s):
    if isinstance(a, int) and isinstance(b, int):
        return fn(a, b) & MASK[s]
    return {'add': lambda x, y: x + y, 'sub': lambda x, y: x - y, 'and': lambda x, y: x & y, 'or': lambda x, y: x | y, 'xor': lambda x, y: x ^ y,
            'mul': lambda x, y: x * y, 'shl': lambda x, y: x << y, 'lshr': z3.LShR, 'ashr': lambda x, y: x >> y}[fn.__name__](E(a, s), E(b, s))


def op_add(a, b): return a + b
def op_sub(a, b): return a - b
def op_and(a, b): return a & b
def op_or(a, b): return a | b
def op_xor(a, b): return a ^ b
def op_mul(a, b): return a * b
def op_shl(a, b): return a << b
def op_lshr(a, b): return a >> b


op_add.__name__, op_sub.__name__, op_and.__name__, op_or.__name__, op_xor.__name__, op_mul.__name__, op_shl.__name__, op_lshr.__name__ = 'add', 'sub', 'and', 'or', 'xor', 'mul', 'shl', 'lshr'


def op_ashr_int(s):
    def f(a, b):
        a = a & MASK[s]
        if a >> (8 * s - 1):
            a -= 1 << (8 * s)
        return a >> b
    f.__name__ = 'ashr'
    return f


class Stats:
    unsupported = collections.Counter()
    mismatches = collections.Counter()


class Run:
    """The shadow of one run of a row."""

    def __init__(self, row, md, code_of):
        self.row = row
        self.md = md
        self.code_of = code_of
        self.R = {}                  # full register -> z3 expr (only the symbolic ones)
        self.flags = {}              # flag name -> z3 Bool (only the symbolic ones)
        self.mem = {}                # byte address -> z3 8-bit expr (only symbolic bytes)
        self.written = set()         # byte addresses written by the function or a stub (not inputs any more)
        self.inputs = {}             # name -> (var, concrete value, kind, address or register)
        self.path = []               # [(kind, address, cond, taken-info)] in order; kinds: br, ptr, sw
        self.pending = None
        self.cmps = []               # [(path length when it ran, address, a, b, size)] of every cmp/sub/sbb with a symbolic operand: the goals of compare_children
        self.ncalls = 0
        self.steps = 0
        self.tainted = False
        self.dead = False
        self.last = None
        self.in_rep = None

    # ---- hooks ---------------------------------------------------------------------------------------------------------------------------

    def attach(self, uc, ensure, trace, sp):
        from unicorn import x86_const as X
        self.uc, self.X, self.ensure, self.trace, self.sp = uc, X, ensure, trace, sp
        import unicorn
        self.unicorn = unicorn
        self.ucreg = {n: getattr(X, 'UC_X86_REG_' + n.upper()) for n in FULL}
        for n in SYMBOLIC_START:
            v = z3.BitVec('r_' + n, 32)
            c = uc.reg_read(self.ucreg[n])
            self.R[n] = v
            self.inputs['r_' + n] = (v, c, 'reg', n)
        va, size = self.row['va'], self.row['body']
        uc.hook_add(unicorn.UC_HOOK_CODE, self.step, begin=va, end=va + size - 1)

    def step(self, uc, address, size, user):
        if self.dead:
            return
        try:
            self.sync(address)
            ins = self.code_of(address)
            if ins is None:
                self.tainted = True
                return
            if ins.mnemonic.startswith('rep'):          # Unicorn fires the code hook for every iteration of a rep instruction: the shadow models the whole loop at the first one
                if self.in_rep == address:
                    return
                self.in_rep = address
            else:
                self.in_rep = None
            self.steps += 1
            if self.steps > SHADOW_LIMIT:          # the shadow stops here; Unicorn runs on (the path is the first SHADOW_LIMIT instructions)
                self.dead = True
                return
            if DEBUG and TRACE_STEPS:
                print('   step', self.steps, self.last or '', flush=True)
            self.exec(ins)
        except unicorn_errors() as e:           # a memory fault inside the shadow's own reads: the real run will fault too
            self.dead = True
        except Exception as e:               # a bug of the shadow: this run stops producing conditions after here
            Stats.mismatches[type(e).__name__ + ':' + (self.last or '?')] += 1
            if DEBUG:
                import traceback
                traceback.print_exc()
            self.dead = True

    def sync(self, address):
        """Called before every instruction: the direction of the previous conditional jump and the effect of a callee stub that ran since."""
        if self.pending is not None:
            kind, at, cond, target, after = self.pending
            self.pending = None
            taken = address == target
            if kind == 'br':
                self.path.append(('br', at, cond if taken else z3.Not(cond), (target, after, taken)))
            else:
                self.path.append(('sw', at, cond, (None, address, getattr(self, 'switch_entries', {}))))
        calls = self.trace.calls
        while self.ncalls < len(calls):
            call = calls[self.ncalls]
            self.ncalls += 1
            for n in ('eax', 'ecx', 'edx'):
                self.R.pop(n, None)
            for at, data in call[7]:
                for k in range(len(data)):
                    self.mem.pop(at + k, None)
                    self.written.add(at + k)
            self.flags.clear()

    # ---- state access --------------------------------------------------------------------------------------------------------------------

    def creg(self, full):
        return self.uc.reg_read(self.ucreg[full])

    def get_reg(self, name):
        full, s, shift = REGS[name]
        e = self.R.get(full)
        if e is None:
            return (self.creg(full) >> shift) & MASK[s]
        return z3.Extract(shift + 8 * s - 1, shift, e) if s < 4 else e

    def set_reg(self, name, val):
        full, s, shift = REGS[name]
        if s == 4:
            if sym(val):
                self.R[full] = val
            else:
                self.R.pop(full, None)
            return
        old = self.R.get(full)
        if old is None and not sym(val):
            self.R.pop(full, None)
            return
        if old is None:
            old = z3.BitVecVal(self.creg(full), 32)
        parts = []
        if shift + 8 * s < 32:
            parts.append(z3.Extract(31, shift + 8 * s, old))
        parts.append(E(val, s))
        if shift:
            parts.append(z3.Extract(shift - 1, 0, old))
        self.R[full] = z3.Concat(*parts) if len(parts) > 1 else parts[0]

    def flag(self, name):
        f = self.flags.get(name)
        if f is not None:
            return f
        return bool((self.uc.reg_read(self.X.UC_X86_REG_EFLAGS) >> FLAG_BIT[name]) & 1)

    def eligible(self, a):
        if a >= 0xfff00000:
            return False          # the world faults there; an override at 0xffff0000 and up would be taken for a register override
        if W.IMAGE_BASE <= a < W.DATA_START:
            return False
        if self.sp + 4 <= a < self.sp + 4 + 4 * W.ARGS:
            return True
        if W.STACK_BASE <= a < W.STACK_BASE + W.STACK_SIZE:
            return False
        if W.STUB_BASE <= a < W.STUB_BASE + 0x1000 or (W.STOP & ~0xfff) <= a < (W.STOP & ~0xfff) + 0x1000 or W.GDT <= a < W.GDT + 0x1000:
            return False
        if W.TIB <= a < W.TIB + 0x1000:
            return bool(self.row['fs'])
        return True

    def read_bytes(self, addr, n):
        self.ensure(addr)
        self.ensure(addr + n - 1)
        raw = bytes(self.uc.mem_read(addr, n))
        parts = []
        anysym = False
        for k in range(n):
            a = addr + k
            b = self.mem.get(a)
            if b is None and a not in self.written and self.eligible(a):
                name = 'm_%x' % a
                b = z3.BitVec(name, 8)
                self.mem[a] = b
                self.inputs[name] = (b, raw[k], 'mem', a)
            if b is None:
                parts.append(raw[k])
            else:
                parts.append(b)
                anysym = True
        if not anysym:
            return int.from_bytes(raw, 'little')
        exprs = [E(p, 1) if isinstance(p, int) else p for p in parts]
        return z3.Concat(*reversed(exprs)) if n > 1 else exprs[0]

    def write_bytes(self, addr, val, n):
        for k in range(n):
            a = addr + k
            self.written.add(a)
            if sym(val):
                self.mem[a] = z3.Extract(8 * k + 7, 8 * k, val) if n > 1 else val
            else:
                self.mem.pop(a, None)

    def pin(self, expr, concrete, s=4, why='ptr'):
        """The address (or count) `expr` depends on an input: it stays at its value in every child of this run."""
        self.path.append(('ptr', None, E(expr, s) == E(concrete, s), why))

    # ---- operands ------------------------------------------------------------------------------------------------------------------------

    def ea(self, op):
        """(concrete address, symbolic expression or None) of a memory operand."""
        m = op.mem
        parts = []
        concrete = m.disp
        symb = False
        if m.base:
            r = self.reg_value32(self.md_name(m.base))
            parts.append(r)
            concrete += self.creg(self.md_name(m.base))
            symb |= sym(r)
        if m.index:
            r = self.reg_value32(self.md_name(m.index))
            parts.append(binop(op_mul, r, m.scale, 4))
            concrete += self.creg(self.md_name(m.index)) * m.scale
            symb |= sym(r)
        if m.segment == CX.X86_REG_FS:
            concrete += W.TIB
        concrete &= 0xffffffff
        if not symb:
            return concrete, None
        e = E(m.disp, 4)
        for p in parts:
            e = e + E(p, 4)
        if m.segment == CX.X86_REG_FS:
            e = e + W.TIB
        return concrete, e

    def md_name(self, reg):
        return self.cur.reg_name(reg)

    def reg_value32(self, name):
        e = self.R.get(name)
        return self.creg(name) if e is None else e

    def const_region(self, a):
        return W.IMAGE_BASE <= a < W.DATA_START

    def const_table(self, addr_c, e, n):
        """A read of n constant bytes at a symbolic address: an If chain over the neighbours of the concrete address (the entries of a switch or index table)."""
        lo = addr_c - CONST_WINDOW * n
        hi = addr_c + CONST_WINDOW * n
        lo = max(lo, W.IMAGE_BASE)
        lo += (addr_c - lo) % n
        hi = min(hi, W.DATA_START - n)
        raw = bytes(self.uc.mem_read(lo, hi - lo + n))
        self.path.append(('ptr', None, z3.And(z3.ULE(E(lo, 4), e), z3.ULE(e, E(hi, 4)), z3.URem(e - E(lo, 4), E(n, 4)) == 0), 'table'))
        res = E(int.from_bytes(raw[addr_c - lo:addr_c - lo + n], 'little'), n)
        for a in range(lo, hi + 1, n):
            v = int.from_bytes(raw[a - lo:a - lo + n], 'little')
            res = z3.If(e == E(a, 4), E(v, n), res)
        self.table_entries = {a: int.from_bytes(raw[a - lo:a - lo + n], 'little') for a in range(lo, hi + 1, n)}
        return res

    def read_op(self, ins, k, size=None):
        op = ins.operands[k]
        s = size or op.size
        if op.type == CX.X86_OP_REG:
            return self.get_reg(ins.reg_name(op.reg))
        if op.type == CX.X86_OP_IMM:
            return op.imm & MASK[s]
        addr_c, e = self.ea(op)
        if e is not None:
            if self.const_region(addr_c):
                return self.const_table(addr_c, e, s)
            self.pin(e, addr_c)
        return self.read_bytes(addr_c, s)

    def write_op(self, ins, k, val, size=None):
        op = ins.operands[k]
        s = size or op.size
        if op.type == CX.X86_OP_REG:
            self.set_reg(ins.reg_name(op.reg), val)
            return
        addr_c, e = self.ea(op)
        if e is not None:
            self.pin(e, addr_c, why='store')          # a store through an input: its target can be moved (children), e.g. away from a cell the function reads later
        self.write_bytes(addr_c, val, s)

    # ---- flags ---------------------------------------------------------------------------------------------------------------------------

    def drop_flags(self, names=('CF', 'PF', 'AF', 'ZF', 'SF', 'OF')):
        for n in names:
            self.flags.pop(n, None)

    def alu(self, kind, a, b, s, cin=0, setflags=True):
        """Result and flags of add adc sub sbb cmp and or xor test. cin is 0 or 1, or a z3 value of s bytes."""
        if kind in ('add', 'adc'):
            res = binop(op_add, a, b, s)
            if kind == 'adc':
                res = binop(op_add, res, cin, s)
        elif kind in ('sub', 'sbb', 'cmp'):
            res = binop(op_sub, a, b, s)
            if kind == 'sbb':
                res = binop(op_sub, res, cin, s)
        else:
            res = binop({'and': op_and, 'or': op_or, 'xor': op_xor, 'test': op_and}[kind], a, b, s)
        if not setflags:
            return res
        self.drop_flags()
        if not (sym(a) or sym(b) or sym(cin)):
            return res
        bits = 8 * s
        A, B, R, C = E(a, s), E(b, s), E(res, s), E(cin, s)
        self.flags['ZF'] = R == 0
        self.flags['SF'] = msb(R, s)
        if kind in ('add', 'adc'):
            wide = z3.ZeroExt(1, A) + z3.ZeroExt(1, B) + (z3.ZeroExt(1, C) if kind == 'adc' else 0)
            self.flags['CF'] = z3.Extract(bits, bits, wide) == 1
            self.flags['OF'] = msb((A ^ R) & (B ^ R), s)
        elif kind in ('sub', 'sbb', 'cmp'):
            wide = z3.ZeroExt(1, A) - z3.ZeroExt(1, B) - (z3.ZeroExt(1, C) if kind == 'sbb' else 0)
            self.flags['CF'] = z3.Extract(bits, bits, wide) == 1
            self.flags['OF'] = msb((A ^ B) & (A ^ R), s)
        else:
            self.flags['CF'] = z3.BoolVal(False)
            self.flags['OF'] = z3.BoolVal(False)
        return res

    def cond(self, expr):
        """Boolean (z3 or Python) of a condition code over the flags."""
        f = self.flag
        table = {
            'ZF': lambda: f('ZF'), '~ZF': lambda: _not(f('ZF')), 'CF': lambda: f('CF'), '~CF': lambda: _not(f('CF')), 'CF|ZF': lambda: _or(f('CF'), f('ZF')),
            '~CF&~ZF': lambda: _and(_not(f('CF')), _not(f('ZF'))), 'SF': lambda: f('SF'), '~SF': lambda: _not(f('SF')), 'OF': lambda: f('OF'), '~OF': lambda: _not(f('OF')),
            'SF^OF': lambda: _xor(f('SF'), f('OF')), 'SF==OF': lambda: _not(_xor(f('SF'), f('OF'))), 'ZF|SF^OF': lambda: _or(f('ZF'), _xor(f('SF'), f('OF'))),
            '~ZF&SF==OF': lambda: _and(_not(f('ZF')), _not(_xor(f('SF'), f('OF')))), 'PF': lambda: f('PF'), '~PF': lambda: _not(f('PF'))}
        return table[expr]()

    # ---- instructions --------------------------------------------------------------------------------------------------------------------

    def exec(self, ins):
        self.cur_ins = ins
        self.last = '%x %s %s' % (ins.address, ins.mnemonic, ins.op_str)
        m = ins.mnemonic
        h = getattr(self, 'i_' + m.replace(' ', '_'), None)
        if m in JCC:
            return self.i_jcc(ins)
        if m in SETCC:
            return self.i_setcc(ins)
        if m in CMOV:
            return self.i_cmov(ins)
        if h is None:
            return self.generic(ins)
        h(ins)

    def generic(self, ins):
        """An instruction the shadow does not model: whatever it writes becomes concrete (Unicorn's value)."""
        Stats.unsupported[ins.mnemonic] += 1
        read, write = ins.regs_access()
        for r in write:
            n = ins.reg_name(r)
            if n in REGS:
                full, s, shift = REGS[n]
                self.R.pop(full, None)
            elif n == 'eflags':
                self.drop_flags()
        for op in ins.operands:
            if op.type == CX.X86_OP_MEM and (op.access & capstone.CS_AC_WRITE):
                addr_c, e = self.ea(op)
                if e is not None:
                    self.pin(e, addr_c)
                for k in range(op.size):
                    self.mem.pop(addr_c + k, None)
                    self.written.add(addr_c + k)
        if ins.mnemonic.startswith('rep') or ins.mnemonic.startswith('movs') or ins.mnemonic.startswith('stos') or ins.mnemonic.startswith('cmps') or ins.mnemonic.startswith('scas'):
            self.string_generic(ins)

    def string_generic(self, ins):
        self.drop_flags()
        for n in ('ecx', 'esi', 'edi'):
            self.R.pop(n, None)

    def i_nop(self, ins): pass
    def i_cld(self, ins): pass
    def i_std(self, ins): pass
    def i_int3(self, ins): pass
    def i_ret(self, ins): pass
    def i_fwait(self, ins): pass

    def i_mov(self, ins):
        self.write_op(ins, 0, self.read_op(ins, 1, ins.operands[0].size))

    def i_movzx(self, ins):
        v = self.read_op(ins, 1)
        self.write_op(ins, 0, zext(v, ins.operands[1].size, ins.operands[0].size))

    def i_movsx(self, ins):
        v = self.read_op(ins, 1)
        self.write_op(ins, 0, sext(v, ins.operands[1].size, ins.operands[0].size))

    i_movsxd = i_movsx

    def i_lea(self, ins):
        op = ins.operands[1]
        m = op.mem
        r = E(m.disp, 4)
        concrete = True
        res = m.disp & 0xffffffff
        if m.base:
            v = self.reg_value32(self.md_name(m.base))
            res = binop(op_add, res, v, 4)
        if m.index:
            v = self.reg_value32(self.md_name(m.index))
            res = binop(op_add, res, binop(op_mul, v, m.scale, 4), 4)
        self.write_op(ins, 0, res)

    def i_push(self, ins):
        v = self.read_op(ins, 0, 4) if ins.operands[0].type != CX.X86_OP_IMM else ins.operands[0].imm & 0xffffffff
        esp = self.creg('esp') - 4
        self.write_bytes(esp, v, 4)

    def i_pop(self, ins):
        esp = self.creg('esp')
        v = self.read_bytes(esp, 4)
        self.write_op(ins, 0, v, 4)

    def i_call(self, ins):
        esp = self.creg('esp') - 4
        self.write_bytes(esp, 0, 4)
        op = ins.operands[0]
        if op.type != CX.X86_OP_IMM:
            if op.type == CX.X86_OP_MEM:
                addr_c, e = self.ea(op)
                if e is not None:
                    self.pin(e, addr_c)
            else:
                r = self.get_reg(ins.reg_name(op.reg))
                if sym(r):
                    self.pin(r, self.creg(REGS[ins.reg_name(op.reg)][0]))

    def i_jmp(self, ins):
        op = ins.operands[0]
        if op.type == CX.X86_OP_IMM:
            return
        if op.type == CX.X86_OP_MEM:
            self.table_entries = None
            v = self.read_op(ins, 0, 4)
            if sym(v):
                self.pending = ('sw', ins.address, v, None, None)
                self.switch_entries = dict(self.table_entries or {})
            return
        r = self.get_reg(ins.reg_name(op.reg))
        if sym(r):
            self.pending = ('sw', ins.address, r, None, None)
            self.switch_entries = {}

    def i_jcc(self, ins):
        c = self.cond(JCC[ins.mnemonic])
        if not isinstance(c, bool):
            self.pending = ('br', ins.address, c, ins.operands[0].imm, ins.address + ins.size)

    def i_setcc(self, ins):
        c = self.cond(SETCC[ins.mnemonic])
        if isinstance(c, bool):
            self.write_op(ins, 0, int(c), 1)
        else:
            self.write_op(ins, 0, z3.If(c, z3.BitVecVal(1, 8), z3.BitVecVal(0, 8)), 1)

    def i_cmov(self, ins):
        c = self.cond(CMOV[ins.mnemonic])
        s = ins.operands[0].size
        src = self.read_op(ins, 1)
        dst = self.read_op(ins, 0)
        if isinstance(c, bool):
            self.write_op(ins, 0, src if c else dst)
        else:
            self.write_op(ins, 0, z3.If(c, E(src, s), E(dst, s)))

    def binary(self, ins, kind, write=True):
        s = ins.operands[0].size
        a = self.read_op(ins, 0)
        b = self.read_op(ins, 1, s)
        if ins.operands[1].type == CX.X86_OP_IMM:
            b = ins.operands[1].imm & MASK[s]
        cin = 0
        if kind in ('adc', 'sbb'):
            f = self.flag('CF')
            cin = int(f) if isinstance(f, bool) else z3.If(f, z3.BitVecVal(1, 8 * s), z3.BitVecVal(0, 8 * s))
        if kind in ('cmp', 'sub', 'sbb') and (sym(a) or sym(b)):
            self.cmps.append((len(self.path), ins.address, E(a, s), E(b, s), s))
        res = self.alu(kind, a, b, s, cin)
        if write:
            self.write_op(ins, 0, res)

    def i_add(self, ins): self.binary(ins, 'add')
    def i_adc(self, ins): self.binary(ins, 'adc')
    def i_sub(self, ins): self.binary(ins, 'sub')
    def i_sbb(self, ins): self.binary(ins, 'sbb')
    def i_and(self, ins): self.binary(ins, 'and')
    def i_or(self, ins): self.binary(ins, 'or')
    def i_xor(self, ins):
        o = ins.operands
        if o[0].type == CX.X86_OP_REG and o[1].type == CX.X86_OP_REG and o[0].reg == o[1].reg:
            self.set_reg(ins.reg_name(o[0].reg), 0)
            self.drop_flags()
            return
        self.binary(ins, 'xor')
    def i_cmp(self, ins): self.binary(ins, 'cmp', write=False)
    def i_test(self, ins): self.binary(ins, 'test', write=False)

    def i_inc(self, ins): self.incdec(ins, 1)
    def i_dec(self, ins): self.incdec(ins, -1)

    def incdec(self, ins, d):
        s = ins.operands[0].size
        a = self.read_op(ins, 0)
        cf = self.flags.get('CF')
        res = self.alu('add' if d > 0 else 'sub', a, 1, s)
        if cf is None:
            self.flags.pop('CF', None)
        else:
            self.flags['CF'] = cf
        self.write_op(ins, 0, res)

    def i_neg(self, ins):
        s = ins.operands[0].size
        a = self.read_op(ins, 0)
        res = self.alu('sub', 0, a, s)
        self.write_op(ins, 0, res)

    def i_not(self, ins):
        s = ins.operands[0].size
        a = self.read_op(ins, 0)
        self.write_op(ins, 0, binop(op_xor, a, MASK[s], s))

    def shift(self, ins, kind):
        s = ins.operands[0].size
        a = self.read_op(ins, 0)
        n = ins.operands[1] if len(ins.operands) > 1 else None
        if n is None:
            cnt = 1
        elif n.type == CX.X86_OP_IMM:
            cnt = n.imm & 0x1f
        else:
            v = self.get_reg('cl')
            cc = self.creg('ecx') & 0xff
            if sym(v):
                self.pin(v, cc, 1)
            cnt = cc & 0x1f
        if cnt == 0:
            return
        if kind == 'shl':
            res = binop(op_shl, a, cnt, s)
        elif kind == 'shr':
            res = binop(op_lshr, a, cnt, s)
        else:
            res = a & MASK[s] if isinstance(a, int) and False else None
            if isinstance(a, int):
                res = op_ashr_int(s)(a, cnt) & MASK[s]
            else:
                res = E(a, s) >> cnt
        self.drop_flags()
        if sym(a) and cnt < 8 * s:
            R = E(res, s)
            A = E(a, s)
            self.flags['ZF'] = R == 0
            self.flags['SF'] = msb(R, s)
            if kind == 'shl':
                self.flags['CF'] = z3.Extract(8 * s - cnt, 8 * s - cnt, A) == 1
            else:
                self.flags['CF'] = z3.Extract(cnt - 1, cnt - 1, A) == 1
        self.write_op(ins, 0, res)

    def i_shl(self, ins): self.shift(ins, 'shl')
    i_sal = i_shl
    def i_shr(self, ins): self.shift(ins, 'shr')
    def i_sar(self, ins): self.shift(ins, 'sar')

    def i_imul(self, ins):
        n = len(ins.operands)
        if n == 1:
            return self.mul1(ins, True)
        s = ins.operands[0].size
        if n == 2:
            a, b = self.read_op(ins, 0), self.read_op(ins, 1, s)
        else:
            a, b = self.read_op(ins, 1), ins.operands[2].imm & MASK[s]
        res = binop(op_mul, a, b, s)
        self.drop_flags()
        self.write_op(ins, 0, res)

    def i_mul(self, ins): self.mul1(ins, False)

    def mul1(self, ins, signed):
        s = ins.operands[0].size
        if s != 4:
            return self.generic(ins)
        a = self.get_reg('eax')
        b = self.read_op(ins, 0)
        self.drop_flags()
        if not (sym(a) or sym(b)):
            self.R.pop('eax', None)
            self.R.pop('edx', None)
            return
        ext = z3.SignExt if signed else z3.ZeroExt
        wide = ext(32, E(a, 4)) * ext(32, E(b, 4))
        self.R['eax'] = z3.Extract(31, 0, wide)
        self.R['edx'] = z3.Extract(63, 32, wide)

    def i_div(self, ins): self.div1(ins, False)
    def i_idiv(self, ins): self.div1(ins, True)

    def div1(self, ins, signed):
        s = ins.operands[0].size
        if s != 4:
            return self.generic(ins)
        lo, hi = self.get_reg('eax'), self.get_reg('edx')
        d = self.read_op(ins, 0)
        self.drop_flags()
        if not (sym(lo) or sym(hi) or sym(d)):
            self.R.pop('eax', None)
            self.R.pop('edx', None)
            return
        if sym(d):
            d = self.read_concrete_operand(ins)
            self.pin(self.read_op(ins, 0), d)
        wide = z3.Concat(E(hi, 4), E(lo, 4))
        dd = E(d, 4)
        if signed:
            self.R['eax'] = z3.Extract(31, 0, wide / z3.SignExt(32, dd))
            self.R['edx'] = z3.Extract(31, 0, z3.SRem(wide, z3.SignExt(32, dd)))
        else:
            self.R['eax'] = z3.Extract(31, 0, z3.UDiv(wide, z3.ZeroExt(32, dd)))
            self.R['edx'] = z3.Extract(31, 0, z3.URem(wide, z3.ZeroExt(32, dd)))

    def read_concrete_operand(self, ins):
        op = ins.operands[0]
        if op.type == CX.X86_OP_REG:
            full, s, shift = REGS[ins.reg_name(op.reg)]
            return (self.creg(full) >> shift) & MASK[s]
        addr_c, _ = self.ea(op)
        return int.from_bytes(bytes(self.uc.mem_read(addr_c, op.size)), 'little')

    def i_cdq(self, ins):
        a = self.get_reg('eax')
        if sym(a):
            self.R['edx'] = z3.If(z3.Extract(31, 31, a) == 1, z3.BitVecVal(0xffffffff, 32), z3.BitVecVal(0, 32))
        else:
            self.R.pop('edx', None)

    def i_xchg(self, ins):
        a, b = self.read_op(ins, 0), self.read_op(ins, 1)
        self.write_op(ins, 0, b)
        self.write_op(ins, 1, a)

    def i_leave(self, ins):
        self.R.pop('esp', None)
        ebp = self.creg('ebp')
        v = self.read_bytes(ebp, 4)
        self.set_reg('ebp', v)

    def string_op(self, ins, kind, size):
        """movs and stos with a count that is an input: the count is pinned; the copy moves the shadow bytes."""
        rep = 'rep' in ins.mnemonic
        count = self.creg('ecx') if rep else 1
        if rep and sym(self.R.get('ecx', 0)):
            self.pin(self.R['ecx'], count)
        step = -size if self.uc.reg_read(self.X.UC_X86_REG_EFLAGS) & 0x400 else size
        esi, edi = self.creg('esi'), self.creg('edi')
        for name in ('esi', 'edi'):
            if sym(self.R.get(name, 0)):
                self.pin(self.R[name], self.creg(name))
        if count > 4096:
            return self.string_generic(ins)
        if kind == 'movs':
            for k in range(count):
                v = self.read_bytes(esi + k * step, size)
                self.write_bytes(edi + k * step, v, size)
        else:
            v = self.get_reg({1: 'al', 2: 'ax', 4: 'eax'}[size])
            for k in range(count):
                self.write_bytes(edi + k * step, v, size)
        if rep:
            self.R.pop('ecx', None)
        if kind == 'movs':
            self.R.pop('esi', None)
        self.R.pop('edi', None)

    def i_movsb(self, ins): self.string_op(ins, 'movs', 1)
    def i_movsw(self, ins): self.string_op(ins, 'movs', 2)
    def i_movsd(self, ins): self.string_op(ins, 'movs', 4)
    def i_stosb(self, ins): self.string_op(ins, 'stos', 1)
    def i_stosw(self, ins): self.string_op(ins, 'stos', 2)
    def i_stosd(self, ins): self.string_op(ins, 'stos', 4)

    def i_rep_movsb(self, ins): self.string_op(ins, 'movs', 1)
    def i_rep_movsw(self, ins): self.string_op(ins, 'movs', 2)
    def i_rep_movsd(self, ins): self.string_op(ins, 'movs', 4)
    def i_rep_stosb(self, ins): self.string_op(ins, 'stos', 1)
    def i_rep_stosw(self, ins): self.string_op(ins, 'stos', 2)
    def i_rep_stosd(self, ins): self.string_op(ins, 'stos', 4)

    SCAN_LIMIT = 300            # bytes of a scan (repne scasb, repe cmpsb) that become path conditions

    def scan(self, ins, kind):
        """repne scasb (al against [edi]) and repe cmpsb ([esi] against [edi]): each byte compared is a path condition `equal` or `not equal`, so that the solver can move the end of the string."""
        count = self.creg('ecx')
        if sym(self.R.get('ecx', 0)):
            self.pin(self.R['ecx'], count)
        step = -1 if self.uc.reg_read(self.X.UC_X86_REG_EFLAGS) & 0x400 else 1
        edi, esi = self.creg('edi'), self.creg('esi')
        for name in ('esi', 'edi'):
            if sym(self.R.get(name, 0)):
                self.pin(self.R[name], self.creg(name))
        al = self.get_reg('al')
        n = 0
        last = None
        while n < count and n < 0x10000:
            if kind == 'scas':
                bc = self.uc_byte(edi + n * step)
                eq = bc == (al if isinstance(al, int) else self.creg('eax') & 0xff)
                a, b = al, self.read_bytes(edi + n * step, 1) if n < self.SCAN_LIMIT else bc
                stop = eq
            else:
                ac, bc = self.uc_byte(esi + n * step), self.uc_byte(edi + n * step)
                eq = ac == bc
                a = self.read_bytes(esi + n * step, 1) if n < self.SCAN_LIMIT else ac
                b = self.read_bytes(edi + n * step, 1) if n < self.SCAN_LIMIT else bc
                stop = not eq
            n += 1
            last = (a, b, eq)
            if sym(a) or sym(b):
                c = E(a, 1) == E(b, 1)
                self.path.append(('br', ins.address, c if eq else z3.Not(c), ((ins.address, 'scan', n - 1), (ins.address, 'scan', n), eq)))
            if stop:
                break
        self.drop_flags()
        if last is not None and (sym(last[0]) or sym(last[1])):
            self.alu('cmp', last[0], last[1], 1)
        self.R.pop('ecx', None)
        self.R.pop('edi', None)
        if kind == 'cmps':
            self.R.pop('esi', None)

    def uc_byte(self, a):
        self.ensure(a)
        return self.uc.mem_read(a, 1)[0]

    def i_repne_scasb(self, ins): self.scan(ins, 'scas')
    def i_repe_cmpsb(self, ins): self.scan(ins, 'cmps')

    def i_cwde(self, ins):
        a = self.get_reg('ax')
        self.set_reg('eax', sext(a, 2, 4))

    def i_sahf(self, ins):
        self.drop_flags()
        self.generic(ins)

    def i_lahf(self, ins): self.generic(ins)


def _not(x): return (not x) if isinstance(x, bool) else z3.Not(x)
def _and(x, y): return (x and y) if isinstance(x, bool) and isinstance(y, bool) else z3.And(x, y)
def _or(x, y): return (x or y) if isinstance(x, bool) and isinstance(y, bool) else z3.Or(x, y)
def _xor(x, y): return (x != y) if isinstance(x, bool) and isinstance(y, bool) else z3.Xor(x, y)


DEBUG = False
SHADOW_LIMIT = 5000           # the shadow follows the first this many instructions of a run (a longer run is mostly a loop: other trip counts are found by flipping its first iterations)
REPAIR_FLIPS = 12            # a faulting run that reached a new edge gets this many extra children (the latest distinct branches flipped) to find a variant that ends
TRACE_STEPS = False


def unicorn_errors():
    import unicorn
    return unicorn.UcError


# ---- the search -----------------------------------------------------------------------------------------------------------------------------


class Row:
    """Everything the search needs about one lower row."""

    def __init__(self, key):
        self.key = key
        self.va = int(key, 16)
        spans = L.ledger_spans()
        text, callees, imports, fs, inline = L.lift(self.va, spans[self.va])
        self.inline = inline
        self.text = text
        self.info = W.row_info(self.va, spans[self.va], callees, imports, fs)
        self.md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        self.md.detail = True
        pe = W.od.load_image()
        off = self.va - pe.image_base
        self.insns = {i.address: i for i in self.md.disasm(pe.image[off:off + self.info['body']], self.va)}
        self.lib = None
        self.indirect = [hex(i.address) for i in self.insns.values() if i.mnemonic == 'call' and i.operands[0].type != CX.X86_OP_IMM
                         and not (i.operands[0].type == CX.X86_OP_MEM and not i.operands[0].mem.base and not i.operands[0].mem.index and (i.operands[0].mem.disp & 0xffffffff) in self.info['imports'])]

    def code_of(self, address):
        return self.insns.get(address)

    def native_lib(self):
        if self.lib is None:
            spans = L.ledger_spans()
            tmp = tempfile.mkdtemp()
            src = Path(tmp) / 'row.c'
            helper = L.lift(0x50c920, spans[0x50c920])[0] if self.inline else ''
            src.write_text('#include "original_methods_fl40.h"\n' + helper + '\n' + self.text)
            self.lib = W.build_library(tmp, [src])
        return self.lib


def trace_scenario(rowobj, seed, overrides):
    """Run the original under Unicorn with the shadow; returns (trace, shadow run)."""
    run = Run(rowobj.info, rowobj.md, rowobj.code_of)
    run.cur = rowobj.md
    tr = W.run_original(rowobj.info, seed, [tuple(o) for o in overrides], watch=run.attach)
    run.sync(-1)
    return tr, run


def selfcheck(run):
    """Re-solve the path under the concrete inputs: returns the index of the first path condition that the real run did not satisfy, or None."""
    s = z3.Solver()
    for name, (var, cv, kind, where) in run.inputs.items():
        s.add(var == z3.BitVecVal(cv, var.size()))
    for k, (kind, at, cond, info) in enumerate(run.path):
        s.add(cond)
        if s.check() != z3.sat:
            return k
    return None


def model_overrides(run, model, parent):
    """Overrides of the child: the parent's cells plus every input byte the model changes."""
    cells = {}
    regs = {}
    for a, n, v in parent:
        if a >= W.REG_OVERRIDE:
            regs[a] = v
        else:
            for k in range(n):
                cells[a + k] = (v >> (8 * k)) & 0xff
    for name, (var, cv, kind, where) in run.inputs.items():
        val = model.eval(var, model_completion=False)
        if val is None or not z3.is_bv_value(val):
            continue
        val = val.as_long()
        if val == cv:
            continue
        if kind == 'mem':
            cells[where] = val
        else:
            regs[W.REG_OVERRIDE + 4 * W.REG_NAMES.index(where)] = val
    out = []
    addrs = sorted(cells)
    k = 0
    while k < len(addrs):
        a = addrs[k]
        n = 1
        while n < 4 and k + n < len(addrs) and addrs[k + n] == a + n:
            n += 1
        if n == 3:
            n = 2
        v = 0
        for j in range(n):
            v |= cells[a + j] << (8 * j)
        out.append([a, n, v])
        k += n
    for a, v in sorted(regs.items()):
        out.append([a, 4, v])
    return out


def key_of(seed, overrides):
    return (seed, tuple(sorted(tuple(o) for o in overrides)))


_var_cache = {}
_EMPTY = frozenset()


def collect_vars(e):
    """Names of the input variables of a z3 expression. Memoised per AST node: the conditions of a loop share almost all of their sub-terms."""
    key = e.get_id()
    hit = _var_cache.get(key)
    if hit is not None:
        return hit
    if len(_var_cache) > 1500000:
        _var_cache.clear()
    stack = [(e, False)]
    while stack:
        x, done = stack.pop()
        i = x.get_id()
        if i in _var_cache:
            continue
        if not done:
            if z3.is_const(x):
                _var_cache[i] = frozenset([x.decl().name()]) if x.decl().kind() == z3.Z3_OP_UNINTERPRETED else _EMPTY
                continue
            kids = x.children()
            if not kids:
                _var_cache[i] = _EMPTY
                continue
            stack.append((x, True))
            for k in kids:
                if k.get_id() not in _var_cache:
                    stack.append((k, False))
        else:
            out = set()
            for k in x.children():
                out |= _var_cache[k.get_id()]
            _var_cache[i] = frozenset(out)
    return _var_cache[key]


class Slices:
    """Constraints grouped by the input variables they share (the cone of influence): a flip is solved against its own group only."""

    def __init__(self):
        self.parent = {}
        self.cons = {}

    def find(self, v):
        root = v
        while self.parent.setdefault(root, root) != root:
            root = self.parent[root]
        while self.parent[v] != root:
            self.parent[v], v = root, self.parent[v]
        return root

    def group(self, cond):
        """The earlier constraints that share variables (transitively) with `cond`."""
        roots = {self.find(v) for v in collect_vars(cond)}
        out = []
        for r in roots:
            out.extend(self.cons.get(r, ()))
        return out

    def add(self, cond):
        vs = collect_vars(cond)
        if not vs:
            return
        roots = sorted({self.find(v) for v in vs})
        base = roots[0]
        merged = []
        for r in roots:
            merged.extend(self.cons.pop(r, ()))
            self.parent[r] = base
        merged.append(cond)
        self.cons[base] = merged


def solve(run, group, goal, solver_ms):
    """A model of `group and goal` that keeps as many inputs of the group at the values of the run as it can (soft constraints), or None."""
    if len(group) > BIG_GROUP:          # a long loop's chain of conditions: a plain satisfiability check, no preference for the run's values
        s = z3.Solver()
        s.set('timeout', solver_ms // 2)
        for c in group:
            s.add(c)
        s.add(goal)
        return s.model() if s.check() == z3.sat else None
    names = set(collect_vars(goal))
    for c in group:
        names |= collect_vars(c)
    o = z3.Optimize()
    o.set('timeout', solver_ms)
    for c in group:
        o.add(c)
    o.add(goal)
    for n in sorted(names):
        item = run.inputs.get(n)
        if item is not None:
            o.add_soft(item[0] == z3.BitVecVal(item[1], item[0].size()))
    if o.check() != z3.sat:
        return None
    return o.model()


MAX_SOLVES_PER_RUN = 60
BIG_GROUP = 120
FLIP_WINDOW = (300, 60)          # a path longer than this is flipped only in its first 300 and last 60 conditions
GIVE_UP_RUNS = 60
STAGNATION_RUNS = 500
MAX_SPREAD = 24
MOVE_STORES = 4          # per run: the first and last this many stores through an input get a child that stores somewhere else
SPREAD_RANKS = 4
SPREAD_LAST = 60
FIRST_OCCURRENCES = 2


def children(run, ov, ex, ed, tried, promising, row, solver_ms, log):
    """The child scenarios of one run: for every path condition whose other direction (or a switch target) is not covered, the model of `its group and not the condition`."""
    _var_cache.clear()          # the cache is keyed by AST id, valid only while the run's expressions are alive
    path = run.path
    repair = set()
    if promising:
        seen_pairs = set()
        for idx in range(len(path) - 1, -1, -1):
            kind, at, cond, info = path[idx]
            if kind == 'br' and (at, info[2]) not in seen_pairs:
                seen_pairs.add((at, info[2]))
                repair.add(idx)
                if len(repair) >= REPAIR_FLIPS:
                    break
    wanted = {}
    last = {}
    for idx, (kind, at, cond, info) in enumerate(path):
        if kind == 'br':
            target, after, was_taken = info
            edge = (at, after if was_taken else target)
            last[edge] = idx
            wanted.setdefault(edge, []).append(idx)
    flips = set(repair)
    for edge, idxs in wanted.items():
        if edge in ed or tried[edge] >= 8:
            continue
        flips.update(idxs[:FIRST_OCCURRENCES])
        flips.add(idxs[-1])
    spread = set()                      # secondary: the first occurrences of every branch, whatever is covered (other trip counts of a loop, other branches on the way)
    for edge, idxs in wanted.items():
        for rank, idx in enumerate(idxs[:SPREAD_RANKS]):
            if idx not in flips and tried[('spread', edge, rank)] < 1:
                spread.add(idx)
        if idxs[-1] not in flips and tried[('spread', edge, 'last')] < SPREAD_LAST:          # the last time this branch ran: flipping it lets a loop that stopped here go one turn further
            spread.add(idxs[-1])
    if len(path) > sum(FLIP_WINDOW):
        keep = set(range(FLIP_WINDOW[0])) | set(range(len(path) - FLIP_WINDOW[1], len(path)))
        flips &= keep
        spread &= keep
    sl = Slices()
    out = []
    second = []
    solves = 0
    stores = [i for i, e in enumerate(path) if e[0] == 'ptr' and e[3] == 'store']
    move = set(stores[:MOVE_STORES] + stores[-MOVE_STORES:])
    for idx, (kind, at, cond, info) in enumerate(path):
        if kind == 'ptr':
            if idx in move and len(second) < MAX_SPREAD + 2 * MOVE_STORES:
                model = solve(run, sl.group(cond), z3.Not(cond), solver_ms)
                if model is not None:
                    second.append((idx, model_overrides(run, model, ov)))
            sl.add(cond)
            continue
        if kind == 'br':
            if (idx in flips and solves < MAX_SOLVES_PER_RUN) or (idx in spread and len(second) < MAX_SPREAD):
                target, after, was_taken = info
                edge = (at, after if was_taken else target)
                model = solve(run, sl.group(cond), z3.Not(cond), solver_ms)
                solves += 1
                if model is not None:
                    if idx in flips:
                        tried[edge] += 1
                        out.append((idx, model_overrides(run, model, ov)))
                    else:
                        rank = wanted[edge].index(idx)
                        tried[('spread', edge, rank if rank < SPREAD_RANKS else 'last')] += 1
                        second.append((idx, model_overrides(run, model, ov)))
            sl.add(cond)
            continue
        _, actual, entries = info
        todo = sorted({v for v in entries.values() if row['va'] <= v < row['va'] + row['body'] and v not in ex and v != actual})
        for t in todo[:8]:
            if tried[('sw', at, t)] >= 8 or solves >= MAX_SOLVES_PER_RUN:
                continue
            model = solve(run, sl.group(cond), cond == z3.BitVecVal(t, 32), solver_ms)
            solves += 1
            if model is not None:
                tried[('sw', at, t)] += 1
                out.append((idx, model_overrides(run, model, ov)))
        sl.add(cond == z3.BitVecVal(actual, 32))
    return out, second


def explore(rowobj, seeds, budget_s=300, max_runs=2000, fresh_seeds=0, check_native=True, log=print, check_self=False, edge_tries=8, solver_ms=4000, variant=0):
    row = rowobj.info
    queue = collections.deque()
    queue2 = []          # secondary children (see `children`): a heap (deepest flip first) and a FIFO of the same children, taken in turn when the primary queue is empty
    queue3 = collections.deque()
    counter = 0
    turn = 0
    seen = set()
    for s in seeds:
        seed, ov = (s, []) if isinstance(s, int) else (s[0], s[1])
        queue.append((seed, [list(o) for o in ov]))
    z3.set_param('smt.random_seed', variant)
    z3.set_param('sat.random_seed', variant)
    for k in range(fresh_seeds):
        queue.append((variant * 1000 + k, []))
    ex, ed = set(), set()
    kept = []
    tried = collections.Counter()
    t0 = time.time()
    runs = 0
    last_gain = 0
    solved = 0
    faults = 0
    mismatch = []
    target_progress = []
    while (queue or queue2 or queue3) and runs < max_runs and time.time() - t0 < budget_s:
        if queue:
            seed, ov = queue.popleft()
        elif turn % 2 == 0 and queue2:
            turn += 1
            _, _, seed, ov = heapq.heappop(queue2)
        elif queue3:
            turn += 1
            seed, ov = queue3.popleft()
        else:
            turn += 1
            _, _, seed, ov = heapq.heappop(queue2)
        key = key_of(seed, ov)
        if key in seen:
            continue
        seen.add(key)
        runs += 1
        if runs - last_gain > STAGNATION_RUNS:          # nothing new for this many runs
            break
        if runs > GIVE_UP_RUNS and not ex:          # not one scenario has run to its end: a row that loops or faults from every start
            break
        tr, run = trace_scenario(rowobj, seed, ov)
        if tr.fault:
            faults += 1
        promising = bool(tr.fault) and not (tr.edges <= ed)
        new_cov = not tr.fault and not (tr.executed <= ex and tr.edges <= ed)
        if new_cov and check_native:
            n = W.run_native(rowobj.native_lib(), row, seed, [tuple(o) for o in ov])
            if n.fault or n.digest() != tr.digest():
                mismatch.append([seed, ov])
                log('  MISMATCH original vs translation on seed %s overrides %s' % (seed, ov))
                new_cov = False
        if new_cov:
            kept.append([seed, ov])
            ex |= tr.executed
            ed |= tr.edges
            last_gain = runs
        got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
        if check_self:
            bad = selfcheck(run)
            if bad is not None:
                at = run.path[bad]
                log('  SELFCHECK path condition %d (%s at %s) not satisfied by the concrete inputs' % (bad, at[0], hex(at[1]) if at[1] else '-'))
        target_progress.append((runs, got, taken))
        if DEBUG:
            log('   run %d seed %s ov %d: fault %s steps %d path %d  cov %d/%d dirs %d/%d queue %d  %.0fs' % (runs, seed, len(ov), tr.fault, run.steps, len(run.path), got, total, taken, dirs, len(queue), time.time() - t0))
        if not untaken and not missing:
            break
        first, second = children(run, ov, ex, ed, tried, promising, row, solver_ms, log)
        for idx, child in first:
            solved += 1
            queue.append((seed, child))
        for idx, child in second:
            counter += 1
            heapq.heappush(queue2, (-idx, counter, seed, child))
            queue3.append((seed, child))          # the later the flipped branch, the more of the path the child keeps: loops are followed turn by turn
    got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
    log('%s runs %d (faults %d) solved %d  instructions %d/%d directions %d/%d kept %d  %.0fs' % (rowobj.key, runs, faults, solved, got, total, taken, dirs, len(kept), time.time() - t0))
    return dict(kept=kept, instructions=(got, total), directions=(taken, dirs), missing=missing, untaken=untaken, mismatch=mismatch, runs=runs, executed=ex, edges=ed)


CMP_DELTAS = (0, 1, -1)
CMP_PER_ADDRESS = 3
CMP_CAP = 90


def compare_children(run, ov, solver_ms):
    """FL-61 boundary goals: for every compare that ran on an input, the model of the path up to it plus `a == b`, `a == b + 1`, `a == b - 1`. A mutant that turns a compare into its
    neighbour (the borrow flipped, a greater-than into greater-or-equal) differs only where the two operands are equal or one apart, which a coverage search never asks for."""
    _var_cache.clear()
    by_index = collections.defaultdict(list)
    count = collections.Counter()
    for idx, at, a, b, s in run.cmps:
        if count[at] < CMP_PER_ADDRESS:
            count[at] += 1
            by_index[idx].append((at, a, b, s))
    sl = Slices()
    out = []

    def goals(idx):
        for at, a, b, s in by_index.get(idx, ()):
            for d in CMP_DELTAS:
                if len(out) >= CMP_CAP:
                    return
                goal = a == (b + z3.BitVecVal(d & MASK[s], 8 * s))
                model = solve(run, sl.group(goal), goal, solver_ms)
                if model is not None:
                    out.append(model_overrides(run, model, ov))
    for idx, (kind, at, cond, info) in enumerate(run.path):
        goals(idx)
        sl.add(cond if kind != 'sw' else cond == z3.BitVecVal(info[1], 32))
    goals(len(run.path))
    return out


def compare_scenarios(rowobj, seeds, budget_s=300, per_seed=CMP_CAP, log=print, solver_ms=3000):
    """Scenarios that make the operands of the row's compares equal or one apart, from the paths of `seeds`; only ones the original runs to the end and the translation agrees on."""
    row = rowobj.info
    t0 = time.time()
    seen = {key_of(*s) for s in seeds}
    kept = []
    queue = collections.deque(seeds)
    generated = 0
    while queue and time.time() - t0 < budget_s:
        seed, ov = queue.popleft()
        tr, run = trace_scenario(rowobj, seed, ov)
        if tr.fault:
            continue
        for child in compare_children(run, ov, solver_ms)[:per_seed]:
            generated += 1
            key = key_of(seed, child)
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
    log('%s compare goals: %d children, %d valid  %.0fs' % (rowobj.key, generated, len(kept), time.time() - t0))
    return kept


def starting_seeds(key):
    pending = json.loads((PROJECT / 'tests/fl40_pending.json').read_text()).get(key, {}).get('seeds', [])
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text()).get(key, {}).get('seeds', [])
    return [tuple(s) if not isinstance(s, int) else (s, []) for s in (pending or corpus)]


def lower_rows():
    """The translated, unverified lower rows (tasks/fl56-translated-unverified.json), smallest first."""
    rows = json.loads((PROJECT / 'tasks/fl56-translated-unverified.json').read_text())['rows']
    return sorted(rows, key=lambda k: (rows[k]['body'], k))


def main():
    global DEBUG
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='*')
    ap.add_argument('--all', action='store_true', help='every translated, unverified lower row')
    ap.add_argument('--shard', default='0/1', help='i/n: every n-th row of the list starting at i')
    ap.add_argument('--budget-s', type=int, default=300)
    ap.add_argument('--max-runs', type=int, default=2000)
    ap.add_argument('--fresh-seeds', type=int, default=8)
    ap.add_argument('--variants', type=int, default=3, help='an incomplete row is searched again this many times with other fresh seeds and solver seeds, its scenarios carried over')
    ap.add_argument('--out', help='JSON {row: scenarios}; rows already in it are skipped')
    ap.add_argument('--report', help='JSON {row: coverage report}')
    ap.add_argument('--skip-reports', default='', help='comma-separated report files: rows they list as complete or skipped are not searched again')
    ap.add_argument('--selfcheck', action='store_true')
    ap.add_argument('--cmp-goals', help='write compare-boundary scenarios of each row (operands equal or one apart) to this JSON instead of searching for coverage')
    ap.add_argument('--cmp-seeds', type=int, default=12, help='with --cmp-goals: how many of the row\'s scenarios to start from')
    ap.add_argument('--debug', action='store_true')
    a = ap.parse_args()
    DEBUG = a.debug
    if DEBUG:
        import faulthandler
        faulthandler.dump_traceback_later(60, repeat=True)
    keys = list(a.rows) or (lower_rows() if a.all else [])
    i, n = map(int, a.shard.split('/'))
    done = set()
    for f in [x for x in a.skip_reports.split(',') if x]:
        for k, v in json.loads(Path(f).read_text()).items():
            if v['status'] == 'complete' or v['status'].startswith('skipped') or v['status'].startswith('setup'):
                done.add(k)
    keys = [k for k in keys if k not in done][i::n]
    if a.cmp_goals:
        res = json.loads(Path(a.cmp_goals).read_text()) if Path(a.cmp_goals).exists() else {}
        for key in keys:
            if key in res:
                continue
            rowobj = Row(key)
            seeds = [tuple(x) for x in starting_seeds(key)][:a.cmp_seeds]
            res[key] = compare_scenarios(rowobj, seeds, budget_s=a.budget_s)
            Path(a.cmp_goals).write_text(json.dumps(res))
        return
    out = json.loads(Path(a.out).read_text()) if a.out and Path(a.out).exists() else {}
    report = json.loads(Path(a.report).read_text()) if a.report and Path(a.report).exists() else {}
    for key in keys:
        if key in out:
            continue
        try:
            rowobj = Row(key)
        except Exception as e:
            print(key, 'cannot be set up:', type(e).__name__, e, flush=True)
            report[key] = {'status': 'setup failed: %s' % type(e).__name__}
            continue
        if rowobj.inline or rowobj.indirect:
            why = 'inline helper' if rowobj.inline else 'indirect calls the lower harness cannot play at %s' % rowobj.indirect[:3]
            print(key, 'skipped:', why, flush=True)
            report[key] = {'status': 'skipped: ' + why}
        else:
            t0 = time.time()
            res = explore(rowobj, starting_seeds(key), budget_s=a.budget_s, max_runs=a.max_runs, fresh_seeds=a.fresh_seeds, check_self=a.selfcheck)
            for variant in range(1, a.variants + 1):
                if not res['missing'] and not res['untaken']:
                    break
                print('  retry %d with other fresh seeds' % variant, flush=True)
                more = explore(rowobj, starting_seeds(key) + [tuple(x) for x in res['kept']], budget_s=a.budget_s, max_runs=a.max_runs, fresh_seeds=a.fresh_seeds, check_self=a.selfcheck, variant=variant)
                res = more
            print('  never run:', ' '.join(hex(x) for x in res['missing']), flush=True)
            print('  untaken:', [(hex(x), n) for x, n in res['untaken']], flush=True)
            print('  unsupported:', dict(Stats.unsupported.most_common(8)), 'errors:', dict(Stats.mismatches.most_common(5)), flush=True)
            out[key] = res['kept']
            report[key] = {'status': 'complete' if not res['missing'] and not res['untaken'] else 'incomplete', 'instructions': list(res['instructions']), 'directions': list(res['directions']),
                           'missing': [hex(x) for x in res['missing']], 'untaken': [[hex(x), d] for x, d in res['untaken']], 'runs': res['runs'], 'scenarios': len(res['kept']),
                           'mismatch': res['mismatch'], 'seconds': round(time.time() - t0)}
        if a.out:
            Path(a.out).write_text(json.dumps(out))
        if a.report:
            Path(a.report).write_text(json.dumps(report, indent=1, sort_keys=True))


if __name__ == '__main__':
    main()
