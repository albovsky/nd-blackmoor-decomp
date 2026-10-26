#!/usr/bin/env python3
"""FL-64: exact reachable values of registers and memory cells of one function, by explicit-state exploration of its ORIGINAL instructions (capstone over the pinned GAME.EXE bytes).

The interval analyses of FL-44/FL-45 (frame slots only, no relation between two counters, no object fields) cannot show that `this->i` of
    for (this->i = 0, this->j = this->n - 1; this->i < this->n; this->i++, this->j--) ...
never leaves [0, 10]: the bound sits in a field of the object, and `j` is only bounded through `i`. This module runs the function on a SYMBOLIC input instead of on intervals and keeps every
reachable state exactly, which is possible because the loops that matter here are bounded by constants (a loop whose trip count comes from data never reaches a fixpoint, the state cap stops the
exploration, and the answer is "no information").

  value     a concrete 32-bit integer, or ('s', name, off): a value that is constant during one call (a start register, an argument slot) plus a constant; TOP (None): anything else. Two
            equal symbolic values are the same number at run time, nothing else is known about them.
  cells     frame slots [ebp + k] ('f', k), memory at a constant address ('a', addr), memory at a symbolic base + displacement ('o', name, off), each with a width of 1, 2 or 4 bytes and a value;
            absent = unknown. A store kills the overlapping cells of its own address space; a store through a pointer the analysis cannot name (TOP) or through a different symbol kills every 'o' and 'a'
            cell (the pointers may alias); frame cells are killed by frame stores only (the assumption of scripts/fl43_equiv.py: no store through another pointer reaches the frame; a function that takes
            the address of a frame slot, pushes ebp/esp or addresses its frame through esp is refused, as there). A call kills 'o' and 'a' cells and eax, ecx, edx. A string instruction kills 'o' and 'a'.
  flags     cf zf sf of, each True/False/None; a conditional jump forks only when a flag it reads is unknown.
  state     (instruction, registers, cells, flags); identical states are explored once. Over `MAX_STATES` states `explore` gives up (the loop is not bounded by constants).

`explore(va, size)` -> Facts or None when the function is refused or the cap is hit. Facts.reads[addr] is the set of values that the memory operand read by the instruction at addr takes in
any reachable state (a frozenset of concrete ints, symbolic tuples, or None for TOP); Facts.regs[addr][reg] likewise for the registers before the instruction.
tests/test_fl64_cells.py replays the corpus seeds on the original bytes in Unicorn and checks that every observed value lies in these sets (the soundness test of the engine).
"""
import sys
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl43_equiv as E

MAX_STATES = 60000
LAST = {}          # why the last explore() gave no facts
GP = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')
M32 = 0xffffffff
JCC = {'jo': ('of',), 'jno': ('of',), 'jb': ('cf',), 'jnae': ('cf',), 'jc': ('cf',), 'jae': ('cf',), 'jnb': ('cf',), 'jnc': ('cf',), 'je': ('zf',), 'jz': ('zf',), 'jne': ('zf',), 'jnz': ('zf',),
       'jbe': ('cf', 'zf'), 'jna': ('cf', 'zf'), 'ja': ('cf', 'zf'), 'jnbe': ('cf', 'zf'), 'js': ('sf',), 'jns': ('sf',), 'jl': ('sf', 'of'), 'jnge': ('sf', 'of'), 'jge': ('sf', 'of'),
       'jnl': ('sf', 'of'), 'jle': ('zf', 'sf', 'of'), 'jng': ('zf', 'sf', 'of'), 'jg': ('zf', 'sf', 'of'), 'jnle': ('zf', 'sf', 'of')}
PARTS = {'ax': ('eax', 16, 0), 'cx': ('ecx', 16, 0), 'dx': ('edx', 16, 0), 'bx': ('ebx', 16, 0), 'si': ('esi', 16, 0), 'di': ('edi', 16, 0),
         'al': ('eax', 8, 0), 'cl': ('ecx', 8, 0), 'dl': ('edx', 8, 0), 'bl': ('ebx', 8, 0), 'ah': ('eax', 8, 8), 'ch': ('ecx', 8, 8), 'dh': ('edx', 8, 8), 'bh': ('ebx', 8, 8)}


def wrap(x):
    """a symbolic offset modulo 2**32 as a signed number: the same address always has the same offset"""
    x &= M32
    return x - (1 << 32) if x & 0x80000000 else x


def mask(size):
    return (1 << (8 * size)) - 1


def sx(v, size):
    v &= mask(size)
    return v - (1 << (8 * size)) if v >> (8 * size - 1) else v


def is_conc(v):
    return isinstance(v, int)


def cond(name, fl):
    """truth of the condition of a jcc under flags `fl` (a dict of True/False/None), None when a flag it reads is unknown"""
    need = JCC[name]
    if any(fl[f] is None for f in need):
        return None
    cf, zf, sf, of = fl['cf'], fl['zf'], fl['sf'], fl['of']
    return {'jo': of, 'jno': not of, 'jb': cf, 'jnae': cf, 'jc': cf, 'jae': not cf, 'jnb': not cf, 'jnc': not cf, 'je': zf, 'jz': zf, 'jne': not zf, 'jnz': not zf, 'jbe': cf or zf,
            'jna': cf or zf, 'ja': not cf and not zf, 'jnbe': not cf and not zf, 'js': sf, 'jns': not sf, 'jl': sf != of, 'jnge': sf != of, 'jge': sf == of, 'jnl': sf == of,
            'jle': zf or sf != of, 'jng': zf or sf != of, 'jg': not zf and sf == of, 'jnle': not zf and sf == of}[name]


def flags_of(op, a, b, size):
    """cf zf sf of of a concrete add/sub/logic result"""
    m, top = mask(size), 1 << (8 * size - 1)
    if op == 'add':
        r = (a + b) & m
        return r, dict(cf=(a + b) > m, zf=r == 0, sf=bool(r & top), of=bool(~(a ^ b) & (a ^ r) & top))
    if op == 'sub':
        r = (a - b) & m
        return r, dict(cf=a < b, zf=r == 0, sf=bool(r & top), of=bool((a ^ b) & (a ^ r) & top))
    r = {'and': a & b, 'or': a | b, 'xor': a ^ b}[op] & m
    return r, dict(cf=False, zf=r == 0, sf=bool(r & top), of=False)


UNKNOWN_FLAGS = (None, None, None, None)


class State:
    __slots__ = ('regs', 'cells', 'flags', 'cmp')

    def __init__(self, regs, cells, flags, cmp=None):
        self.regs = regs        # tuple over GP
        self.cells = cells      # frozenset of (key, size, value)
        self.flags = flags      # (cf, zf, sf, of)
        self.cmp = cmp          # the compare that the very next instruction may branch on: ((location, value), (location, value)); a location is ('r', reg) | ('c', cell key, size) | None

    def key(self):
        return (self.regs, self.cells, self.flags, self.cmp)


class Facts:
    def __init__(self):
        self.reads = {}         # instruction address -> set of values read by its memory operand
        self.sizes = {}         # instruction address -> width in bytes of its memory operand read
        self.regs = {}          # instruction address -> {reg: set of values before it}
        self.states = 0


class Refused(Exception):
    pass


def addr_value(ins, op, regs):
    """the address of memory operand `op` -> ('f', k) | ('a', addr) | ('o', name, off) | None (TOP)"""
    m = op.mem
    if m.segment:
        return None
    base = ins.reg_name(m.base) if m.base else None
    index = ins.reg_name(m.index) if m.index else None
    disp = m.disp
    if base == 'ebp' and not index:
        return ('f', disp)
    if base in ('esp', 'ebp') or index in ('esp', 'ebp'):
        raise Refused('esp/ebp-indexed memory operand at 0x%x' % ins.address)
    total = disp
    sym = None
    for reg, scale in ((base, 1), (index, m.scale)):
        if reg is None:
            continue
        v = regs[GP.index(reg)]
        if is_conc(v):
            total += v * scale
        elif isinstance(v, tuple) and v[0] == 's' and scale == 1 and sym is None:
            sym = v
            total += v[2]
        else:
            return None
    if sym is None:
        return ('a', total & M32)
    return ('o', sym[1], wrap(total))


def cell_range(key, size):
    return (key[1], key[1] + size) if key[0] in ('f', 'a') else (key[2], key[2] + size)


def same_space(a, b):
    return a[0] == b[0] and (a[0] != 'o' or a[1] == b[1])


def overlaps(a, sa, b, sb):
    if not same_space(a, b):
        return False
    (l1, h1), (l2, h2) = cell_range(a, sa), cell_range(b, sb)
    if a[0] in ('f',):
        l1, h1, l2, h2 = (sx(l1, 4), sx(l1, 4) + sa, sx(l2, 4), sx(l2, 4) + sb)
    return l1 < h2 and l2 < h1


def get_cell(cells, key, size):
    """value of the cell (key, size) -> (found, value); a wider concrete cell gives the narrower read, anything else overlapping is unknown"""
    for k, s, v in cells:
        if k == key and s == size:
            return True, v
    for k, s, v in cells:
        if same_space(k, key) and s > size and is_conc(v):
            lo, hi = cell_range(k, s), cell_range(key, size)
            if lo[0] <= hi[0] and hi[1] <= lo[1] and (k[0] != 'f' or True):
                sh = 8 * (hi[0] - lo[0])
                return True, (v >> sh) & mask(size)
    return False, None


def put_cell(cells, key, size, value):
    out = set()
    for k, s, v in cells:
        if overlaps(k, s, key, size):
            continue
        out.add((k, s, v))
    if value is not None:
        out.add((key, size, value))
    return out


def kill_other_spaces(cells, key=None, keep_frame=True):
    """drop every 'o' and 'a' cell (a store through a pointer that may alias them)"""
    return {(k, s, v) for k, s, v in cells if k[0] == 'f'}


def explore(va, size, max_states=None):
    max_states = max_states or MAX_STATES
    try:
        f = E.Function(va, size)
        for i in f.ins:
            if (i.mnemonic.startswith('j') and i.mnemonic != 'jmp' and i.mnemonic not in JCC) or i.mnemonic.startswith('loop'):
                raise Refused('conditional transfer %s at 0x%x is not followed' % (i.mnemonic, i.address))
            for op in i.operands:
                if op.type == E.MEM_OP and i.mnemonic != 'lea':
                    addr_value(i, op, [0] * 6) if True else None
    except (E.NoProof, Refused) as exc:
        LAST['why'] = repr(exc)
        return None
    facts = Facts()
    entry_regs = tuple(('s', 'in_' + r, 0) for r in GP)
    args = {op.mem.disp for i in f.ins for op in i.operands if op.type == E.MEM_OP and i.mnemonic != 'lea' and i.reg_name(op.mem.base) == 'ebp' and not op.mem.index and op.mem.disp >= 8 and op.size == 4}
    start = State(entry_regs, frozenset((('f', d), 4, ('s', 'arg%d' % d, 0)) for d in args), (None,) * 4)     # the argument slots hold their start values (a store drops the cell for good)
    seen = set()
    work = [(f.order[0], start)]
    try:
        while work:
            pc, st = work.pop()
            k = (pc, st.key())
            if k in seen:
                continue
            seen.add(k)
            if len(seen) > max_states:
                LAST['why'] = 'more than %d states' % max_states
                return None
            facts.states = len(seen)
            ins = f.at[pc]
            reg_view = facts.regs.setdefault(pc, {})
            for n, r in enumerate(GP):
                reg_view.setdefault(r, set()).add(st.regs[n])
            for nxt_pc, nst in step(f, ins, st, facts):
                if nxt_pc is not None and nxt_pc in f.at:
                    work.append((nxt_pc, nst))
    except Refused as exc:
        LAST['why'] = repr(exc)
        return None
    return facts


def refined(f, st):
    """the state on the edge where the last compare found its operands equal: the operand whose value is unknown takes the value of the other, when that is a concrete number or a symbol"""
    (la, va_), (lb, vb) = st.cmp
    regs, cells = st.regs, set(st.cells)
    changed = False
    for (loc, cur), other in (((la, va_), vb), ((lb, vb), va_)):
        if loc is None or cur is not None or other is None:
            continue
        if loc[0] == 'r':
            regs = write_reg(regs, loc[1], other)
            changed = True
        elif loc[0] == 'c' and (is_conc(other) or (isinstance(other, tuple) and other[0] == 's' and loc[2] == 4)):
            cells = put_cell(cells, loc[1], loc[2], other)
            changed = True
    return State(regs, frozenset(cells), st.flags, None) if changed else None


def read_reg(regs, name):
    """-> (value, width in bytes); a register whose low half only is known (`('lo', bits, v)`) gives a narrower read but never a whole value"""
    if name in ('esp', 'ebp'):
        return None, 4
    if name in GP:
        v = regs[GP.index(name)]
        return (None if (isinstance(v, tuple) and v[0] == 'lo') else v), 4
    full, bits, sh = PARTS[name]
    v = regs[GP.index(full)]
    if is_conc(v):
        return (v >> sh) & mask(bits // 8), bits // 8
    if isinstance(v, tuple) and v[0] == 'lo' and sh + bits <= v[1]:
        return (v[2] >> sh) & mask(bits // 8), bits // 8
    return None, bits // 8


def write_reg(regs, name, v):
    if name in ('esp', 'ebp'):
        return regs
    regs = list(regs)
    if name in GP:
        regs[GP.index(name)] = v if (v is None or is_conc(v) or (isinstance(v, tuple) and v[0] == 's')) else None
        return tuple(regs)
    full, bits, sh = PARTS[name]
    old = regs[GP.index(full)]
    m = mask(bits // 8) << sh
    if not is_conc(v):
        regs[GP.index(full)] = None
    elif is_conc(old):
        regs[GP.index(full)] = (old & ~m & M32) | ((v << sh) & m)
    else:
        known = old[1] if isinstance(old, tuple) and old[0] == 'lo' else 0
        low = old[2] if known else 0
        if sh == 0 and bits >= known:
            regs[GP.index(full)] = ('lo', bits, v)                        # the written low part covers everything that was known
        elif sh + bits <= known:
            regs[GP.index(full)] = ('lo', known, (low & ~m & 0xffff) | ((v << sh) & m))
        else:
            regs[GP.index(full)] = None
    return tuple(regs)


def step(f, ins, st, facts):
    """-> [(next instruction address or None, state)]"""
    n = ins.mnemonic
    ops = ins.operands
    nxt = f.order[f.order.index(ins.address) + 1] if f.order.index(ins.address) + 1 < len(f.order) else None
    regs, cells, flags = st.regs, set(st.cells), st.flags

    def read_op(op, isz=None):
        """-> (value, size); a memory operand is looked up in the cells and recorded; an immediate is taken at the width `isz` of the other operand (capstone reports an imm8 as one byte, its value sign-extended)"""
        if op.type == E.IMM_OP:
            isz = isz or op.size
            return op.imm & mask(isz), isz
        if op.type == E.REG_OP:
            return read_reg(regs, ins.reg_name(op.reg))
        addr = addr_value(ins, op, regs)
        v = None
        if addr is not None:
            found, v = get_cell(cells, addr, op.size)
            if not found:
                v = None
        facts.reads.setdefault(ins.address, set()).add(v)
        facts.sizes[ins.address] = op.size
        return v, op.size

    def write_op(op, v):
        nonlocal regs, cells
        if op.type == E.REG_OP:
            regs = write_reg(regs, ins.reg_name(op.reg), v)
            return
        addr = addr_value(ins, op, regs)
        if addr is None:
            cells = kill_other_spaces(cells)
            return
        if is_conc(v):
            v = v & mask(op.size)
        elif not (isinstance(v, tuple) and v[0] == 's' and op.size == 4):
            v = None
        if addr[0] == 'a':
            cells = {c for c in cells if c[0][0] != 'o'}
        elif addr[0] == 'o':
            cells = {c for c in cells if c[0][0] == 'f' or (c[0][0] == 'o' and c[0][1] == addr[1])}
        cells = put_cell(cells, addr, op.size, v)

    def done(nregs=None, ncells=None, nflags=None, target=None, ncmp=None):
        return [(nxt if target is None else target, State(regs if nregs is None else nregs, frozenset(cells if ncells is None else ncells), flags if nflags is None else nflags, ncmp))]

    # ---- control flow
    if n == 'ret':
        return []
    if n == 'jmp':
        return [(ops[0].imm, State(regs, frozenset(cells), flags))] if ops[0].type == E.IMM_OP and ops[0].imm in f.at else []
    if n in JCC:
        fl = dict(zip(('cf', 'zf', 'sf', 'of'), flags))
        c = cond(n, fl)
        tgt = ops[0].imm
        s = State(regs, frozenset(cells), flags)
        out = []
        eq = None
        if n in ('je', 'jz', 'jne', 'jnz') and st.cmp:
            eq = refined(f, st)
        equal_is_taken = n in ('je', 'jz')
        if c is not False:
            out.append((tgt, eq if (eq is not None and equal_is_taken) else s))
        if c is not True:
            out.append((nxt, eq if (eq is not None and not equal_is_taken) else s))
        return out
    # ---- data
    flags_new = flags
    if n == 'mov' and len(ops) == 2:
        v, sz = read_op(ops[1], ops[0].size)
        write_op(ops[0], v if (is_conc(v) or isinstance(v, tuple) and v[0] == 's' and sz == 4) else None)
        return done()
    if n in ('movzx', 'movsx') and len(ops) == 2:
        v, sz = read_op(ops[1])
        if is_conc(v):
            v = (v & mask(sz)) if n == 'movzx' else sx(v, sz) & M32
        else:
            v = None
        write_op(ops[0], v)
        return done()
    if n == 'lea' and len(ops) == 2:
        m = ops[1].mem
        if not m.segment:
            v = None
            try:
                a = addr_value(ins, ops[1], regs)
            except Refused:
                a = None
            if a is not None and a[0] == 'a':
                v = a[1]
            elif a is not None and a[0] == 'o':
                v = ('s', a[1], wrap(a[2]))
            write_op(ops[0], v)
            return done()
    if n in ('add', 'sub', 'cmp', 'and', 'or', 'xor', 'test') and len(ops) == 2:
        a, sz = read_op(ops[0])
        b, _ = read_op(ops[1], sz)
        if n == 'xor' and ops[0].type == E.REG_OP and ops[1].type == E.REG_OP and ops[0].reg == ops[1].reg:
            a = b = 0
        op = 'and' if n == 'test' else ('sub' if n == 'cmp' else n)
        if is_conc(a) and is_conc(b):
            r, fl = flags_of(op, a, b, sz)
            flags_new = (fl['cf'], fl['zf'], fl['sf'], fl['of'])
        else:
            r, flags_new = None, UNKNOWN_FLAGS
            if n in ('add', 'sub') and sz == 4 and isinstance(a, tuple) and a[0] == 's' and is_conc(b):
                r = ('s', a[1], wrap(a[2] + (b if n == 'add' else -b)))
            elif n == 'add' and sz == 4 and isinstance(b, tuple) and b[0] == 's' and is_conc(a):
                r = ('s', b[1], wrap(b[2] + a))
        if n in ('cmp', 'test'):
            def loc(op):
                if op.type == E.REG_OP and ins.reg_name(op.reg) in GP:
                    return ('r', ins.reg_name(op.reg))
                if op.type == E.MEM_OP:
                    ad = addr_value(ins, op, regs)
                    return ('c', ad, op.size) if ad is not None else None
                return None
            if n == 'test' and ops[0].type == E.REG_OP and ops[1].type == E.REG_OP and ops[0].reg == ops[1].reg:
                b = 0
            if sz == 4 or ops[0].type == E.MEM_OP:
                ncmp = ((loc(ops[0]), a), (loc(ops[1]) if ops[1].type != E.REG_OP or n == 'cmp' else None, b))
                if n == 'test' and not (ops[0].type == E.REG_OP and ops[1].type == E.REG_OP and ops[0].reg == ops[1].reg):
                    ncmp = None
            else:
                ncmp = None
            return done(nflags=flags_new, ncmp=ncmp)
        write_op(ops[0], r)
        return done(nflags=flags_new)
    if n in ('inc', 'dec') and len(ops) == 1:
        a, sz = read_op(ops[0])
        if is_conc(a):
            r, fl = flags_of('add' if n == 'inc' else 'sub', a, 1, sz)
            flags_new = (flags[0], fl['zf'], fl['sf'], fl['of'])          # inc/dec leave cf alone
        else:
            r, flags_new = None, (flags[0], None, None, None)
        write_op(ops[0], r)
        return done(nflags=flags_new)
    if n in ('shl', 'shr', 'sar', 'sal') and len(ops) in (1, 2):
        a, sz = read_op(ops[0])
        c = 1
        if len(ops) == 2:
            c, _ = read_op(ops[1])
        r = None
        if is_conc(a) and is_conc(c):
            c &= 31
            if c == 0:
                r = a
                flags_new = flags
            else:
                if n in ('shl', 'sal'):
                    r = (a << c) & mask(sz)
                elif n == 'shr':
                    r = a >> c
                else:
                    r = (sx(a, sz) >> c) & mask(sz)
                flags_new = UNKNOWN_FLAGS
        else:
            flags_new = UNKNOWN_FLAGS
        write_op(ops[0], r)
        return done(nflags=flags_new)
    if n in ('not', 'neg') and len(ops) == 1:
        a, sz = read_op(ops[0])
        if is_conc(a):
            r = (~a) & mask(sz) if n == 'not' else (-a) & mask(sz)
        else:
            r = None
        write_op(ops[0], r)
        return done(nflags=flags if n == 'not' else UNKNOWN_FLAGS)
    if n == 'imul' and len(ops) in (2, 3):
        a, sz = read_op(ops[-2] if len(ops) == 3 else ops[0])
        b, _ = read_op(ops[-1], sz)
        r = ((sx(a, sz) * sx(b, sz)) & mask(sz)) if is_conc(a) and is_conc(b) else None
        write_op(ops[0], r)
        return done(nflags=UNKNOWN_FLAGS)
    if n == 'cdq':
        a = regs[0]
        regs = write_reg(regs, 'edx', (M32 if a & 0x80000000 else 0) if is_conc(a) else None)
        return done()
    if n in ('push', 'nop', 'fwait', 'leave', 'cld', 'std'):
        return done()
    if n == 'pop' and ops and ops[0].type == E.REG_OP:
        regs = write_reg(regs, ins.reg_name(ops[0].reg), None)
        return done()
    if n == 'call':
        for r in ('eax', 'ecx', 'edx'):
            regs = write_reg(regs, r, None)
        cells = kill_other_spaces(cells)
        return done(nflags=UNKNOWN_FLAGS)
    # ---- anything else: everything it writes becomes unknown
    rd, wr, wp, _, flags_wr, mem, mem_written = E.info(ins)
    for r in set(wr) | set(wp):
        if r in GP:
            regs = write_reg(regs, r, None)
    if n.startswith(E.STRING_OPS):
        for r in ('ecx', 'esi', 'edi', 'eax'):
            regs = write_reg(regs, r, None)
        cells = kill_other_spaces(cells)
        return done(nflags=UNKNOWN_FLAGS)
    if mem_written:
        c = E.mem_class(ins, mem)
        if c is None or c[0] == 'esp':
            raise Refused('write through esp at 0x%x' % ins.address)
        addr = addr_value(ins, mem, regs)
        if addr is None:
            cells = kill_other_spaces(cells)
        elif addr[0] == 'f':
            cells = put_cell(cells, addr, mem.size, None)
        else:
            cells = kill_other_spaces(cells)
    elif mem is not None:
        read_op(mem)
    return done(nflags=UNKNOWN_FLAGS if flags_wr else flags)


if __name__ == '__main__':
    va = int(sys.argv[1], 16)
    size = int(sys.argv[2], 0)
    fa = explore(va, size)
    if fa is None:
        print('no facts:', LAST.get('why'))
    else:
        print('states', fa.states)
        for a in sorted(fa.reads):
            print('%x reads %s' % (a, sorted(map(str, fa.reads[a]))[:12]))
