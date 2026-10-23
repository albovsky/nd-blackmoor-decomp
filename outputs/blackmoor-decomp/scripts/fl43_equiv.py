#!/usr/bin/env python3
"""FL-43: data-flow proofs that dropping one instruction of a lifted row changes nothing, for the survivors of `drop` mutants of the mutation check.

A `drop` mutant removes the C statement of one x86 instruction. It is an equivalent mutant (the row's behaviour is the same) when, on the control-flow
graph of the ORIGINAL instructions of the row (capstone over the pinned GAME.EXE bytes), one of these holds for that instruction:

  repeat        executing the instruction again is a no-op: the same instruction (same text) already ran on every path to it, or a `mov [slot], reg` stored
                the register to the very slot the instruction loads it from, and since then nothing changed the registers it reads, the register it
                writes or the memory it reads (a forward must-analysis over the paths, meet = intersection; a call or a store through another pointer
                ends the facts about memory that is not a frame slot, a call also ends the facts about eax, ecx and edx)
  dead          every register it writes (as a whole 32-bit register; a partial write also reads the rest) is dead afterwards: on every path the register is
                written as a whole before any instruction reads it; the exits of the function (ret, a jump out) read every register and a call reads every
                register; the flags it writes (if any) are dead the same way. Only instructions that cannot fault: no memory write, no division, memory
                reads only of frame slots [ebp +- k] and of absolute addresses inside the image

Both need a frame whose slots cannot be reached by a store through another pointer: the function starts `push ebp; mov ebp, esp`, takes the address of
no frame slot (no `lea` of ebp/esp, no copy of ebp/esp into a register other than the prologue and epilogue, ebp is not written otherwise) and the
caller's pushed arguments are not aliased by the callee's other pointers (the same assumption scripts/fl41_survivors.py already makes for `same value`).
A function with an indirect jump, a loop instruction, or an address-taken frame gets no proof at all.

  fl43_equiv.py <va> <size> <instruction address> ...      print the proof or the reason there is none
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import lift_fl41 as L

REG_OP, IMM_OP, MEM_OP = 1, 2, 3     # capstone X86_OP_REG, X86_OP_IMM, X86_OP_MEM
ALL = frozenset(('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi', 'ebp', 'esp'))
FULL = {r: r for r in ALL}
FULL.update(L.SUB16)
FULL.update(L.SUB8L)
FULL.update(L.SUB8H)
PURE = {'mov', 'movsx', 'movzx', 'lea', 'add', 'sub', 'and', 'or', 'xor', 'not', 'neg', 'inc', 'dec', 'shl', 'shr', 'sar', 'imul', 'cdq', 'cwde', 'cmp', 'test',
        'sbb', 'adc'}
PARTIAL_FLAGS = {'inc', 'dec', 'shl', 'shr', 'sar', 'sal', 'rol', 'ror', 'rcl', 'rcr', 'stc', 'clc', 'cmc', 'cld', 'std'}      # capstone reports eflags written, but some flags (or all, for a zero count) survive
STRING_OPS = ('movs', 'stos', 'cmps', 'scas', 'lods', 'rep')
IMAGE_END = 0x400000 + 0x1000000


class NoProof(Exception):
    pass


def info(ins):
    """(registers read, registers written whole, registers written in part, flags read, flags written, memory operand or None, memory written)"""
    reads, writes = ins.regs_access()
    rd, wr_whole, wr_part = set(), set(), set()
    flags_rd = flags_wr = False
    for r in reads:
        n = ins.reg_name(r)
        if n == 'eflags':
            flags_rd = True
        elif n in FULL:
            rd.add(FULL[n])
    for r in writes:
        n = ins.reg_name(r)
        if n == 'eflags':
            flags_wr = True
        elif n in ALL:
            wr_whole.add(n)
        elif n in FULL:
            wr_part.add(FULL[n])
    mem, mem_written = None, False
    for op in ins.operands:
        if op.type == MEM_OP and ins.mnemonic != 'lea':
            mem = op
            mem_written = bool(op.access & 2)
    if ins.mnemonic.startswith('cmov') and ins.operands and ins.operands[0].type == REG_OP:
        rd.add(FULL[ins.reg_name(ins.operands[0].reg)])          # a conditional move keeps the old value when the condition fails
    if ins.mnemonic in ('xor', 'sub') and len(ins.operands) == 2 and ins.operands[0].type == REG_OP and ins.operands[1].type == REG_OP \
            and ins.operands[0].reg == ins.operands[1].reg:
        rd.discard(FULL[ins.reg_name(ins.operands[0].reg)])
    return rd, wr_whole, wr_part, flags_rd, flags_wr, mem, mem_written


def addr_regs(ins, mem):
    names = set()
    if mem is not None:
        if mem.mem.base:
            names.add(FULL[ins.reg_name(mem.mem.base)])
        if mem.mem.index:
            names.add(FULL[ins.reg_name(mem.mem.index)])
    return names


def mem_class(ins, mem):
    """('slot', offset, size) for [ebp + k], ('abs', address, size) for an absolute address inside the image, ('esp',) for an esp-based address, else ('other',)"""
    if mem is None:
        return None
    base = ins.reg_name(mem.mem.base) if mem.mem.base else None
    index = ins.reg_name(mem.mem.index) if mem.mem.index else None
    if base == 'ebp' and not index:
        return ('slot', mem.mem.disp, mem.size)
    if base == 'ebp' or index == 'ebp':
        return ('esp',)                      # an indexed frame address (a local array): it can reach any slot, so a store through it ends every fact
    if not base and not index and 0x400000 <= (mem.mem.disp & 0xffffffff) < IMAGE_END:
        return ('abs', mem.mem.disp & 0xffffffff, mem.size)
    if base == 'esp' or index == 'esp':
        return ('esp',)
    return ('other',)


def overlap(a, b):
    return a[0] == b[0] and a[1] < b[1] + b[2] and b[1] < a[1] + a[2]


class Function:
    feasible = None      # FL-45: the set of (instruction, successor) edges that the interval analysis (scripts/fl45_ranges.py) shows can be taken; None = every edge

    def __init__(self, va, size, feasible=None):
        self.feasible = feasible
        self.va, self.size = va, size
        self.ins = L.disasm(va, size)
        self.at = {i.address: i for i in self.ins}
        self.order = [i.address for i in self.ins]
        self.succ, self.exits = {}, set()
        for k, i in enumerate(self.ins):
            nxt = self.order[k + 1] if k + 1 < len(self.order) else None
            m = i.mnemonic
            if m == 'ret':
                self.exits.add(i.address)
                self.succ[i.address] = []
            elif m == 'jmp' or m.startswith('j'):
                op = i.operands[0]
                if op.type != IMM_OP:
                    self.succ[i.address] = self.indirect_targets(i, k)       # FL-45: a subclass may know the targets of a jump table; the default gives no proof
                    continue
                s = [] if m == 'jmp' or not nxt else [nxt]
                if op.imm in self.at:
                    s.append(op.imm)
                else:
                    self.exits.add(i.address)
                self.succ[i.address] = s
            elif m in ('cmpxchg', 'xlatb', 'xlat', 'xadd', 'cmpxchg8b') or m.startswith('f') and m not in ('fs',) or (m.startswith('set') and any(op.type == MEM_OP for op in i.operands)):
                raise NoProof('instruction %s at 0x%x is not modelled' % (m, i.address))
            elif m in ('loop', 'loope', 'loopne'):
                raise NoProof('loop instruction at 0x%x' % i.address)
            else:
                self.succ[i.address] = [nxt] if nxt else []
                if not nxt:
                    self.exits.add(i.address)
        self._check_frame()

    def indirect_targets(self, i, k):
        raise NoProof('indirect jump at 0x%x' % i.address)

    def _check_frame(self):
        ins = self.ins
        if len(ins) < 2 or not (ins[0].mnemonic == 'push' and ins[0].op_str == 'ebp' and ins[1].mnemonic == 'mov' and ins[1].op_str == 'ebp, esp'):
            raise NoProof('no standard prologue')
        for k, i in enumerate(ins[2:], 2):
            m = i.mnemonic
            rd, wr, wp, _, _, mem, _ = info(i)
            if m == 'lea':
                for op in i.operands:
                    if op.type == MEM_OP and op.mem.base and i.reg_name(op.mem.base) in ('ebp', 'esp'):
                        raise NoProof('address of a frame slot taken at 0x%x' % i.address)
                    if op.type == MEM_OP and op.mem.index and i.reg_name(op.mem.index) in ('ebp', 'esp'):
                        raise NoProof('address of a frame slot taken at 0x%x' % i.address)
            regops = [i.reg_name(op.reg) for op in i.operands if op.type == REG_OP]
            if m == 'push' and regops and regops[0] in ('ebp', 'esp'):
                raise NoProof('ebp/esp pushed at 0x%x' % i.address)
            if m in ('mov', 'xchg', 'add', 'sub', 'and', 'or', 'xor', 'adc', 'sbb', 'imul', 'movzx', 'movsx') and any(n in ('ebp', 'esp') for n in regops):
                ok = (m == 'mov' and i.op_str in ('esp, ebp', 'ebp, esp')) or \
                    (m in ('add', 'sub') and regops == ['esp'] and i.operands[1].type == IMM_OP)
                if not ok:
                    raise NoProof('ebp/esp used as a value at 0x%x: %s %s' % (i.address, m, i.op_str))
            if ('ebp' in wr or 'ebp' in wp) and not (m in ('pop', 'leave') or i.op_str == 'ebp, esp'):
                raise NoProof('ebp written at 0x%x' % i.address)

    # ---- forward must-analysis: instructions whose repetition is a no-op ----
    def facts(self):
        IN = {a: None for a in self.order}     # None = not reached yet (top)
        IN[self.order[0]] = frozenset()
        work = list(self.order)
        while work:
            a = work.pop(0)
            if IN[a] is None:
                continue
            new = self.transfer(self.at[a], IN[a])
            for s in self.succ[a]:
                if self.feasible is not None and (a, s) not in self.feasible:
                    continue
                merged = new if IN[s] is None else IN[s] & new
                if merged != IN[s]:
                    IN[s] = merged
                    if s not in work:
                        work.append(s)
        return IN

    def transfer(self, i, facts):
        rd, wr, wp, _, _, mem, mem_written = info(i)
        cls = mem_class(i, mem)
        m = i.mnemonic
        gone = set(wr) | set(wp)
        kill_other = kill_abs = False            # memory reached through a register; memory at an absolute address
        if m == 'call':
            gone |= {'eax', 'ecx', 'edx'}
            kill_other = kill_abs = True
        if m.startswith(STRING_OPS):
            kill_other = kill_abs = True
        if mem_written and cls:
            if cls[0] == 'esp':
                return frozenset()
            if cls[0] == 'other':
                kill_other = kill_abs = True
            elif cls[0] == 'abs':
                kill_other = True                # an absolute store may be what a register-based address points at; other absolute addresses are untouched unless they overlap
        out = set()
        for sig, defreg, inputs, mcls in facts:
            if defreg in gone or inputs & gone:
                continue
            if mcls is not None:
                if mcls[0] == 'other' and kill_other or mcls[0] == 'abs' and kill_abs:
                    continue
                if mem_written and cls and cls[0] in ('slot', 'abs') and mcls[0] == cls[0] and overlap(cls, mcls):
                    continue
            out.add((sig, defreg, inputs, mcls))
        if m in ('mov', 'movsx', 'movzx', 'lea') and not mem_written and len(i.operands) == 2 and i.operands[0].type == REG_OP \
                and i.reg_name(i.operands[0].reg) in ALL:
            d = i.reg_name(i.operands[0].reg)
            if d not in rd and (cls is None or cls[0] != 'esp'):
                out.add(((m, i.op_str), d, frozenset(rd), cls))
        if m == 'mov' and mem_written and cls and cls[0] in ('slot', 'abs') and len(i.operands) == 2 and i.operands[1].type == REG_OP and cls[2] == 4:
            r = i.reg_name(i.operands[1].reg)
            if r in ALL:
                out.add((('mov', '%s, %s' % (r, i.op_str.split(', ')[0])), r, frozenset(addr_regs(i, mem)), cls))
        return frozenset(out)

    def repeat_ok(self, addr, IN):
        i = self.at[addr]
        if IN[addr] is None:
            return False
        rd, wr, wp, _, flags_wr, mem, mem_written = info(i)
        if mem_written or flags_wr or i.mnemonic not in ('mov', 'movsx', 'movzx', 'lea') or len(i.operands) != 2:
            return False
        if i.operands[0].type != REG_OP or i.reg_name(i.operands[0].reg) not in ALL:
            return False
        d = i.reg_name(i.operands[0].reg)
        return any(f[0] == (i.mnemonic, i.op_str) and f[1] == d for f in IN[addr])

    # ---- backward liveness of registers and flags ----
    def liveness(self):
        live_in = {a: frozenset() for a in self.order}
        flags_in = {a: False for a in self.order}
        changed = True
        while changed:
            changed = False
            for a in reversed(self.order):
                i = self.at[a]
                out, fout = self.live_out(a, live_in, flags_in)
                rd, wr, wp, frd, fwr, _, _ = info(i)
                if i.mnemonic == 'call':
                    new, nf = frozenset(out | ALL), fout
                else:
                    new, nf = frozenset((out - wr) | rd | wp), (fout and not (fwr and i.mnemonic not in PARTIAL_FLAGS)) or frd
                if new != live_in[a] or nf != flags_in[a]:
                    live_in[a], flags_in[a] = new, nf
                    changed = True
        return {a: self.live_out(a, live_in, flags_in) for a in self.order}

    def live_out(self, a, live_in, flags_in):
        out, fout = set(), False
        for s in self.succ[a]:
            if self.feasible is not None and (a, s) not in self.feasible:
                continue
            out |= live_in[s]
            fout = fout or flags_in[s]
        if a in self.exits:
            out |= ALL
        return frozenset(out), fout

    def dead_ok(self, addr, out_state):
        i = self.at[addr]
        rd, wr, wp, frd, fwr, mem, mem_written = info(i)
        if i.mnemonic not in PURE or mem_written:
            return False
        cls = mem_class(i, mem)
        if cls is not None and cls[0] not in ('slot', 'abs'):
            return False
        live, flive = out_state[addr]
        if (wr | wp) & live or (fwr and flive):
            return False
        return bool(wr or wp or fwr)


def prove(va, size, addrs, feasible=None, factory=None):
    """{instruction address: reason, or None when there is no proof}; raises NoProof for a function the analysis does not cover"""
    f = (factory or Function)(va, size, feasible)
    IN = f.facts()
    live = f.liveness()
    res = {}
    for a in addrs:
        if a not in f.at:
            res[a] = None
        elif f.repeat_ok(a, IN):
            res[a] = 'repeat: the register already holds this value on every path to 0x%x' % a
        elif f.dead_ok(a, live):
            res[a] = 'dead: every register and flag it writes is overwritten before it is read on every path from 0x%x' % a
        else:
            res[a] = None
    return res


def main():
    va, size = int(sys.argv[1], 16), int(sys.argv[2])
    addrs = [int(x, 16) for x in sys.argv[3:]]
    try:
        for a, r in prove(va, size, addrs).items():
            print('0x%x: %s' % (a, r or 'no proof'))
    except NoProof as e:
        print('no proof for the function: %s' % e)


if __name__ == '__main__':
    main()
