#!/usr/bin/env python3
"""FL-65: survivor rule `unobserved bits` (difference propagation on the ORIGINAL instructions).

A mutant of one statement changes what that instruction leaves in its destination register (and in the flags) only in some bits: a narrower read (`mov ecx, [m]` read as 16 bits) differs in the upper half,
a changed literal of a partial-register move (`mov al, [m]`: mask 0xffffff00 -> 0xffffff01) in bit 0, a changed compare only in the flags. This module computes those bits, then follows them forward through the
original code of the row (capstone, the FL-43 control-flow graph) and shows that on EVERY path they are cleared before anything observes them:

  difference state   {register: mask of the bits that may differ between the translation and the mutant} and one bit for the flags
  cleared by         a full overwrite of the register, `and r, imm` / `or r, imm` that masks them, a shift that moves them out, a `cmp`/`test`/arithmetic instruction that rewrites the flags
  observed (fails)   a store of a register with a difference in the stored bytes, a difference in an address register, a conditional jump / setcc / cmov / adc / sbb while the flags differ, a call, a return,
                     an instruction the model does not know while a difference is alive. A state with no difference at all ends that path (the rest of the run is the original's).

The initial difference of a statement of the form `reg = expr;` is computed per bit with z3 (the bits where original and mutant expression can differ, scripts/fl64_rules.py's expression model); any other
statement of the FL-41 shapes (`{ uint32_t a_ = .., b_ = .., r_; FL41_OP(..); [reg = r_;] }`) differs in every bit of the registers it assigns and in the flags.
"""
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl43_equiv as E

GP = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi', 'ebp', 'esp')
PARTS = {'ax': ('eax', 2, 0), 'cx': ('ecx', 2, 0), 'dx': ('edx', 2, 0), 'bx': ('ebx', 2, 0), 'si': ('esi', 2, 0), 'di': ('edi', 2, 0), 'bp': ('ebp', 2, 0), 'sp': ('esp', 2, 0),
         'al': ('eax', 1, 0), 'cl': ('ecx', 1, 0), 'dl': ('edx', 1, 0), 'bl': ('ebx', 1, 0), 'ah': ('eax', 1, 8), 'ch': ('ecx', 1, 8), 'dh': ('edx', 1, 8), 'bh': ('ebx', 1, 8)}
M32 = 0xffffffff
MAX_STATES = 200000


class Observed(Exception):
    pass


def part(name):
    """-> (full register, width in bytes, shift in bits)"""
    if name in GP:
        return name, 4, 0
    return PARTS[name]


def wmask(w):
    return (1 << (8 * w)) - 1


class Flow:
    def __init__(self, fn):
        self.fn = fn

    # ---- operand access --------------------------------------------------------------------------------------------------------------------------

    def addr_check(self, ins, op, t):
        for r in (op.mem.base, op.mem.index):
            if r and t[ins.reg_name(r)]:
                raise Observed('address register %s' % ins.reg_name(r))
        if op.mem.segment:
            raise Observed('segment override')

    def read(self, ins, op, t):
        """-> the difference mask of an operand (in its own width)"""
        if op.type == E.IMM_OP:
            return 0
        if op.type == E.REG_OP:
            full, w, sh = part(ins.reg_name(op.reg))
            return (t[full] >> sh) & wmask(w)
        self.addr_check(ins, op, t)
        return 0

    def write(self, ins, op, v, t):
        """set the operand to a value whose difference mask is `v`"""
        if op.type == E.REG_OP:
            full, w, sh = part(ins.reg_name(op.reg))
            t[full] = (t[full] & ~(wmask(w) << sh) & M32) | ((v & wmask(w)) << sh)
            return
        self.addr_check(ins, op, t)
        if v & wmask(op.size):
            raise Observed('a difference is stored')

    # ---- one instruction -------------------------------------------------------------------------------------------------------------------------

    def step(self, ins, t, fl):
        """-> (t, fl) after `ins`, or raises Observed; t is a dict register -> mask, fl a bool"""
        m = ins.mnemonic
        ops = ins.operands
        t = dict(t)
        clean = not any(t.values()) and not fl
        if m in ('nop', 'cld', 'std', 'fwait', 'int3') or clean:
            return t, fl
        if m == 'mov':
            self.write(ins, ops[0], self.read(ins, ops[1], t), t)
            return t, fl
        if m == 'movzx':
            self.write(ins, ops[0], self.read(ins, ops[1], t), t)
            return t, fl
        if m == 'movsx':
            v = self.read(ins, ops[1], t)
            w = ops[1].size
            if v >> (8 * w - 1) & 1:
                v |= M32 & ~wmask(w)
            self.write(ins, ops[0], v, t)
            return t, fl
        if m == 'lea':
            self.addr_check(ins, ops[1], t)
            self.write(ins, ops[0], 0, t)
            return t, fl
        if m in ('xor', 'sub') and ops[0].type == E.REG_OP and ops[1].type == E.REG_OP and ops[0].reg == ops[1].reg:
            self.write(ins, ops[0], 0, t)
            return t, False
        if m in ('and', 'or', 'xor'):
            a, b = self.read(ins, ops[0], t), self.read(ins, ops[1], t)
            w = ops[0].size
            if ops[1].type == E.IMM_OP:
                imm = ops[1].imm & wmask(w)
                r = a & imm if m == 'and' else (a & ~imm & wmask(w) if m == 'or' else a)
            else:
                r = a | b
            self.write(ins, ops[0], r, t)
            return t, bool(r)
        if m in ('add', 'sub', 'adc', 'sbb'):
            if m in ('adc', 'sbb') and fl:
                raise Observed('carry in with differing flags')
            a, b = self.read(ins, ops[0], t), self.read(ins, ops[1], t)
            u = a | b
            w = ops[0].size
            r = (wmask(w) & ~((u & -u) - 1)) if u else 0          # a carry or borrow spreads a difference upwards
            self.write(ins, ops[0], r, t)
            return t, bool(u)
        if m in ('cmp', 'test'):
            return t, bool(self.read(ins, ops[0], t) | self.read(ins, ops[1], t))
        if m in ('inc', 'dec', 'neg'):
            a = self.read(ins, ops[0], t)
            w = ops[0].size
            r = (wmask(w) & ~((a & -a) - 1)) if a else 0
            self.write(ins, ops[0], r, t)
            return t, (fl if m != 'neg' else False) or bool(a)
        if m == 'not':
            return t, fl
        if m in ('shl', 'shr', 'sar', 'sal') and len(ops) == 2 and ops[1].type == E.IMM_OP and 0 < (ops[1].imm & 31) < 8 * ops[0].size:
            c = ops[1].imm & 31
            w = ops[0].size
            a = self.read(ins, ops[0], t)
            if m in ('shl', 'sal'):
                r, out = (a << c) & wmask(w), (a >> (8 * w - c)) & 1
            elif m == 'shr':
                r, out = a >> c, (a >> (c - 1)) & 1
            else:
                r = (a >> c) | ((wmask(w) ^ (wmask(w) >> c)) if a >> (8 * w - 1) & 1 else 0)
                out = (a >> (c - 1)) & 1
            self.write(ins, ops[0], r, t)
            return t, bool(r or out)
        if m in ('shl', 'shr', 'sar', 'sal', 'rol', 'ror', 'rcl', 'rcr'):
            raise Observed('shift or rotate with a count the model does not follow')
        if m == 'imul' or m in ('mul', 'div', 'idiv'):
            used = [self.read(ins, o, t) for o in ops]
            if m in ('mul', 'div', 'idiv') or len(ops) == 1:
                used += [t['eax'], t['edx']]
            if any(used):
                raise Observed('multiplication or division of a differing value')
            if m == 'imul' and len(ops) >= 2:
                self.write(ins, ops[0], 0, t)
            else:
                t['eax'] = t['edx'] = 0
            return t, fl          # ZF, SF and PF are undefined after a multiplication or division: the differing flags stay
        if m == 'cdq':
            t['edx'] = M32 if t['eax'] >> 31 & 1 else 0
            return t, fl
        if m == 'cwde':
            v = t['eax'] & 0xffff
            t['eax'] = v | (0xffff0000 if v >> 15 & 1 else 0)
            return t, fl
        if m == 'xchg':
            a, b = self.read(ins, ops[0], t), self.read(ins, ops[1], t)
            self.write(ins, ops[0], b, t)
            self.write(ins, ops[1], a, t)
            return t, fl
        if m == 'push':
            if self.read(ins, ops[0], t) or t['esp']:
                raise Observed('a difference is pushed')
            return t, fl
        if m == 'pop':
            self.write(ins, ops[0], 0, t)
            return t, fl
        if m == 'leave':
            if t['ebp'] or t['esp']:
                raise Observed('leave with a differing frame register')
            t['ebp'] = 0
            return t, fl
        if m.startswith('set'):
            if fl:
                raise Observed('setcc on differing flags')
            self.write(ins, ops[0], 0, t)
            return t, fl
        if m.startswith('cmov'):
            if fl:
                raise Observed('cmov on differing flags')
            self.write(ins, ops[0], self.read(ins, ops[0], t) | self.read(ins, ops[1], t), t)
            return t, fl
        if m == 'sahf':
            return t, bool(t['eax'] >> 8 & 0xff)
        if m in ('fnstsw', 'fstsw'):
            if ops and ops[0].type == E.REG_OP:
                self.write(ins, ops[0], 0, t)
            return t, fl
        if m.startswith('f') and m not in ('fs',):
            for o in ops:
                if o.type == E.MEM_OP:
                    self.addr_check(ins, o, t)
            return t, fl
        raise Observed('instruction %s is not modelled while a difference is alive' % m)

    # ---- the walk --------------------------------------------------------------------------------------------------------------------------------

    def explained(self, addr, t0, fl0):
        """True when the difference (t0, fl0) established AFTER the instruction at `addr` never reaches anything observable"""
        fn = self.fn
        work = [(s, tuple(t0[r] for r in GP), fl0) for s in fn.succ.get(addr, [])]
        if addr in fn.exits and (any(t0.values()) or fl0):
            return False
        seen = set()
        while work:
            pc, tv, fl = work.pop()
            if not any(tv) and not fl:
                continue
            if (pc, tv, fl) in seen:
                continue
            seen.add((pc, tv, fl))
            if len(seen) > MAX_STATES:
                return False
            ins = fn.at.get(pc)
            if ins is None:
                return False
            t = dict(zip(GP, tv))
            m = ins.mnemonic
            try:
                if m == 'ret' or m == 'call':
                    raise Observed(m)
                if m == 'jmp' or (m.startswith('j') and m != 'jmp'):
                    if ins.operands[0].type == E.MEM_OP:          # a jump table: its entries are the successors (FL-45 TableFunction); the index must be the same in both
                        self.addr_check(ins, ins.operands[0], t)
                    elif ins.operands[0].type != E.IMM_OP:
                        raise Observed('indirect jump')
                    if m != 'jmp' and fl:
                        raise Observed('conditional jump on differing flags')
                    if pc in fn.exits and ins.operands[0].type == E.IMM_OP and ins.operands[0].imm not in fn.at:
                        raise Observed('jump out of the function')
                    nt, nfl = t, fl
                else:
                    nt, nfl = self.step(ins, t, fl)
            except Observed:
                return False
            if pc == addr:          # the mutated instruction runs again (a loop): its inputs may differ now, and the mutation itself differs again
                nt = {r: nt[r] | t0[r] for r in GP}
                nfl = nfl or fl0
            ntv = tuple(nt[r] for r in GP)
            for s in fn.succ.get(pc, []):
                work.append((s, ntv, nfl))
            if pc in fn.exits and m != 'jmp' and not (m.startswith('j')) and (any(ntv) or nfl):
                return False
        return True


# ---- the initial difference of a mutated statement -------------------------------------------------------------------------------------------------

ASSIGN = re.compile(r'\b(eax|ecx|edx|ebx|esi|edi|ebp|esp)\s*=(?!=)')


def strip(line):
    return re.sub(r'\s*/\*.*?\*/', '', line).strip()


def initial_difference(orig_line, mut_line):
    """-> (t0 {register: mask}, fl0) for the mutated statement, or None when the statement is not one of the modelled shapes"""
    import fl64_rules as R
    o, mu = strip(orig_line), strip(mut_line)
    if re.search(r'\bWR\d+\(|FL41_CALL|goto|\bif \(|fl41_|\bfp\b|long double|FL41_F|FL41_TRAP|h->|\bint64_t d_|\bd_\b', o + mu):
        return None          # a store, a call, a jump, the x87 stack, a trap or a division: effects other than the registers and flags that this module follows
    t0 = {r: 0 for r in GP}
    po = R.pure_form(orig_line)
    if po is not None and po[0] == 'reg':
        pm = R.pure_form(mut_line) if mu not in ('', ';') else ('reg', po[1], po[1])
        if pm is None or pm[:2] != po[:2]:
            return None
        try:
            import z3
        except ImportError:
            return None
        memory = z3.Function('byte', z3.BitVecSort(32), z3.BitVecSort(8))
        env = {'regs': {r: z3.BitVec('in_' + r, 32) for r in R.REGS}, 'byte': memory}
        try:
            a = R.Expr(po[2], env, z3).parse()
            b = R.Expr(pm[2], env, z3).parse()
        except R.Unsupported:
            return None
        mask = 0
        for bit in range(32):
            s = z3.Solver()
            s.set('timeout', 10000)
            s.add(z3.Extract(bit, bit, a) != z3.Extract(bit, bit, b))
            res = s.check()
            if res != z3.unsat:
                mask |= 1 << bit
        t0[po[1]] = mask
        return t0, False
    regs = set(ASSIGN.findall(o)) | set(ASSIGN.findall(mu))
    if regs & {'esp', 'ebp'} or (not regs and 'FL41_' not in o):
        return None
    for r in regs:
        t0[r] = M32
    return t0, True          # a statement that is not `reg = expr;` may leave any bit of what it assigns, and the flags, different


def unobserved_ok(kind, lines, n, variants, row, fn):
    """rule 5 `unobserved bits`: every variant's difference dies out before anything observes it"""
    if fn is None or not variants or kind not in ('width', 'literal', 'drop', 'alu', 'register'):
        return False
    m = re.search(r'/\* (0x[0-9a-f]+): ', lines[n])
    if not m:
        return False
    addr = int(m.group(1), 16)
    if addr not in fn.at:
        return False
    flow = Flow(fn)
    for mut in variants:
        init = initial_difference(lines[n], mut)
        if init is None:
            return False
        t0, fl0 = init
        if not flow.explained(addr, t0, fl0):
            return False
    return True
