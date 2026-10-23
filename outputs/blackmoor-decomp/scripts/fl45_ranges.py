#!/usr/bin/env python3
"""FL-45: value ranges of registers and frame slots at every instruction of a function (interval analysis over the ORIGINAL instructions), to explain `width` survivors
of the mutation check.

A `width` mutant narrows a read (`RD32` -> `RD16`, `RD32` -> `RD8`, `RD16` -> `RD8`). Narrowing a read of a frame slot [ebp + k] changes nothing when the bytes that the
narrower read leaves out are zero on every path to the instruction: a 32-bit slot whose value lies in [0, 65535] (resp. [0, 255]) reads the same through 16 (resp. 8) bits,
and a slot whose low 16 bits lie in [0, 255] reads the same through 8 bits. This module computes, for every instruction, an over-approximation of those values:

  * a value is a pair of intervals: the 32-bit value as a SIGNED interval, and the low 16 bits as a signed 16-bit interval (for `ax`, `mov word [slot], ...` and loop counters of type short)
  * locations: the eight registers and the frame slots [ebp + k] (only for a function whose frame cannot be reached by a store through another pointer, the same conditions as
    scripts/fl43_equiv.py: standard prologue, no address of a slot taken, ebp written only by the prologue/epilogue)
  * transfer functions for mov/movzx/movsx/add/sub/inc/dec/and/or/xor/not/neg/shl/shr/sar/imul/lea/cdq/pop; every other instruction sets what it writes to "unknown"; a call sets
    eax, ecx, edx to unknown; a store through another pointer touches no slot (the frame assumption); a store through an indexed frame address forgets every slot
  * conditional jumps after `cmp` refine the compared register or slot on each edge (signed and unsigned conditions), also through a register that is a copy of a slot
  * widening to the constants of the function (and 0, +-1, 255, 65535, ...) after a node was updated a few times; the least fixed point over the CFG

The result is only used as a proof that a narrower read is equivalent; tests/test_fl45_ranges.py checks the analysis against Unicorn traces of the ORIGINAL bytes (every slot and
register it tracks must lie inside its interval at every executed instruction of every corpus seed), which is the soundness test.

  fl45_ranges.py <va> <size> [<instruction address> ...]      print the slot and register intervals before each instruction
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl43_equiv as E

REG_OP, IMM_OP, MEM_OP = E.REG_OP, E.IMM_OP, E.MEM_OP
I32 = (-(1 << 31), (1 << 31) - 1)
I16 = (-(1 << 15), (1 << 15) - 1)
TOP = (I32[0], I32[1], I16[0], I16[1])
GPR = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')
REGS = GPR + ('ebp', 'esp')


def s32(x):
    x &= 0xffffffff
    return x - (1 << 32) if x >= 1 << 31 else x


def s16(x):
    x &= 0xffff
    return x - (1 << 16) if x >= 1 << 15 else x


def norm(f, h=None):
    """a value from a 32-bit interval (and optionally a 16-bit one): the low half follows from the whole when the whole fits in 16 bits"""
    lo, hi = f
    if lo < I32[0] or hi > I32[1] or lo > hi:
        lo, hi = I32
    if h is None or h[0] < I16[0] or h[1] > I16[1] or h[0] > h[1]:
        h = I16
    if I16[0] <= lo and hi <= I16[1]:
        h = (max(h[0], lo), min(h[1], hi)) if (max(h[0], lo) <= min(h[1], hi)) else (lo, hi)
    return (lo, hi, h[0], h[1])


def exact(v):
    v = s32(v)
    return norm((v, v), (s16(v), s16(v)))


def hull(a, b):
    return (min(a[0], b[0]), max(a[1], b[1]), min(a[2], b[2]), max(a[3], b[3]))


def meet(a, b):
    r = (max(a[0], b[0]), min(a[1], b[1]), max(a[2], b[2]), min(a[3], b[3]))
    return r if r[0] <= r[1] and r[2] <= r[3] else None


class State:
    """regs: {name: value}, slots: {offset: value} (absent = unknown), alias: {reg: (kind, slot offset)}, cmp: the last compare (lhs, rhs) or None"""
    __slots__ = ('regs', 'slots', 'alias', 'cmp')

    def __init__(self, regs=None, slots=None, alias=None, cmp=None):
        self.regs, self.slots, self.alias, self.cmp = regs or {}, slots or {}, alias or {}, cmp

    def copy(self):
        return State(dict(self.regs), dict(self.slots), dict(self.alias), self.cmp)

    def key(self):
        return (tuple(sorted(self.regs.items())), tuple(sorted(self.slots.items())), tuple(sorted(self.alias.items())), self.cmp)


def join(a, b, widen=None):
    out = State()
    for d, x, y in ((out.regs, a.regs, b.regs), (out.slots, a.slots, b.slots)):
        for k in set(x) & set(y):
            v = hull(x[k], y[k])
            if widen is not None:
                v = widen(x[k], v)
            if v != TOP:
                d[k] = v
    out.alias = {k: v for k, v in a.alias.items() if b.alias.get(k) == v}
    out.cmp = a.cmp if a.cmp == b.cmp else None
    return out


class TableFunction(E.Function):
    """a Function whose `jmp dword ptr [index*4 + table]` has its table read from the image: the entries are the successors. The entry count is the one the lifter uses
    (scripts/lift_fl41.py): the bound of the last `cmp x, imm; ja/jae` within the 14 instructions before the jump (imm + 1 or imm entries), or, when the index comes from a byte table
    (`mov al, [reg + IDX]`), the largest byte of the first `bound` bytes + 1."""

    def indirect_targets(self, i, k):
        import struct
        op = i.operands[0]
        if op.type != MEM_OP or op.mem.base or not op.mem.index or op.mem.scale != 4:
            raise E.NoProof('indirect jump at 0x%x' % i.address)
        window = self.ins[max(0, k - 14):k]
        index_reg = i.reg_name(op.mem.index)

        def bound_before(upto):
            for q in range(upto - 1, 0, -1):
                if window[q].mnemonic in ('ja', 'jae') and window[q - 1].mnemonic == 'cmp' and window[q - 1].operands[1].type == IMM_OP:
                    return window[q - 1].operands[1].imm + (1 if window[q].mnemonic == 'ja' else 0)
            return None
        count = None
        img = E.L.od.load_image()
        for n, prev in enumerate(window):
            if prev.mnemonic == 'mov' and prev.operands[0].type == REG_OP and prev.reg_name(prev.operands[0].reg) == 'al' and prev.operands[1].type == MEM_OP \
                    and prev.operands[1].size == 1 and not prev.operands[1].mem.index and index_reg == 'eax':
                bound = bound_before(n)
                if bound is not None:
                    base_idx = prev.operands[1].mem.disp & 0xffffffff
                    count = max(img.image[base_idx - img.image_base:][:bound]) + 1
                break
        if count is None:
            count = bound_before(len(window))
        if count is None:
            raise E.NoProof('jump table without a bound at 0x%x' % i.address)
        targets = struct.unpack_from('<%dI' % count, img.image, (op.mem.disp & 0xffffffff) - img.image_base)
        if any(t not in self.at for t in targets):
            raise E.NoProof('jump table leaves the function at 0x%x' % i.address)
        out = []
        for t in targets:
            if t not in out:
                out.append(t)
        return out


class Ranges:
    def __init__(self, va, size):
        self.f = TableFunction(va, size)             # raises NoProof for a function whose frame is not closed
        self.ins = self.f.ins
        self.at = self.f.at
        consts = {0, 1, -1, 255, 256, 65535, 65536, 127, 128, -128, 32767, 32768, -32768, 1 << 31, (1 << 31) - 1}
        for i in self.ins:
            for op in i.operands:
                if op.type == IMM_OP:
                    for d in (-1, 0, 1):
                        consts.add(s32(op.imm + d))
        self.thresholds = sorted(consts)
        self.IN = {}
        self.solve()

    # ---- helpers on operands -------------------------------------------------------------------------------------------------
    def reg_name(self, ins, op):
        return ins.reg_name(op.reg)

    def slot_of(self, ins, op):
        """offset k of a [ebp + k] operand (no index), else None"""
        if op.type != MEM_OP:
            return None
        m = op.mem
        if m.base and ins.reg_name(m.base) == 'ebp' and not m.index and m.segment == 0:
            return m.disp
        return None

    def read32(self, st, ins, op):
        if op.type == IMM_OP:
            return exact(op.imm)
        if op.type == REG_OP:
            n = self.reg_name(ins, op)
            return st.regs.get(n, TOP) if n in REGS else TOP
        k = self.slot_of(ins, op)
        if k is not None and op.size == 4:
            return st.slots.get(k, TOP)
        return TOP

    def read16(self, st, ins, op):
        """signed 16-bit interval of the low half of a 16-bit operand"""
        if op.type == IMM_OP:
            return (s16(op.imm), s16(op.imm))
        if op.type == REG_OP:
            n = self.reg_name(ins, op)
            if n in E.L.SUB16:
                v = st.regs.get(E.L.SUB16[n], TOP)
                return (v[2], v[3])
            if n in REGS:
                v = st.regs.get(n, TOP)
                return (v[2], v[3])
            return I16
        k = self.slot_of(ins, op)
        if k is not None and op.size == 2:
            v = st.slots.get(k, TOP)
            return (v[2], v[3])
        return I16

    def write_reg(self, st, name, v):
        if v == TOP:
            st.regs.pop(name, None)
        else:
            st.regs[name] = v
        st.alias.pop(name, None)

    def write_slot(self, st, k, size, v16=None, v=None):
        """a store of `size` bytes at [ebp + k]; v is the stored value (size 4) or v16 its low half (size 2)"""
        for j in list(st.slots):
            if j != k and j < k + size and k < j + 4:        # another 4-byte slot overlaps the written bytes
                st.slots.pop(j, None)
        old = st.slots.get(k, TOP)
        if size == 4:
            new = v if v is not None else TOP
        elif size == 2:
            new = norm(I32, v16 if v16 is not None else I16)
            new = (I32[0], I32[1], new[2], new[3])
        else:
            new = TOP
        if new == TOP:
            st.slots.pop(k, None)
        else:
            st.slots[k] = new
        for r in [r for r, (kind, j) in st.alias.items() if j < k + size and k < j + 4]:
            del st.alias[r]

    def forget_all_slots(self, st):
        st.slots.clear()
        st.alias.clear()
        st.cmp = None

    # ---- transfer function ---------------------------------------------------------------------------------------------------
    def transfer(self, ins, st0):
        st = st0.copy()
        m = ins.mnemonic
        ops = ins.operands
        rd, wr, wp, frd, fwr, mem, mem_written = E.info(ins)
        cls = E.mem_class(ins, mem)
        if m.startswith('j') or m in ('ret', 'nop'):
            return st
        st.cmp = None                      # the compare only lives until the next instruction (the jump that reads it)
        if m == 'cmp' and len(ops) == 2:
            st.cmp = (self.loc(ins, ops[0]), self.rhs(ins, ops[1]), ops[0].size)
            return st
        if m == 'test':
            return st
        if m == 'call':
            for r in ('eax', 'ecx', 'edx'):
                self.write_reg(st, r, TOP)
            return st
        if m == 'push':
            return st
        if mem_written and cls and cls[0] == 'esp':
            self.forget_all_slots(st)
        if (m == 'mov' and ins.op_str == 'esp, ebp') or m in ('leave', 'pop') and 'ebp' in (ins.op_str or 'ebp'):
            self.forget_all_slots(st)               # the frame is gone: its slots may be overwritten from here on
        dst = ops[0] if ops else None
        handled = False
        if m == 'mov' and len(ops) == 2:
            src = ops[1]
            if dst.type == REG_OP:
                n = self.reg_name(ins, dst)
                if n in REGS:
                    v = self.read32(st, ins, src) if src.type != MEM_OP or self.slot_of(ins, src) is not None else TOP
                    self.write_reg(st, n, v)
                    k = self.slot_of(ins, src) if src.type == MEM_OP else None
                    if k is not None and v != TOP and n not in E.addr_regs(ins, mem):
                        st.alias[n] = ('mov', k)
                    handled = True
                elif n in E.L.SUB16:
                    full = E.L.SUB16[n]
                    h = self.read16(st, ins, src)
                    old = st.regs.get(full, TOP)
                    self.write_reg(st, full, (I32[0], I32[1], h[0], h[1]))
                    handled = True
            elif dst.type == MEM_OP:
                k = self.slot_of(ins, dst)
                if k is not None:
                    if dst.size == 4:
                        self.write_slot(st, k, 4, v=self.read32(st, ins, src))
                    elif dst.size == 2:
                        self.write_slot(st, k, 2, v16=self.read16(st, ins, src))
                    else:
                        self.write_slot(st, k, dst.size)
                    handled = True
        elif m in ('movzx', 'movsx') and len(ops) == 2 and ops[0].type == REG_OP and self.reg_name(ins, ops[0]) in REGS:
            n = self.reg_name(ins, ops[0])
            src = ops[1]
            if src.size == 2:
                h = self.read16(st, ins, src)
                if m == 'movsx' or h[0] >= 0:
                    v = norm(h, h)
                else:
                    v = norm((0, 65535))
            else:
                if m == 'movsx':
                    v = norm((-128, 127))
                else:
                    v = norm((0, 255), (0, 255))
            k = self.slot_of(ins, src) if src.type == MEM_OP else None
            self.write_reg(st, n, v)
            if k is not None and src.size == 2 and n not in E.addr_regs(ins, mem):
                st.alias[n] = ('sx16' if m == 'movsx' else 'zx16', k)
            handled = True
        elif m in ('add', 'sub', 'inc', 'dec', 'and', 'or', 'xor', 'neg', 'not', 'shl', 'shr', 'sar', 'sal', 'imul', 'lea') and ops and not (m == 'imul' and len(ops) == 1) or m in ('cdq', 'cwde'):
            handled = self.arith(st, ins, m, ops)
        elif m == 'pop' and ops and ops[0].type == REG_OP:
            n = self.reg_name(ins, ops[0])
            if n in REGS:
                self.write_reg(st, n, TOP)
                handled = True
        if not handled:
            for r in set(wr) | set(wp):
                if r in REGS:
                    self.write_reg(st, r, TOP)
            if mem_written and cls and cls[0] == 'slot':
                self.write_slot(st, cls[1], cls[2])
            elif mem_written and cls and cls[0] == 'esp':
                self.forget_all_slots(st)
            if m.startswith(E.STRING_OPS):
                for r in ('esi', 'edi', 'ecx'):
                    self.write_reg(st, r, TOP)
        return st

    def loc(self, ins, op):
        if op.type == REG_OP:
            n = self.reg_name(ins, op)
            if n in REGS:
                return ('r', n)
            if n in E.L.SUB16:
                return ('r16', E.L.SUB16[n])
            return None
        k = self.slot_of(ins, op)
        if k is not None:
            return ('s', k, op.size)
        return None

    def rhs(self, ins, op):
        if op.type == IMM_OP:
            return ('imm', s32(op.imm) if op.size == 4 else op.imm)
        return self.loc(ins, op)

    def arith(self, st, ins, m, ops):
        if m in ('cdq', 'cwde'):
            if m == 'cdq':
                v = st.regs.get('eax', TOP)
                self.write_reg(st, 'edx', exact(0) if v[0] >= 0 else exact(-1) if v[1] < 0 else norm((-1, 0)))
            else:
                self.write_reg(st, 'eax', TOP)
            return True
        dst = ops[0]
        if m == 'lea':
            if dst.type != REG_OP or self.reg_name(ins, dst) not in REGS:
                return False
            mm = ops[1].mem
            lo = hi = mm.disp
            ok = mm.segment == 0
            for r, sc in ((mm.base, 1), (mm.index, mm.scale)):
                if r:
                    v = st.regs.get(ins.reg_name(r), TOP)
                    lo += v[0] * sc
                    hi += v[1] * sc
            self.write_reg(st, self.reg_name(ins, dst), norm((lo, hi)) if ok and I32[0] <= lo and hi <= I32[1] else TOP)
            return True
        if dst.type == REG_OP and ins.reg_name(dst.reg) in E.L.SUB16 and dst.size == 2:
            # 16-bit register arithmetic: only the low half is known afterwards
            full = E.L.SUB16[ins.reg_name(dst.reg)]
            h0 = self.read16(st, ins, dst)
            src = self.read16(st, ins, ops[1]) if len(ops) > 1 else (1, 1)
            if m in ('add', 'inc'):
                lo, hi = h0[0] + (src[0] if m == 'add' else 1), h0[1] + (src[1] if m == 'add' else 1)
            elif m in ('sub', 'dec'):
                lo, hi = h0[0] - (src[1] if m == 'sub' else 1), h0[1] - (src[0] if m == 'sub' else 1)
            elif m == 'xor' and ops[1].type == REG_OP and ops[1].reg == dst.reg:
                lo = hi = 0
            else:
                self.write_reg(st, full, TOP)
                return True
            h = (lo, hi) if I16[0] <= lo and hi <= I16[1] else I16
            self.write_reg(st, full, (I32[0], I32[1], h[0], h[1]))
            return True
        a = self.read32(st, ins, dst) if dst.size == 4 and (dst.type == REG_OP or self.slot_of(ins, dst) is not None) else None
        if a is None:
            return False
        if m == 'xor' and len(ops) == 2 and ops[1].type == REG_OP and ops[0].type == REG_OP and ops[0].reg == ops[1].reg:
            res = exact(0)
        else:
            res = self.compute(st, ins, m, ops, a)
        if dst.type == REG_OP:
            n = self.reg_name(ins, dst)
            if n not in REGS:
                return False
            self.write_reg(st, n, res)
        else:
            self.write_slot(st, self.slot_of(ins, dst), 4, v=res)
        return True

    def compute(self, st, ins, m, ops, a):
        def rng(lo, hi):
            return norm((lo, hi)) if I32[0] <= lo and hi <= I32[1] else TOP
        b = None
        if len(ops) > 1 and (ops[1].type == IMM_OP or ops[1].size == 4 and (ops[1].type == REG_OP or self.slot_of(ins, ops[1]) is not None)):
            b = self.read32(st, ins, ops[1])
        if len(ops) == 3 and m == 'imul':
            c = self.read32(st, ins, ops[2])
            b = self.read32(st, ins, ops[1])
            if c[0] == c[1]:
                prods = [b[0] * c[0], b[1] * c[0]]
                return rng(min(prods), max(prods))
            return TOP
        if m == 'inc':
            return rng(a[0] + 1, a[1] + 1)
        if m == 'dec':
            return rng(a[0] - 1, a[1] - 1)
        if m == 'neg':
            return rng(-a[1], -a[0])
        if m == 'not':
            return rng(~a[1], ~a[0])
        if b is None:
            return TOP
        if m == 'add':
            return rng(a[0] + b[0], a[1] + b[1])
        if m == 'sub':
            return rng(a[0] - b[1], a[1] - b[0])
        if m == 'imul':
            prods = [x * y for x in (a[0], a[1]) for y in (b[0], b[1])]
            return rng(min(prods), max(prods))
        if m == 'and':
            if b[0] >= 0 and b[0] == b[1]:
                return rng(0, b[1] if a[0] < 0 else min(a[1], b[1]))
            if a[0] >= 0 and b[0] >= 0:
                return rng(0, min(a[1], b[1]))
            return TOP
        if m in ('or', 'xor'):
            if a[0] >= 0 and b[0] >= 0:
                top = 1
                while top <= max(a[1], b[1]):
                    top <<= 1
                return rng(0, top - 1)
            return TOP
        if m in ('shl', 'sal') and b[0] == b[1] and 0 <= b[0] < 31 and a[0] >= 0:
            return rng(a[0] << b[0], a[1] << b[0])
        if m in ('shr', 'sar') and b[0] == b[1] and 0 < b[0] < 32 and a[0] >= 0:
            return rng(a[0] >> b[0], a[1] >> b[0])
        return TOP

    # ---- edges ---------------------------------------------------------------------------------------------------------------
    def refine(self, ins, st, taken):
        """the state on the edge of conditional jump `ins` (taken or not)"""
        if st.cmp is None:
            return st
        cc = ins.mnemonic[1:]
        base = {'e': 'e', 'z': 'e', 'ne': 'ne', 'nz': 'ne', 'l': 'l', 'nge': 'l', 'le': 'le', 'ng': 'le', 'g': 'g', 'nle': 'g', 'ge': 'ge', 'nl': 'ge',
                'b': 'b', 'c': 'b', 'nae': 'b', 'be': 'be', 'na': 'be', 'a': 'a', 'nbe': 'a', 'ae': 'ae', 'nb': 'ae', 'nc': 'ae'}.get(cc)
        if base is None:
            return st
        neg = {'e': 'ne', 'ne': 'e', 'l': 'ge', 'ge': 'l', 'le': 'g', 'g': 'le', 'b': 'ae', 'ae': 'b', 'be': 'a', 'a': 'be'}
        cond = base if taken else neg[base]
        lhs, rhs, size = st.cmp
        if lhs is None or rhs is None or size not in (2, 4):
            return st
        out = st.copy()
        lv = self.loc_value(out, lhs, size)
        rv = self.rhs_value(out, rhs, size)
        if lv is None or rv is None:
            return st
        top_ = I32 if size == 4 else I16
        unsigned = cond in ('b', 'be', 'a', 'ae')
        lo, hi = lv
        rlo, rhi = rv
        if unsigned and rlo < 0:
            return st                                  # an unsigned bound of 2^31 or more: no refinement
        if cond == 'e':
            nlo, nhi = max(lo, rlo), min(hi, rhi)
        elif cond == 'ne':
            nlo, nhi = lo, hi
            if rlo == rhi:
                if lo == rlo:
                    nlo = lo + 1
                if hi == rlo:
                    nhi = hi - 1
        elif cond in ('l', 'le'):
            nlo, nhi = lo, min(hi, rhi - (1 if cond == 'l' else 0))
        elif cond in ('g', 'ge'):
            nlo, nhi = max(lo, rlo + (1 if cond == 'g' else 0)), hi
        elif cond in ('b', 'be'):                      # unsigned below a bound below 2^31: not a "negative" (huge) value either
            nlo, nhi = max(lo, 0), min(hi, rhi - (1 if cond == 'b' else 0))
        else:                                          # above: only a value already known to be non-negative stays an interval
            if lo < 0:
                return st
            nlo, nhi = max(lo, rlo + (1 if cond == 'a' else 0)), hi
        if nlo > nhi:
            return None                                # the edge cannot be taken
        if (nlo, nhi) == (lo, hi):
            return st
        return self.store_loc(out, lhs, size, (nlo, nhi))

    def loc_value(self, st, loc, size):
        """interval (signed) of the compared operand: the whole value for size 4, the low half for size 2"""
        if loc[0] == 'r':
            v = st.regs.get(loc[1], TOP)
        elif loc[0] == 'r16':
            v = st.regs.get(loc[1], TOP)
            return (v[2], v[3]) if size == 2 else None
        elif loc[0] == 's':
            if loc[2] != size:
                return None
            v = st.slots.get(loc[1], TOP)
        else:
            return None
        return (v[0], v[1]) if size == 4 else (v[2], v[3])

    def rhs_value(self, st, rhs, size):
        if rhs[0] == 'imm':
            return (rhs[1], rhs[1]) if size == 4 else (s16(rhs[1]), s16(rhs[1]))
        return self.loc_value(st, rhs, size)

    def store_loc(self, st, loc, size, rng):
        if loc[0] == 'r':
            v = st.regs.get(loc[1], TOP)
            nv = norm(rng, (v[2], v[3])) if size == 4 else None
            if nv is None:
                return st
            st.regs[loc[1]] = nv
            alias = st.alias.get(loc[1])
            if alias:
                kind, k = alias
                sv = st.slots.get(k, TOP)
                if kind == 'mov':
                    st.slots[k] = norm((max(sv[0], rng[0]), min(sv[1], rng[1])), (sv[2], sv[3]))
                elif kind == 'sx16':
                    st.slots[k] = (sv[0], sv[1], max(sv[2], rng[0]), min(sv[3], rng[1]))
                elif kind == 'zx16' and rng[0] >= 0 and rng[1] <= I16[1]:
                    st.slots[k] = (sv[0], sv[1], max(sv[2], rng[0]), min(sv[3], rng[1]))
        elif loc[0] == 'r16':
            v = st.regs.get(loc[1], TOP)
            nv = (v[0], v[1], max(v[2], rng[0]), min(v[3], rng[1]))
            st.regs[loc[1]] = norm((nv[0], nv[1]), (nv[2], nv[3]))
        elif loc[0] == 's':
            v = st.slots.get(loc[1], TOP)
            st.slots[loc[1]] = norm(rng, (v[2], v[3])) if size == 4 else (v[0], v[1], max(v[2], rng[0]), min(v[3], rng[1]))
        for k in list(st.slots):
            if st.slots[k] == TOP:
                del st.slots[k]
        return st

    # ---- the fixed point -----------------------------------------------------------------------------------------------------
    def widen(self, old, new):
        lo, hi, hlo, hhi = new
        if new[0] < old[0]:
            lo = max([t for t in self.thresholds if t <= new[0]] or [I32[0]])
        if new[1] > old[1]:
            hi = min([t for t in self.thresholds if t >= new[1]] or [I32[1]])
        if new[2] < old[2]:
            hlo = max([t for t in self.thresholds if t <= new[2] and t >= I16[0]] or [I16[0]])
        if new[3] > old[3]:
            hhi = min([t for t in self.thresholds if t >= new[3] and t <= I16[1]] or [I16[1]])
        return (lo, hi, hlo, hhi)

    def solve(self):
        order = self.f.order
        self.feasible = set()                     # (instruction, successor) edges that can be taken
        self.IN = {order[0]: State()}
        count = {a: 0 for a in order}
        work = [order[0]]
        while work:
            a = work.pop(0)
            ins = self.at[a]
            st = self.IN[a]
            out = self.transfer(ins, st)
            succs = list(self.f.succ[a])
            if ins.mnemonic.startswith('rep'):
                succs.append(a)                       # a repeated string instruction runs again on its own result
            for idx, s in enumerate(succs):
                es = out
                if ins.mnemonic.startswith('j') and ins.mnemonic != 'jmp' and len(succs) == 2:
                    es = self.refine(ins, out, taken=(idx == 1))
                elif ins.mnemonic.startswith('j') and ins.mnemonic != 'jmp' and len(succs) == 1:
                    nxt = self.f.order[self.f.order.index(a) + 1] if self.f.order.index(a) + 1 < len(order) else None
                    es = self.refine(ins, out, taken=(s != nxt))
                if es is None:
                    continue
                self.feasible.add((a, s))
                if s not in self.IN:
                    self.IN[s] = es.copy()
                    work.append(s)
                    continue
                count[s] += 1
                new = join(self.IN[s], es, widen=self.widen if count[s] > 4 else None)
                if new.key() != self.IN[s].key():
                    self.IN[s] = new
                    if s not in work:
                        work.append(s)

    # ---- queries -------------------------------------------------------------------------------------------------------------
    def slot_value(self, addr, k):
        """the value of the 4-byte frame slot [ebp + k] before the instruction at `addr`, or None when the instruction is never reached"""
        st = self.IN.get(addr)
        if st is None:
            return None
        return st.slots.get(k, TOP)


def main():
    va, size = int(sys.argv[1], 16), int(sys.argv[2])
    r = Ranges(va, size)
    want = {int(x, 16) for x in sys.argv[3:]}
    for a in r.f.order:
        if want and a not in want:
            continue
        st = r.IN.get(a)
        if st is None:
            print('0x%x unreachable' % a)
            continue
        i = r.at[a]
        print('0x%x %-6s %-28s slots %s regs %s' % (a, i.mnemonic, i.op_str, {hex(k) if k > 0 else -k: v for k, v in sorted(st.slots.items())}, {k: v[:2] for k, v in sorted(st.regs.items())}))


if __name__ == '__main__':
    main()
