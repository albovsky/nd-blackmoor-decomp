#!/usr/bin/env python3
"""FL-78 (round 12): the x87 constant chain rule of the infeasibility prover (scripts/fl67_infeasible.py prove_row).

A function that starts `push ebp; mov ebp, esp; sub esp, K` and then runs a straight line of x87 instructions on doubles of the immutable image (`fld qword [constant address]`), stores them in locals of its own frame
(`fstp qword [ebp+d]`, read back by `fld qword [ebp+d]`) and combines them (`fdiv`, `fdivr`, `fmul`, `fadd`, `fsub`, `fsubr` with a qword operand), compares the result with an image constant (`fcom` / `fcomp qword`),
and reads the answer with `fnstsw ax; sahf` into a conditional jump, has a result that does not depend on the start state except through the x87 control word: precision control (24, 53 or 64 bit significand) and rounding
control (nearest, down, up, toward zero). The rule evaluates the chain exactly (rational arithmetic) with every rounding done by z3's floating point (`fpRealToFP` into the 15-bit-exponent format of the precision, `fpToFP` into the
double of a store) for each of the 3 x 4 control word values, derives CF / ZF / PF the compare leaves, and decides the jump. A direction that none of the 12 combinations takes is unreachable, and so is every instruction that
only that direction leads to. Assumptions (RULE_TEXT2, `x87-constant-chain`): the precision field of the entry control word is not the reserved value 1; an exception that the control word leaves unmasked stops the run before
the jump (so it is not a run that reaches it); the x87 stack has room for the values the chain pushes (no overflow); the FPU has no FDIV erratum; every value is finite and not subnormal (checked); the chain is entered only from its top (checked: no jump, call or loop of the function targets [entry, the jcc] and there is no indirect jump or call) and leaves the x87 stack empty (checked); the image below .data is constant.
"""
import hashlib
from fractions import Fraction
import struct

import z3
from capstone import x86_const as X

IMAGE_BASE = 0x400000
DATA_START = 0x537000
PRECISIONS = (24, 53, 64)                                  # the significand bits of PC = 0, 2, 3 (PC = 1 is reserved and not modelled)
ROUNDINGS = (('nearest', z3.RNE), ('down', z3.RTN), ('up', z3.RTP), ('zero', z3.RTZ))         # RC = 0, 1, 2, 3
DOUBLE = z3.FPSort(11, 53)
MAX_STACK = 7
# the conditions of the jumps that read only what `sahf` loads from a compare (CF = C0, PF = C2, ZF = C3)
COND = {'ja': lambda c, p, z: not c and not z, 'jae': lambda c, p, z: not c, 'jb': lambda c, p, z: c, 'jbe': lambda c, p, z: c or z, 'je': lambda c, p, z: z, 'jne': lambda c, p, z: not z,
        'jp': lambda c, p, z: p, 'jnp': lambda c, p, z: not p}


class Refused(Exception):
    pass


def _round(rm, value, sort):
    """the Fraction that z3's floating point makes of the rational `value` in `sort` (one rounding, mode rm); finite and not subnormal, else Refused"""
    r = z3.simplify(z3.fpRealToFP(rm(), z3.RealVal('%d/%d' % (value.numerator, value.denominator)), sort))
    if not (z3.is_fp_value(r) and z3.is_false(z3.simplify(z3.Or(z3.fpIsNaN(r), z3.fpIsInf(r), z3.fpIsSubnormal(r))))):
        raise Refused('a value is not finite and normal')
    back = z3.simplify(z3.fpToReal(r))
    return Fraction(back.numerator_as_long(), back.denominator_as_long())


def _double_const(image, address):
    if not (IMAGE_BASE <= address and address + 8 <= DATA_START):
        raise Refused('operand not in the constant image')
    bits = int.from_bytes(image[address - IMAGE_BASE:address - IMAGE_BASE + 8], 'little')
    f = struct.unpack('<d', struct.pack('<Q', bits))[0]
    if f != f or f in (float('inf'), -float('inf')) or (f != 0 and abs(f) < 2.2250738585072014e-308):
        raise Refused('constant is not finite and normal')
    return Fraction(f)


def _mem(i):
    op = i.operands[0]
    if op.type != X.X86_OP_MEM or op.size != 8 or op.mem.segment not in (0, X.X86_REG_DS) or op.mem.index:
        raise Refused('operand')
    return op.mem


def chain(insns, image):
    """(index of the conditional jump, jcc mnemonic, {(pc, rc name): taken?}) for a function that starts with the chain; raises Refused"""
    if len(insns) < 8 or [(i.mnemonic, i.op_str.replace(' ', '')) for i in insns[:2]] != [('push', 'ebp'), ('mov', 'ebp,esp')] or insns[2].mnemonic != 'sub' or insns[2].op_str.split(',')[0].strip() != 'esp' \
            or insns[2].operands[1].type != X.X86_OP_IMM:
        raise Refused('no prologue')
    local = insns[2].operands[1].imm
    steps, k = [], 3
    while k < len(insns):
        i = insns[k]
        m = i.mnemonic
        if m.startswith('j') and m in COND:
            break
        if m in ('fld', 'fstp', 'fdiv', 'fdivr', 'fmul', 'fadd', 'fsub', 'fsubr', 'fcom', 'fcomp'):
            mem = _mem(i)
            if mem.base == 0 and mem.disp >= 0:
                steps.append((m, 'abs', mem.disp & 0xffffffff))
            elif mem.base == X.X86_REG_EBP and mem.disp < 0 and mem.disp >= -local and mem.disp + 8 <= 0:
                steps.append((m, 'ebp', mem.disp))
            else:
                raise Refused('operand address')
        elif (m == 'fnstsw' and i.op_str == 'ax') or m == 'sahf':
            steps.append((m, None, None))
        else:
            raise Refused('instruction %s in the chain' % m)
        k += 1
    else:
        raise Refused('no jump')
    if [s[0] for s in steps[-3:]] not in (['fcomp', 'fnstsw', 'sahf'], ['fcom', 'fnstsw', 'sahf']) or steps[-2][2] is not None or len(steps) < 3:
        raise Refused('no compare in front of the jump')
    if i.mnemonic == 'jecxz':
        raise Refused('jump')
    _single_entry(insns, k)
    out = {}
    for pc in PRECISIONS:
        for rc, rm in ROUNDINGS:
            out[(pc, rc)] = _run(steps, image, pc, rm)
    return k, i.mnemonic, out


def _single_entry(insns, k):
    """the chain, the instructions from the entry up to and including the conditional jump at index k, is entered only from the top: no direct jump, conditional jump, loop or call of the function targets an address in
    [entry, jump], and the function has no indirect jump or call (whose target is unknown and may be anywhere); else Refused"""
    lo, hi = insns[0].address, insns[k].address
    for i in insns:
        m = i.mnemonic
        if not (m.startswith('j') or m.startswith('loop') or m == 'call'):
            continue
        if not i.operands or i.operands[0].type != X.X86_OP_IMM:
            raise Refused('indirect jump or call')
        if lo <= i.operands[0].imm <= hi:
            raise Refused('a jump or call into the chain')


def _run(steps, image, pc, rm):
    ext = z3.FPSort(15, pc)
    st, slots, flags = [], {}, None
    for m, kind, a in steps:
        if m == 'fld':
            v = _double_const(image, a) if kind == 'abs' else slots.get(a)
            if v is None:
                raise Refused('a local is read before it is stored')
            st.insert(0, v)
            if len(st) > MAX_STACK:
                raise Refused('stack')
        elif m == 'fstp':
            if kind != 'ebp' or not st:
                raise Refused('store')
            for o in slots:
                if o != a and o < a + 8 and a < o + 8:
                    raise Refused('overlapping locals')
            slots[a] = _round(rm, st.pop(0), DOUBLE)            # the store rounds the extended value to a double (rounding control)
        elif m in ('fdiv', 'fdivr', 'fmul', 'fadd', 'fsub', 'fsubr'):
            if not st:
                raise Refused('empty stack')
            op = _double_const(image, a) if kind == 'abs' else slots.get(a)
            if op is None:
                raise Refused('a local is read before it is stored')
            x = st[0]
            if m in ('fdiv', 'fdivr') and (x == 0 if m == 'fdivr' else op == 0):
                raise Refused('division by zero')
            r = {'fdiv': lambda: x / op, 'fdivr': lambda: op / x, 'fmul': lambda: x * op, 'fadd': lambda: x + op, 'fsub': lambda: x - op, 'fsubr': lambda: op - x}[m]()
            st[0] = _round(rm, r, ext) if r != 0 else r          # one rounding of the exact result to the precision (z3 floating point)
        elif m in ('fcom', 'fcomp'):
            if not st:
                raise Refused('empty stack')
            op = _double_const(image, a) if kind == 'abs' else slots.get(a)
            if op is None:
                raise Refused('a local is read before it is stored')
            x = st[0]
            flags = (x < op, False, x == op)                    # C0 (CF), C2 (PF: unordered, never for finite values), C3 (ZF)
            if m == 'fcomp':
                st.pop(0)
        elif m in ('fnstsw', 'sahf'):
            if flags is None:
                raise Refused('status word read before a compare')
    if st:
        raise Refused('the x87 stack is not empty after the compare')
    return flags


def analyse(row, image):
    """the chain of the row's function: (jcc address, mnemonic, {combination: (cf, pf, zf)}, taken outcomes) or None when the rule does not apply"""
    import fl67_infeasible as P
    _, insns = P.disassemble(image, row['va'], row['body'])
    try:
        k, mn, flags = chain(insns, image)
    except Refused:
        return None
    taken = {c: COND[mn](*f) for c, f in flags.items()}
    return insns, k, mn, flags, taken


def _reachable(insns, skip_edge):
    """addresses that a run can reach from the entry when the edge (jcc address, 'taken' | 'fall-through') is not taken; None when the function has a jump this walk does not follow"""
    by = {i.address: n for n, i in enumerate(insns)}
    seen, work = set(), [0]
    while work:
        n = work.pop()
        if n in seen or n >= len(insns):
            continue
        seen.add(n)
        i = insns[n]
        m = i.mnemonic
        if m in ('ret', 'retn'):
            continue
        if m == 'jmp':
            if i.operands[0].type != X.X86_OP_IMM:
                return None
            if i.operands[0].imm in by:
                work.append(by[i.operands[0].imm])
            continue
        if m.startswith('j') or m.startswith('loop'):
            if i.operands[0].type != X.X86_OP_IMM or i.operands[0].imm not in by:
                return None
            if (i.address, 'taken') != skip_edge:
                work.append(by[i.operands[0].imm])
            if (i.address, 'fall-through') != skip_edge:
                work.append(n + 1)
            continue
        work.append(n + 1)
    return {insns[n].address for n in seen}


def prove(row, image, todo):
    """({'instructions': {hex address: ['unsat', hash]}, 'directions': {'hex:name': ['unsat', hash]}}, text of the assumption) for the targets of `todo` that the chain rule proves unreachable; ({}, None) when it does not apply"""
    got = analyse(row, image)
    if got is None:
        return {'instructions': {}, 'directions': {}}
    insns, k, mn, flags, taken = got
    jcc = insns[k].address
    values = set(taken.values())
    if len(values) != 1:
        return {'instructions': {}, 'directions': {}}
    never = 'fall-through' if values == {True} else 'taken'          # the direction that none of the 12 control word values takes
    digest = hashlib.sha256(repr(sorted(flags.items())).encode()).hexdigest()
    out = {'instructions': {}, 'directions': {}}
    for a, n in todo['untaken']:
        if a == jcc and n == never:
            out['directions']['%s:%s' % (hex(a), n)] = ['unsat', digest]
    reach = _reachable(insns, (jcc, never))
    if reach is not None:
        for a in todo['missing']:
            if a not in reach:
                out['instructions'][hex(a)] = ['unsat', digest]
    return out
