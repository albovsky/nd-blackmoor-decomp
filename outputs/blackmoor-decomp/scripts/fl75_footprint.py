#!/usr/bin/env python3
"""FL-75: which frame addresses a callee can write, proved from the callee's own bytes (support for scripts/fl67_infeasible.py).

The FL-67 frame assumption (module text there) keeps the stack frame of a function out of reach of stores through other pointers, but only for a function that never hands out an address of its frame. A
function that passes `lea eax, [ebp - 0x18]; push eax; call C` (an out-parameter) lost it altogether, although C writes only the two dwords it is given. This module checks that claim on C's bytes:

  `callee_footprint(image, C)` returns (lo, hi) when ALL of this holds, else None:
    * C starts `push ebp; mov ebp, esp` and uses ebp and esp only in the standard ways (frame setup and teardown, `add/sub esp, imm`, push/pop, call, ret, leave);
    * the pointer argument is read only as `mov reg, [ebp + 8]`; no other instruction touches the bytes of the argument slot, and no indexed or esp-based memory operand and no `lea` of an address at or above
      ebp+0 exists (so C never forms a pointer to its argument slot or to its caller's frame);
    * the register that holds the pointer (and nothing made from it) is used only as the base of a store `mov/fst/fstp/... [reg + disp], x` (a store of a different, untainted value) or of a load; it is never
      copied, pushed, added to, compared, stored, passed, or still held at a `ret`;
    * the control flow is direct (no computed jump), and the code that is reachable from the entry is at most 3000 instructions.
  The stores through the pointer span bytes [pointer + lo, pointer + hi). Every other write C makes is to its own frame, to memory reached through other pointers (which cannot point into the caller's frame:
    the caller has formed no other frame address) or through callees that were given no frame pointer.

`call_footprints(analysis_insns, image, is_leader)` finds, in a caller, the escapes of the form `lea R, [ebp - K]` (R is eax, ecx or edx), then `push R` as the LAST push before a direct `call C`, with only
instructions in between that neither read nor write R, push, pop, jump or call, and no jump target between the lea and the call; it returns ({lea address: call address}, {call address: (disp, lo, hi, registers that may hold the pointer after the call)})
for those whose C passes `callee_footprint`. The prover uses the pair so that such a function keeps the frame assumption, and the call havocs only [ebp + disp + lo, ebp + disp + hi) of the frame (and the pushed
argument slots).
"""
import capstone
from capstone import x86_const as X

IMAGE_BASE = 0x400000
DATA_START = 0x537000
LIMIT = 3000
DEBUG = False
GP = ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')
STORES = {'mov', 'fst', 'fstp', 'fist', 'fistp', 'fisttp', 'movss'}
SUB = {}
for _f in GP:
    SUB[_f] = _f
    SUB[_f[1:]] = _f
for _f, _l in (('eax', 'a'), ('ecx', 'c'), ('edx', 'd'), ('ebx', 'b')):
    SUB[_l + 'l'] = _f
    SUB[_l + 'h'] = _f
FULL32 = set(GP)


def _decode(md, image, addr):
    off = addr - IMAGE_BASE
    if not (0 <= off < DATA_START - IMAGE_BASE):
        return None
    out = list(md.disasm(image[off:off + 16], addr, 1))
    return out[0] if out else None


def _regs(ins):
    """(read, write) as sets of 32-bit register names (sub-registers folded in; partial writes are reported in `partial`)"""
    rd, wr = ins.regs_access()
    names = lambda ids: {SUB[ins.reg_name(r)] for r in ids if ins.reg_name(r) in SUB}
    full = {ins.reg_name(r) for r in wr if ins.reg_name(r) in FULL32}
    return names(rd), names(wr), full


def _frame_ok(ins):
    """the callee uses ebp / esp only in the standard ways: push/pop ebp, mov ebp, esp / mov esp, ebp, add or sub esp with an immediate, push/pop/call/ret/leave (their implicit esp use), and as the base of a memory operand"""
    m = ins.mnemonic
    ops = ins.operands
    _, wr, _ = _regs(ins)
    regs = [ins.reg_name(o.reg) for o in ops if o.type == X.X86_OP_REG]
    if m in ('call', 'ret', 'retn', 'leave'):
        return not any(r in ('ebp', 'esp') for r in regs)
    if m == 'push':
        return all(r != 'esp' for r in regs)
    if m == 'pop':
        return all(r != 'esp' for r in regs)
    if not any(r in ('ebp', 'esp') for r in regs):
        return not ({'ebp', 'esp'} & wr)
    if m == 'mov' and len(ops) == 2 and all(o.type == X.X86_OP_REG for o in ops):
        return regs in (['ebp', 'esp'], ['esp', 'ebp'])
    if m in ('add', 'sub') and regs == ['esp'] and ops[1].type == X.X86_OP_IMM:
        return True
    return False


def why(k, loc):
    if DEBUG:
        i = loc.get('ins')
        print('callee_footprint rejects at site', k, hex(i.address) if i else None, i.mnemonic + ' ' + i.op_str if i else '')
    return None


def callee_footprint(image, addr, entry=frozenset()):
    """(lo, hi): the callee writes only bytes [p+lo, p+hi) of the memory its pointer argument p addresses (see callee_summary), or None"""
    out = callee_summary(image, addr, entry)
    return out[:2] if out else None


def callee_summary(image, addr, entry=frozenset()):
    """(lo, hi, regs) as callee_footprint, plus the set of eax / ecx / edx that hold exactly p at some `ret` (a callee that returns its struct pointer in eax); None when the callee passes no check.
    A register that holds p at a ret is not unrelated to the caller's frame, so the caller's call model must not make it a fresh value (Machine.call).
    `entry` names the registers that still hold p when the callee starts (the register of the caller's `lea R, [ebp+disp]; push R`, which the call does not clear): they start tainted, so a store through one counts in the footprint and a copy of one is refused."""
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    first = _decode(md, image, addr)
    second = _decode(md, image, addr + first.size) if first else None
    if not (first and second and first.mnemonic == 'push' and first.op_str == 'ebp' and second.mnemonic == 'mov' and second.op_str == 'ebp, esp'):
        return why(1, locals())
    state = {}                       # address -> frozenset of tainted registers (union over the paths that reach it)
    work = [(addr + first.size + second.size, frozenset(entry))]
    lo, hi = None, None
    rets = set()
    steps = 0
    while work:
        a, T = work.pop()
        if a in state and T <= state[a]:
            continue
        state[a] = state.get(a, frozenset()) | T
        T = state[a]
        steps += 1
        if steps > LIMIT * 8 or len(state) > LIMIT:
            return why(2, locals())
        ins = _decode(md, image, a)
        if ins is None:
            return why(3, locals())
        m = ins.mnemonic
        ops = ins.operands
        rd, wr, full = _regs(ins)
        if not _frame_ok(ins):
            return why(4, locals())
        # memory operands: no esp-based or indexed ebp-based operand, nothing that reaches the argument slot or above (except the one source form)
        src_form = (m == 'mov' and len(ops) == 2 and ops[0].type == X.X86_OP_REG and ins.reg_name(ops[0].reg) in FULL32 and ops[1].type == X.X86_OP_MEM
                    and ops[1].size == 4 and ins.reg_name(ops[1].mem.base) == 'ebp' and not ops[1].mem.index and ops[1].mem.disp == 8 and ops[1].mem.segment == 0)
        for o in ops:
            if o.type != X.X86_OP_MEM:
                continue
            base = ins.reg_name(o.mem.base) if o.mem.base else None
            index = ins.reg_name(o.mem.index) if o.mem.index else None
            if base == 'esp' or index in ('esp', 'ebp') or (base == 'ebp' and index):
                return why(5, locals())
            if base == 'ebp' and m != 'lea' and o.mem.disp + o.size > 8 and o.mem.disp < 12 and not src_form:
                return why(6, locals())                                          # overlaps the argument slot [ebp+8, ebp+12)
        if m == 'lea':
            mem = ops[1].mem
            if mem.base and ins.reg_name(mem.base) in ('ebp', 'esp') and (ins.reg_name(mem.base) == 'esp' or mem.disp >= 0):
                return why(7, locals())
            if mem.index and ins.reg_name(mem.index) in ('ebp', 'esp'):
                return why(8, locals())
        if m in ('ret', 'retn'):
            if T & {'ebx', 'esi', 'edi'}:
                return why(9, locals())                                    # a callee-saved register that still holds the pointer
            rets |= T                                                      # eax / ecx / edx holding the pointer: reported, the caller models them as possibly the frame address
            continue
        if m in ('int3', 'hlt', 'ud2', 'int', 'iret') or m.startswith('loop'):
            if m.startswith('loop'):
                return why(10, locals())
            continue
        if m == 'jmp':
            if ops[0].type != X.X86_OP_IMM:
                return why(11, locals())
            work.append((ops[0].imm, T))
            continue
        tainted_read = rd & T
        newT = set(T)
        if src_form:
            if tainted_read:
                return why(12, locals())
            newT.add(SUB[ins.reg_name(ops[0].reg)])
        elif tainted_read:
            store = (m in STORES and ops and ops[0].type == X.X86_OP_MEM and ops[0].mem.base and SUB.get(ins.reg_name(ops[0].mem.base)) in T and not ops[0].mem.index
                     and ops[0].mem.segment == 0 and (len(ops) == 1 or ops[1].type != X.X86_OP_REG or SUB.get(ins.reg_name(ops[1].reg)) not in T)
                     and {SUB[ins.reg_name(ops[0].mem.base)]} == tainted_read)
            load = (m in ('mov', 'movzx', 'movsx', 'fld', 'fild') and len(ops) == 2 and ops[0].type == X.X86_OP_REG and ops[1].type == X.X86_OP_MEM and ops[1].mem.base
                    and SUB.get(ins.reg_name(ops[1].mem.base)) in T and not ops[1].mem.index and {SUB[ins.reg_name(ops[1].mem.base)]} == tainted_read) or \
                   (m in ('fld', 'fild', 'fcom', 'fcomp', 'fadd', 'fsub', 'fmul', 'fdiv', 'fsubr', 'fdivr', 'ficom', 'ficomp') and ops and ops[0].type == X.X86_OP_MEM and ops[0].mem.base
                    and SUB.get(ins.reg_name(ops[0].mem.base)) in T and not ops[0].mem.index and {SUB[ins.reg_name(ops[0].mem.base)]} == tainted_read)
            if store:
                d = ops[0].mem.disp
                lo = d if lo is None else min(lo, d)
                hi = d + ops[0].size if hi is None else max(hi, d + ops[0].size)
            elif not load:
                return why(13, locals())
        if m == 'call':
            if T:
                return why(14, locals())                                           # no call while a register holds the pointer (it could be passed in ecx or spilled by a callee that saves ebx/esi/edi)
            newT -= {'eax', 'ecx', 'edx'}
        for r in full:                                               # a write of the whole register ends its taint (a call is handled above, and the pointer is also dead in eax/ecx/edx there)
            if not src_form:
                newT.discard(r)
        nxt = ins.address + ins.size
        T2 = frozenset(newT)
        if m.startswith('j'):
            if ops[0].type != X.X86_OP_IMM:
                return why(15, locals())
            work.append((ops[0].imm, T2))
        work.append((nxt, T2))
    rets = frozenset(rets)
    if lo is None:
        return (0, 0, rets)                                          # the callee never writes through the pointer
    return (lo, hi, rets)


def call_footprints(insns, image, targets_of_jumps, row_va, body):
    """({lea address: call address}, {call address: (disp, lo, hi)}) for the `lea R, [ebp + disp]; push R; ...; call C` escapes of a caller whose C passes callee_footprint.
    `targets_of_jumps` is the set of addresses that some jump of the caller can land on."""
    leas, calls = {}, {}
    cache = {}
    for k, ins in enumerate(insns):
        if ins.mnemonic != 'lea':
            continue
        mem = ins.operands[1].mem
        if not (mem.base and ins.reg_name(mem.base) == 'ebp' and not mem.index and mem.disp < 0 and ins.operands[0].type == X.X86_OP_REG):
            continue
        R = ins.reg_name(ins.operands[0].reg)
        if R not in ('eax', 'ecx', 'edx') or k + 2 >= len(insns):
            continue
        push = insns[k + 1]
        if not (push.mnemonic == 'push' and push.operands[0].type == X.X86_OP_REG and push.reg_name(push.operands[0].reg) == R):
            continue
        j = k + 2
        ok = False
        while j < len(insns):
            c = insns[j]
            if c.address in targets_of_jumps:
                break
            if c.mnemonic == 'call':
                ok = c.operands[0].type == X.X86_OP_IMM
                break
            rd, wr, _ = _regs(c)
            if c.mnemonic in ('push', 'pop', 'lea', 'ret', 'retn', 'leave') or c.mnemonic.startswith('j') or c.mnemonic.startswith('loop') or R in rd or R in wr or {'esp', 'ebp'} & wr:
                break
            if c.mnemonic.startswith(('rep', 'movs', 'stos', 'cmps', 'scas', 'lods')):
                break
            j += 1
        if not ok:
            continue
        callee = insns[j].operands[0].imm & 0xffffffff
        if (callee, R) not in cache:
            cache[(callee, R)] = callee_summary(image, callee, frozenset({R}))
        fp = cache[(callee, R)]
        if fp is None:
            continue
        leas[ins.address] = insns[j].address
        calls[insns[j].address] = (mem.disp, fp[0], fp[1], fp[2])
    return leas, calls
