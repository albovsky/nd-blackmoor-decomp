#!/usr/bin/env python3
"""FL-44: value ranges of the 32-bit frame slots of a function, from its own x86 instructions (capstone, GAME.EXE bytes read only).

Used by scripts/fl40_survivors.py to explain a width survivor: a mutant that reads a dword slot `[ebp - k]` with a narrower access (`RD32` -> `RD16`) behaves like the
translation whenever the slot always holds a value below 2^16 (a loop counter bounded by its own guard, a small constant). The analysis is a forward interval
analysis over the instruction CFG:

  state      per instruction: interval [lo, hi] (unsigned, no wrap) of every dword slot `[ebp + d]` and every general register; absent = unknown
  transfer   mov reg, imm/reg/slot; mov slot, imm/reg; add/sub reg, imm; inc/dec reg; add reg, reg; add/sub/inc/dec slot; xor reg, reg; everything else that writes a
             register or touches a slot makes it unknown. A call makes eax, ecx, edx unknown.
  branches   `cmp reg-or-slot, imm` followed by a conditional jump narrows the interval on each edge (signed jumps only when the interval is inside [0, 2^31)); a reg that was loaded
             from a slot narrows the slot too
  fixpoint   ascending with widening (to the next compare immediate +-1 of the function, else 0x7fffffff, else 0xffffffff) after 6 changes, then 4 narrowing rounds (each round is sound from a post-fixpoint)
  refused    the function takes the address of its frame (lea of an ebp-relative operand, ebp or esp copied or used as a plain operand other than the prologue/epilogue forms),
             uses an indexed ebp operand or an esp-relative memory operand, or jumps through a register/table: then no slot is tracked and `ranges()` returns None

A callee cannot write the frame without its address, and the store through any other register is assumed not to alias it (the same assumption as fl40_survivors.same_value).
"""
from pathlib import Path
import struct
import sys

PROJECT = Path(__file__).resolve().parents[1]
GAME_EXE = PROJECT.parents[1] / 'work/original/GAME.EXE'
GP = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')
MAXU = 0xffffffff
SIGN_SAFE = 0x7fffffff
JCC = {'jl': 'l', 'jnge': 'l', 'jge': 'ge', 'jnl': 'ge', 'jle': 'le', 'jng': 'le', 'jg': 'g', 'jnle': 'g',
       'jb': 'b', 'jnae': 'b', 'jc': 'b', 'jae': 'ae', 'jnb': 'ae', 'jnc': 'ae', 'jbe': 'be', 'jna': 'be', 'ja': 'a', 'jnbe': 'a',
       'je': 'e', 'jz': 'e', 'jne': 'ne', 'jnz': 'ne'}
NEGATE = {'l': 'ge', 'ge': 'l', 'le': 'g', 'g': 'le', 'b': 'ae', 'ae': 'b', 'be': 'a', 'a': 'be', 'e': 'ne', 'ne': 'e'}
SIGNED = {'l', 'ge', 'le', 'g'}


def _image():
    d = GAME_EXE.read_bytes()
    pe = struct.unpack_from('<I', d, 0x3c)[0]
    nsec = struct.unpack_from('<H', d, pe + 6)[0]
    optsz = struct.unpack_from('<H', d, pe + 20)[0]
    base = struct.unpack_from('<I', d, pe + 24 + 28)[0]
    secs = []
    for i in range(nsec):
        o = pe + 24 + optsz + 40 * i
        vs, va, rs, ro = struct.unpack_from('<IIII', d, o + 8)
        secs.append((va, vs, ro, rs))
    return d, base, secs


_IMG = []


def read_bytes(addr, n):
    if not _IMG:
        _IMG.append(_image())
    d, base, secs = _IMG[0]
    rva = addr - base
    for va, vs, ro, rs in secs:
        if va <= rva < va + max(vs, rs):
            return d[ro + rva - va:ro + rva - va + n]
    return b''


def available():
    try:
        import capstone  # noqa: F401
    except ImportError:
        return False
    return GAME_EXE.is_file()


def disassemble(va, size):
    import capstone
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    return list(md.disasm(read_bytes(va, size), va))


def signed32(v):
    v &= MAXU
    return v - (1 << 32) if v >= 1 << 31 else v


def reg_name(i, r):
    return i.reg_name(r) if r else None


def slot_of(i, op):
    """ebp displacement of a memory operand [ebp + d] (no index, no segment), else None"""
    import capstone.x86 as X
    if op.type != X.X86_OP_MEM:
        return None
    m = op.mem
    if i.reg_name(m.base) != 'ebp' or m.index != 0 or m.segment != 0:
        return None
    return m.disp


def refused(ins):
    """True when the frame may be reached by an address or by an esp/indexed operand"""
    import capstone.x86 as X
    for i in ins:
        n = i.mnemonic
        if n in ('lea',):
            if any(op.type == X.X86_OP_MEM and (i.reg_name(op.mem.base) in ('ebp', 'esp') or i.reg_name(op.mem.index) in ('ebp', 'esp')) for op in i.operands):
                return True
        if n == 'jmp' and i.operands and i.operands[0].type != X.X86_OP_IMM:
            return True
        if n == 'call' and False:
            pass
        for op in i.operands:
            if op.type == X.X86_OP_MEM:
                b, ix = i.reg_name(op.mem.base), i.reg_name(op.mem.index)
                if b == 'esp' or ix == 'esp' or ix == 'ebp':
                    return True
                if b == 'ebp' and ix:
                    return True
            elif op.type == X.X86_OP_REG:
                r = i.reg_name(op.reg)
                if r in ('ebp', 'esp'):
                    ok = (n in ('push', 'pop') or n == 'leave' or (n == 'mov' and {i.reg_name(o.reg) for o in i.operands if o.type == X.X86_OP_REG} == {'ebp', 'esp'} and len(i.operands) == 2)
                          or (n in ('add', 'sub') and r == 'esp' and i.operands[1].type == X.X86_OP_IMM))
                    if not ok:
                        return True
    return False


def hull(a, b):
    if a is None or b is None:
        return None
    return (min(a[0], b[0]), max(a[1], b[1]))


def meet(a, lo=None, hi=None):
    if a is None:
        a = (0, MAXU)
    lo2 = a[0] if lo is None else max(a[0], lo)
    hi2 = a[1] if hi is None else min(a[1], hi)
    return (lo2, hi2) if lo2 <= hi2 else 'dead'


class State:
    __slots__ = ('slots', 'regs', 'src', 'cmp')

    def __init__(self, slots=None, regs=None, src=None, cmp=None):
        self.slots = slots or {}      # disp -> (lo, hi)
        self.regs = regs or {}        # name -> (lo, hi)
        self.src = src or {}          # reg -> disp it was loaded from
        self.cmp = cmp                # ('reg', name, imm) | ('slot', disp, imm) | None

    def copy(self):
        return State(dict(self.slots), dict(self.regs), dict(self.src), self.cmp)

    def key(self):
        return (tuple(sorted(self.slots.items())), tuple(sorted(self.regs.items())), tuple(sorted(self.src.items())), self.cmp)


THRESHOLDS = [SIGN_SAFE, MAXU]       # set by ranges(): the compare immediates of the function (and +-1), then the signed and unsigned maxima


def join(a, b, widen=False):
    """hull of two states; widening pushes a growing upper bound to SIGN_SAFE"""
    if a is None:
        return b.copy() if b else None
    if b is None:
        return a.copy()
    out = State()
    for field in ('slots', 'regs'):
        da, db, do = getattr(a, field), getattr(b, field), getattr(out, field)
        for k in da:
            if k in db:
                lo, hi = min(da[k][0], db[k][0]), max(da[k][1], db[k][1])
                if widen and hi > da[k][1]:
                    hi = next((t for t in THRESHOLDS if t >= hi), MAXU)
                do[k] = (lo, hi)
    out.src = {k: v for k, v in a.src.items() if b.src.get(k) == v}
    out.cmp = a.cmp if a.cmp == b.cmp else None
    return out


def _interval_of(st, i, op):
    import capstone.x86 as X
    if op.type == X.X86_OP_IMM:
        v = op.imm & MAXU
        return (v, v)
    if op.type == X.X86_OP_REG:
        return st.regs.get(i.reg_name(op.reg))
    if op.type == X.X86_OP_MEM:
        d = slot_of(i, op)
        if d is not None and op.size == 4:
            return st.slots.get(d)
    return None


def _kill_slot(st, d, size):
    for k in [k for k in st.slots if k < d + size and d < k + 4]:
        del st.slots[k]
    for r in [r for r, s in st.src.items() if s < d + size and d < s + 4]:
        del st.src[r]


def _set_reg(st, name, iv, src=None):
    if iv is None:
        st.regs.pop(name, None)
    else:
        st.regs[name] = iv
    st.src.pop(name, None)
    if src is not None and iv is not None:
        st.src[name] = src


def _shift(iv, k):
    if iv is None:
        return None
    lo, hi = iv[0] + k, iv[1] + k
    return (lo, hi) if 0 <= lo and hi <= MAXU else None


def transfer(i, st):
    """state after instruction i (not for jumps: the branch edges are in `edges`)"""
    import capstone.x86 as X
    st = st.copy()
    st.cmp = None
    n = i.mnemonic
    ops = i.operands
    prefix = i.prefix[0] if i.prefix else 0
    written_regs = set()
    if n == 'leave' or (n in ('mov', 'pop') and ops and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) in ('esp', 'ebp')):
        st.slots.clear()        # the frame is released: what lies below esp is no longer the function's
        st.src.clear()
        return st
    try:
        _, regs_w = i.regs_access()
        written_regs = {i.reg_name(r) for r in regs_w}
    except Exception:
        written_regs = set()
    # memory writes into the frame
    for op in ops:
        if op.type == X.X86_OP_MEM and (op.access & 2):
            d = slot_of(i, op)
            if d is not None:
                _kill_slot(st, d, op.size)
    if n == 'cmp' and len(ops) == 2 and ops[1].type == X.X86_OP_IMM:
        a = ops[0]
        imm = ops[1].imm & MAXU
        if a.type == X.X86_OP_REG and i.reg_name(a.reg) in GP:
            st.cmp = ('reg', i.reg_name(a.reg), imm)
        elif a.type == X.X86_OP_MEM and a.size == 4 and slot_of(i, a) is not None:
            st.cmp = ('slot', slot_of(i, a), imm)
        return st
    if n == 'mov' and len(ops) == 2 and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) in GP and ops[0].size == 4:
        r = i.reg_name(ops[0].reg)
        s = ops[1]
        src = slot_of(i, s) if (s.type == X.X86_OP_MEM and s.size == 4) else None
        _set_reg(st, r, _interval_of(st, i, s), src)
        if s.type == X.X86_OP_REG and i.reg_name(s.reg) in GP:
            st.src.pop(r, None)
            if i.reg_name(s.reg) in st.src:
                st.src[r] = st.src[i.reg_name(s.reg)]
        return st
    if n == 'mov' and len(ops) == 2 and ops[0].type == X.X86_OP_MEM and ops[0].size == 4 and slot_of(i, ops[0]) is not None:
        d = slot_of(i, ops[0])
        iv = _interval_of(st, i, ops[1])
        if iv is not None:
            st.slots[d] = iv
        if ops[1].type == X.X86_OP_REG and i.reg_name(ops[1].reg) in GP:
            st.src[i.reg_name(ops[1].reg)] = d
        return st
    if n in ('add', 'sub') and len(ops) == 2 and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) in GP and ops[0].size == 4:
        r = i.reg_name(ops[0].reg)
        iv0 = st.regs.get(r)
        iv1 = _interval_of(st, i, ops[1])
        res = None
        if iv0 is not None and iv1 is not None:
            if ops[1].type == X.X86_OP_IMM:
                k = signed32(ops[1].imm)
                res = _shift(iv0, k if n == 'add' else -k)
            elif n == 'add':
                lo, hi = iv0[0] + iv1[0], iv0[1] + iv1[1]
                res = (lo, hi) if hi <= MAXU else None
        _set_reg(st, r, res)
        return st
    if n in ('add', 'sub') and len(ops) == 2 and ops[0].type == X.X86_OP_MEM and ops[0].size == 4 and ops[1].type == X.X86_OP_IMM and slot_of(i, ops[0]) is not None:
        d = slot_of(i, ops[0])
        iv0 = None
        # the memory write above already dropped the slot: recompute from the state before
        return _rmw(st, i, d, n)
    if n in ('inc', 'dec') and len(ops) == 1 and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) in GP:
        r = i.reg_name(ops[0].reg)
        _set_reg(st, r, _shift(st.regs.get(r), 1 if n == 'inc' else -1))
        return st
    if n == 'xor' and len(ops) == 2 and ops[0].type == X.X86_OP_REG and ops[1].type == X.X86_OP_REG and ops[0].reg == ops[1].reg and ops[0].size == 4:
        _set_reg(st, i.reg_name(ops[0].reg), (0, 0))
        return st
    if n in ('push', 'pop') or n == 'nop':
        if n == 'pop':
            for r in written_regs:
                if r in GP:
                    _set_reg(st, r, None)
        return st
    # anything else: registers it writes become unknown
    for r in written_regs:
        if r in GP:
            _set_reg(st, r, None)
    for r in GP:
        if n.startswith(('rep', 'movs', 'stos', 'cmps', 'scas', 'lods')) or prefix:
            _set_reg(st, r, None) if r in ('ecx', 'esi', 'edi', 'eax') else None
    if n == 'call':
        for r in ('eax', 'ecx', 'edx'):
            _set_reg(st, r, None)
    for op in ops:
        if op.type == X.X86_OP_REG:
            name = i.reg_name(op.reg)
            if (op.access & 2) and name in GP:
                _set_reg(st, name, None)
            elif (op.access & 2) and name in ('ax', 'al', 'ah', 'cx', 'cl', 'ch', 'dx', 'dl', 'dh', 'bx', 'bl', 'bh', 'si', 'di'):
                full = {'a': 'eax', 'c': 'ecx', 'd': 'edx', 'b': 'ebx'}.get(name[0]) if name[0] in 'acdb' and name != 'di' else {'si': 'esi', 'di': 'edi'}.get(name)
                if full:
                    _set_reg(st, full, None)
    return st


def _rmw(st, i, d, n):
    return st       # an add/sub on a dword slot: the slot was dropped as unknown by the write rule above (sound)


def edges(i, st):
    """[(target address or 'next', state)] for a conditional jump; None when the state is dead on an edge"""
    cond = JCC.get(i.mnemonic)
    out = {}
    for name, c in (('taken', cond), ('next', NEGATE[cond])):
        s = st.copy()
        s.cmp = None
        pend = st.cmp
        if pend is not None:
            kind, who, imm = pend
            cur = s.regs.get(who) if kind == 'reg' else s.slots.get(who)
            ok = True
            if c in SIGNED:
                ok = imm <= SIGN_SAFE and cur is not None and cur[1] <= SIGN_SAFE
            if ok:
                lo = hi = None
                if c in ('l', 'b'):
                    hi = imm - 1
                elif c in ('le', 'be'):
                    hi = imm
                elif c in ('g', 'a'):
                    lo = imm + 1
                elif c in ('ge', 'ae'):
                    lo = imm
                elif c == 'e':
                    lo, hi = imm, imm
                new = meet(cur, lo, hi) if (lo is not None or hi is not None) else cur
                if c == 'ne' and cur is not None and cur[0] == cur[1] == imm:
                    new = 'dead'
                if c in ('l', 'b') and imm == 0:
                    new = 'dead'
                if new == 'dead':
                    out[name] = None
                    continue
                if new is not None:
                    if kind == 'reg':
                        s.regs[who] = new
                        if who in s.src:
                            s.slots[s.src[who]] = new if s.src[who] not in s.slots else meet(s.slots[s.src[who]], new[0], new[1])
                            if s.slots[s.src[who]] == 'dead':
                                out[name] = None
                                continue
                    else:
                        s.slots[who] = new
        out[name] = s
    return out


def ranges(va, size):
    """-> {instruction address: {slot disp: (lo, hi)} before it} or None when the function is refused"""
    import capstone.x86 as X
    ins = disassemble(va, size)
    if not ins or refused(ins):
        return None
    idx = {i.address: k for k, i in enumerate(ins)}
    ts = {SIGN_SAFE, MAXU}
    for i in ins:
        if i.mnemonic == 'cmp' and len(i.operands) == 2 and i.operands[1].type == X.X86_OP_IMM:
            v = i.operands[1].imm & MAXU
            ts |= {t for t in (v - 1, v, v + 1) if 0 <= t <= SIGN_SAFE}
    THRESHOLDS[:] = sorted(ts)
    succ = {}
    for k, i in enumerate(ins):
        nxt = ins[k + 1].address if k + 1 < len(ins) else None
        if i.mnemonic in JCC:
            tgt = i.operands[0].imm if i.operands and i.operands[0].type == X.X86_OP_IMM else None
            succ[i.address] = ('jcc', tgt, nxt)
        elif i.mnemonic == 'jmp':
            succ[i.address] = ('jmp', i.operands[0].imm, None)
        elif i.mnemonic in ('ret', 'retn', 'hlt', 'int3', 'ud2'):
            succ[i.address] = ('end', None, None)
        else:
            succ[i.address] = ('seq', None, nxt)
        if i.mnemonic in ('ret', 'retn') and False:
            pass
    IN = {ins[0].address: State()}
    count = {}
    work = [ins[0].address]

    def push(addr, st, widen):
        if addr is None or addr not in idx or st is None:
            return
        old = IN.get(addr)
        new = join(old, st, widen=widen and addr in count and count[addr] > 6)
        if old is None or new.key() != old.key():
            if old is not None:
                count[addr] = count.get(addr, 0) + 1
            IN[addr] = new
            work.append(addr)

    steps = 0
    while work:
        steps += 1
        if steps > 200000:
            return None
        a = work.pop()
        i = ins[idx[a]]
        st = IN[a]
        kind, tgt, nxt = succ[a]
        if kind == 'jcc':
            e = edges(i, st)
            push(tgt, e['taken'], True)
            push(nxt, e['next'], True)
        elif kind == 'jmp':
            push(tgt, transfer(i, st), True)
        elif kind == 'seq':
            push(nxt, transfer(i, st), True)
    # narrowing: recompute every state from the current ones, without the hull with the old value
    for _ in range(4):
        new_in = {ins[0].address: State()}
        for a in sorted(IN):
            i = ins[idx[a]]
            st = IN[a]
            kind, tgt, nxt = succ[a]
            outs = []
            if kind == 'jcc':
                e = edges(i, st)
                outs = [(tgt, e['taken']), (nxt, e['next'])]
            elif kind == 'jmp':
                outs = [(tgt, transfer(i, st))]
            elif kind == 'seq':
                outs = [(nxt, transfer(i, st))]
            for addr, s in outs:
                if addr is None or addr not in idx or s is None:
                    continue
                new_in[addr] = join(new_in.get(addr), s) if addr in new_in else s.copy()
        # a state only ever gets smaller: keep the old one where the recomputation lost a node (it is unreachable then)
        for a, s in new_in.items():
            if a != ins[0].address:
                IN[a] = s
        for a in list(IN):
            if a not in new_in:
                del IN[a]
    return {a: dict(s.slots) for a, s in IN.items()}


if __name__ == '__main__':
    va = int(sys.argv[1], 16)
    size = int(sys.argv[2], 0)
    r = ranges(va, size)
    if r is None:
        print('refused')
    else:
        for a in sorted(r):
            print('%x %s' % (a, {k: v for k, v in r[a].items()}))
