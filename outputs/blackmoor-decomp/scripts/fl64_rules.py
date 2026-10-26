#!/usr/bin/env python3
"""FL-64: survivor rules for the lower (FL-40 family) rows that the FL-41 family already had, plus new ones that need the value of a register or of an object field.

scripts/fl40_survivors.py (rows below 0x480000) only knew the FL-44 frame-slot ranges, while scripts/fl41_survivors.py (rows from 0x480000) had grown the FL-45 interval analysis (16-bit
loop counters, signed/unsigned jump agreement, `flags`, `relation`, ...). The two families translate with the same statement shapes (`RDn((uint32_t)(ebp + 0x..u))`, `{ uint32_t a_ = .., b_ = .., r_;
FL4x_SUB(a_, b_, 0u, r_, 32); }`), only the macro prefix differs. `lower_rules()` renames FL40_ to FL41_ in the row's text and in the mutant's line and asks the FL-41 classifier with the FL-45
ranges of the ORIGINAL instructions. A survivor entry of a lower log does not say which mutant of the line it is (the entries are `(kind, line, 'survives')`), so a line is explained only when
EVERY mutant that the checker builds for that kind and line is explained.

New in this module:
  folded constant  (rule 1) the register operands of a pure assignment are constants on the straight line that leads to it (loaded from a constant, from a global that a store of a constant
                   forwards, shifted, added), and original and mutant statement compute the same value for every value of the unknown parts (z3 over 32-bit vectors).
"""
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))


def to41(text):
    return text.replace('FL40_', 'FL41_')


def lower_rules(kind, lines, n, variants, ranges, proofs):
    """-> a class name when every variant (the mutant lines of this kind and line) is explained by an FL-41 rule given the FL-45 ranges, else None"""
    import fl41_survivors as FS
    if not variants:
        return None
    lines41 = [to41(l) for l in lines]
    classes = []
    for mut in variants:
        cls = FS.classify(kind, lines41, n, False, proofs, to41(mut), ranges, None)
        if cls is None or cls == 'identical code':
            return None
        classes.append(cls)
    return classes[0] if len(set(classes)) == 1 else '/'.join(sorted(set(classes)))


# ---- statement semantics (z3) for rule 1 ---------------------------------------------------------------------------------------------------------------------------------------------

TOKEN = re.compile(r'\s*(0x[0-9a-f]+u?|\d+u?|[A-Za-z_]\w*|<<|>>|[-+*&|^~(),])')
CASTS = {'uint32_t': ('z', 32), 'int32_t': ('z', 32), 'uint16_t': ('z', 16), 'int16_t': ('s', 16), 'uint8_t': ('z', 8), 'int8_t': ('s', 8)}
REGS = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi', 'ebp', 'esp')


class Unsupported(Exception):
    pass


class Expr:
    """a recursive-descent parser of the C expressions of the pure statements (`reg = expr;`, `WRn(addr, expr);`) into z3 32-bit vectors; every other construct raises Unsupported"""

    def __init__(self, text, env, z3):
        self.z3 = z3
        self.toks = TOKEN.findall(text)
        if ''.join(self.toks).replace(' ', '') != re.sub(r'\s+', '', text):
            raise Unsupported('tokens')
        self.i = 0
        self.env = env

    def peek(self):
        return self.toks[self.i] if self.i < len(self.toks) else None

    def take(self, want=None):
        t = self.peek()
        if t is None or (want is not None and t != want):
            raise Unsupported('expected %s' % want)
        self.i += 1
        return t

    def parse(self):
        v = self.binary(0)
        if self.peek() is not None:
            raise Unsupported('trailing')
        return v

    LEVELS = [('|',), ('^',), ('&',), ('<<', '>>'), ('+', '-'), ('*',)]

    def binary(self, lvl):
        if lvl == len(self.LEVELS):
            return self.unary()
        a = self.binary(lvl + 1)
        while self.peek() in self.LEVELS[lvl]:
            op = self.take()
            b = self.binary(lvl + 1)
            a = {'|': lambda: a | b, '^': lambda: a ^ b, '&': lambda: a & b, '<<': lambda: a << b, '>>': lambda: self.z3.LShR(a, b), '+': lambda: a + b, '-': lambda: a - b, '*': lambda: a * b}[op]()
        return a

    def unary(self):
        z3 = self.z3
        t = self.peek()
        if t == '~':
            self.take()
            return ~self.unary()
        if t == '-':
            self.take()
            return -self.unary()
        if t == '(':
            if self.i + 2 < len(self.toks) and self.toks[self.i + 1] in CASTS and self.toks[self.i + 2] == ')':
                kind, bits = CASTS[self.toks[self.i + 1]]
                self.i += 3
                v = self.unary()
                if bits == 32:
                    return v
                low = z3.Extract(bits - 1, 0, v)
                return z3.SignExt(32 - bits, low) if kind == 's' else z3.ZeroExt(32 - bits, low)
            self.take('(')
            v = self.binary(0)
            self.take(')')
            return v
        if t is None:
            raise Unsupported('end')
        self.take()
        if re.fullmatch(r'0x[0-9a-f]+u?|\d+u?', t):
            return z3.BitVecVal(int(t.rstrip('u'), 0) & 0xffffffff, 32)
        m = re.fullmatch(r'RD(8|16|32)', t)
        if m and self.peek() == '(':
            self.take('(')
            addr = self.binary(0)
            self.take(')')
            n = int(m.group(1)) // 8
            parts = [self.env['byte'](addr + z3.BitVecVal(k, 32)) for k in range(n)]
            v = z3.Concat(*reversed(parts)) if n > 1 else parts[0]
            return z3.ZeroExt(32 - 8 * n, v) if n < 4 else v
        if t in self.env['regs']:
            return self.env['regs'][t]
        raise Unsupported('name %s' % t)


def pure_form(line):
    """-> ('reg', name, expr text) | ('wr', width, addr text, value text) | None for the statement of a line (comments removed)"""
    t = re.sub(r'\s*/\*.*?\*/', '', line).strip()
    m = re.fullmatch(r'(eax|ecx|edx|ebx|esi|edi) = ([^;{}]+);', t)
    if m:
        return ('reg', m.group(1), m.group(2))
    m = re.fullmatch(r'WR(8|16|32)\(((?:[^,()]|\([^()]*\))+), (.+)\);', t)
    if m:
        return ('wr', int(m.group(1)), m.group(2), m.group(3))
    return None


def folded_ok(kind, lines, n, variants, cells):
    """rule 1 `folded constant`: the register operands of the statement are constants (or one of a few constants) in every reachable state at that instruction, and the mutant computes the very same
    assignment or store as the translation for every value of the rest (z3). Only the statements `reg = expr;` and `WRn(addr, expr);`, whose mutants are `literal` ones."""
    if kind != 'literal' or cells is None or not variants:
        return False
    try:
        import z3
    except ImportError:
        return False
    m = re.search(r'/\* (0x[0-9a-f]+): ', lines[n])
    if not m or int(m.group(1), 16) not in cells.regs:
        return False
    regvals = cells.regs[int(m.group(1), 16)]
    orig = pure_form(lines[n])
    if orig is None:
        return False
    memory = z3.Function('byte', z3.BitVecSort(32), z3.BitVecSort(8))
    names = {r: z3.BitVec('in_' + r, 32) for r in REGS}
    constraints = []
    for r in ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi'):
        vals = regvals.get(r, {None})
        if any(not (isinstance(v, int) or (isinstance(v, tuple) and v[0] == 'lo')) for v in vals):
            continue
        # a whole value, or only the low 8/16 bits known (`('lo', bits, v)`): the register is one of these in every reachable state
        constraints.append(z3.Or(*[(names[r] == z3.BitVecVal(v, 32)) if isinstance(v, int) else (z3.Extract(v[1] - 1, 0, names[r]) == z3.BitVecVal(v[2], v[1]))
                                   for v in sorted(vals, key=repr)]))
    env = {'regs': names, 'byte': memory}

    def value(form):
        if form[0] == 'reg':
            return [Expr(form[2], env, z3).parse()]
        return [Expr(form[2], env, z3).parse(), Expr(form[3], env, z3).parse()]

    try:
        a = value(orig)
        for mut in variants:
            mf = pure_form(mut)
            if mf is None or mf[:2] != orig[:2] or (orig[0] == 'wr' and mf[1] != orig[1]):
                return False
            b = value(mf)
            s = z3.Solver()
            s.set('timeout', 20000)
            for c in constraints:
                s.add(c)
            s.add(z3.Or(*[x != y for x, y in zip(a, b)]))
            if s.check() != z3.unsat:
                return False
        return True
    except Unsupported:
        return False


def cell_width_ok(kind, lines, n, variants, cells):
    """rules 2 and 3 `cell range`: a narrower read (RD32 -> RD16/RD8, RD16 -> RD8) of a cell whose value is a known small number in every reachable state at that instruction (scripts/fl64_cells.py:
    a loop counter, a bound stored in an object field and tested earlier, a constant that was stored). The omitted bytes are zero, so the narrower read returns the same number. The line must hold
    exactly one memory access, the read, and the instruction must have one memory operand of the original width."""
    if kind != 'width' or cells is None or not variants:
        return False
    import fl41_survivors as FS
    text = re.sub(r'\s*/\*.*?\*/', '', lines[n]).strip()
    if len(re.findall(r'\b(?:RD|WR)\d+\(', text)) != 1 or 'RD' not in text:
        return False
    m = re.search(r'/\* (0x[0-9a-f]+): ', lines[n])
    if not m:
        return False
    addr = int(m.group(1), 16)
    vals = cells.reads.get(addr)
    if not vals or any(not isinstance(v, int) for v in vals):
        return False
    size = cells.sizes.get(addr)
    for mut in variants:
        change = FS.read_change(to41(text), to41(re.sub(r'\s*/\*.*?\*/', '', mut).strip()))
        if not change:
            return False
        wa, wb = change[0], change[1]
        if size != wa // 8 or wb >= wa or any(v >= (1 << wb) or v >= (1 << wa) for v in vals):
            return False
    return True


def explain(kind, lines, n, row, variants, ranges, proofs, cells=None):
    cls = lower_rules(kind, lines, n, variants, ranges, proofs)
    if cls is None and cell_width_ok(kind, lines, n, variants, cells):
        cls = 'cell range'
    if cls is None and folded_ok(kind, lines, n, variants, cells):
        cls = 'folded constant'
    return cls
