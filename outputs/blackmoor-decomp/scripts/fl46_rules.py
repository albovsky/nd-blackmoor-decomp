#!/usr/bin/env python3
"""FL-46: survivor rules from liveness on the lifted C statements of a row (scripts/fl40_survivors.py calls `explain`).

A mutated statement is harmless when everything it can change is dead afterwards on every path:
  dead flags      a statement that only sets flags (`cmp`, `test`) and all of cf zf sf of pf are dead after it; for the operand swap of a `cmp` (a - b against b - a) zf is the one flag
                  that is equal, so zf may be live
  dead register   a statement that only assigns one register (a load, a `lea`, `xor reg, reg`) whose register is dead after it (and, when the statement also sets flags, the flags are dead)
  equal push      `push A` mutated to `push B` where A and B hold the same value on every path to it (both equal one frame slot, see available_copies)
Liveness is a backward data flow over the statements of the function (the CFG of available_copies). Anything the analysis does not understand reads everything: a statement that is not a
plain `reg = expr;` kills nothing, a call reads all registers, and flags are read wherever the name of a flag occurs outside an assignment to it. At a return (`goto done`) eax, ebx, esi, edi, ebp
and esp are live and ecx, edx and the flags are not: the callers of these functions treat ecx and edx as scratch (assumption of this rule, written in tasks/fl46-handoff.md).
Functions with loops written as C loops, switches or unusual frames are not analysed.
"""
import random
import re
import sys
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))

REGS = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi', 'ebp', 'esp')
FLAGS = ('cf', 'zf', 'sf', 'of', 'pf')
EXIT_REGS = frozenset(('eax', 'ebx', 'esi', 'edi', 'ebp', 'esp'))
LABEL = re.compile(r'^(L_[0-9a-f]+|done):$')
FLAG_READ = re.compile(r'\b(cf|zf|sf|of|pf)\b(?!\s*=[^=])')
SIMPLE_DEF = re.compile(r'^(eax|ecx|edx|ebx|esi|edi) = ([^;{}]*);$')
BLOCK_DEF = re.compile(r'^\{ uint32_t a_ = [^;]*, b_ = [^;]*, r_;( r_ = a_ [-+&|^] b_;)? FL40_(ADD|SUB|LOGIC)\([^;]*\); (eax|ecx|edx|ebx|esi|edi) = r_; \}$')
FLAG_ONLY = re.compile(r'^\{ uint32_t a_ = [^;]*, b_ = [^;]*, r_;( r_ = a_ [-+&|^] b_;)? FL40_(ADD|SUB|LOGIC)\([^;]*\); \}$')
SWAP_SUB = re.compile(r'^\{ uint32_t a_ = [^;]*, b_ = [^;]*, r_; FL40_SUB\(a_, b_, 0u, r_, \d+\); \}$')
PUSH = re.compile(r'^esp -= 4u; WR32\(esp, (eax|ecx|edx|ebx|esi|edi)\);$')


def SWAP_OPERANDS(t):
    """the statement with the two operands of its compare exchanged, as tests/fl40_mutation_check.py builds the 'register' mutant of a compare"""
    return re.sub(r'a_ = ([^,]+), b_ = ([^,;]+),', r'a_ = \2, b_ = \1,', t, count=1)


def stmt(line):
    return re.sub(r'\s*/\*.*', '', line).strip()


def graph(lines):
    """-> (texts, stmts, succ, exits) or None when the function is not analysable"""
    texts = [stmt(l) for l in lines]
    start = next((i for i, t in enumerate(texts) if t.startswith('FL40_PROLOGUE')), None)
    stop = next((i for i, t in enumerate(texts) if t.startswith('FL40_EPILOGUE')), None)
    if start is None or stop is None:
        return None
    ids = []
    i = start + 1
    while i < stop:
        if not texts[i] or texts[i].startswith('/*'):
            i += 1
            continue
        depth = texts[i].count('{') - texts[i].count('}')
        j = i
        while depth > 0 and j + 1 < stop and not LABEL.match(texts[i]):     # a multi-line block (rep loop, idiv, switch) is one statement
            j += 1
            texts[i] += ' ' + texts[j]
            depth += texts[j].count('{') - texts[j].count('}')
        if depth != 0 and texts[i] not in ('{', '}'):
            return None
        ids.append(i)
        i = j + 1
    whole = '\n'.join(texts[i] for i in ids)
    if re.search(r'FL40_CALL_LIFTED', whole):
        return None
    labels, pending = {}, []
    for i in ids:
        if LABEL.match(texts[i]):
            pending.append(texts[i][:-1])
            continue
        for lab in pending:
            labels[lab] = i
        pending = []
    stmts = [i for i in ids if not LABEL.match(texts[i]) and texts[i] not in ('{', '}')]
    succ, exits = {}, set()
    for pos, i in enumerate(stmts):
        t = texts[i]
        nxt = stmts[pos + 1] if pos + 1 < len(stmts) else None
        outs = []
        targets = re.findall(r'goto (L_[0-9a-f]+|done);', t)
        if targets:
            for tg in targets:
                if tg == 'done':
                    exits.add(i)
                elif labels.get(tg) is not None:
                    outs.append(labels[tg])
                else:
                    return None
            if nxt is not None and 'switch (' not in t and (t.startswith('if (') or len(targets) > 1 or not t.rstrip().endswith('goto %s;' % targets[-1])):
                outs.append(nxt)
        elif nxt is not None:
            outs.append(nxt)
        succ[i] = outs
    return texts, stmts, succ, exits


FULL = 0xffffffff
GP = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')
PARTIAL = re.compile(r'^(eax|ecx|edx|ebx|esi|edi) = \(\1 & 0x([0-9a-f]+)u\) \| \((.+) & 0x([0-9a-f]+)u\);$')
MASKED = re.compile(r'\b(eax|ecx|edx|ebx|esi|edi|ebp|esp) & 0x([0-9a-f]+)u\b')
NARROW_WR = re.compile(r'(\bWR(8|16)\((?:\(uint32_t\)\([^()]*\)|\w+), )(eax|ecx|edx|ebx|esi|edi)\)')
TOKEN = re.compile(r'\b(eax|ecx|edx|ebx|esi|edi|ebp|esp)\b')


def expr_uses(text):
    """-> {register: bits of it the text can depend on}; a register named outside the two narrow shapes (`reg & mask`, the value of a WR8/WR16) is used whole"""
    uses = {}

    def note(reg, mask):
        uses[reg] = uses.get(reg, 0) | mask
    text = MASKED.sub(lambda m: note(m.group(1), int(m.group(2), 16)) or '#', text)
    text = NARROW_WR.sub(lambda m: note(m.group(3), (1 << int(m.group(2))) - 1) or m.group(1) + '#)', text)
    for reg in TOKEN.findall(text):
        note(reg, FULL)
    return uses


def effects(t):
    """-> (uses {reg: bits}, kills {reg: bits}, copy (dst, src) or None, keeps {reg: bits} the bits a partial definition passes through)"""
    if 'FL40_CALL' in t:
        return {r: FULL for r in REGS}, {}, None, {}
    m = PARTIAL.match(t)
    if m:
        keep, mask = int(m.group(2), 16), int(m.group(4), 16)
        if keep & mask == 0 and keep | mask == FULL:
            return expr_uses(m.group(3)), {m.group(1): mask}, None, {m.group(1): keep}
    m = SIMPLE_DEF.match(t)
    if m and not re.search(r'\bWR\d+|FL40_', m.group(2)):
        rhs = m.group(2).strip()
        if rhs in REGS:
            return {}, {m.group(1): FULL}, (m.group(1), rhs), {}
        return expr_uses(rhs), {m.group(1): FULL}, None, {}
    m = BLOCK_DEF.match(t)
    if m:
        body = t[:t.rindex(m.group(3) + ' = r_;')]
        return expr_uses(body), {m.group(3): FULL}, None, {}
    return expr_uses(t), {}, None, {}


def flag_effect(t):
    """-> (flags read, flags killed)"""
    reads = set(FLAG_READ.findall(t))
    kills = set(FLAGS) if re.search(r'FL40_(ADD|SUB|LOGIC|SHL|SHR|SAR)\(', t) else set()
    if t.startswith('while (') or t.startswith('{ uint32_t a_ = ') and 'if (n_ != 0u)' in t and not re.search(r'n_ = 0x[1-9a-f][0-9a-f]*u,', t):
        kills = set()       # a rep loop that may run zero times, a shift whose count may be zero: the flags may stay as they were
    return reads, kills


_CACHE = {}


def liveness(lines):
    if _CACHE.get('key') is not lines:
        g = graph(lines)
        if g is None:
            _CACHE.update(key=lines, value=None)
        else:
            texts, stmts, succ, exits = g
            eff = {i: effects(texts[i]) for i in stmts}
            feff = {i: flag_effect(texts[i]) for i in stmts}
            live_r = {i: {r: 0 for r in REGS} for i in stmts}      # live-in
            out_r = {i: {r: 0 for r in REGS} for i in stmts}
            live_f = {i: set() for i in stmts}
            out_f = {i: set() for i in stmts}
            changed = True
            while changed:
                changed = False
                for i in reversed(stmts):
                    o_r = {r: (FULL if i in exits and r in EXIT_REGS else 0) for r in REGS}
                    o_f = set()
                    for j in succ[i]:
                        for r in REGS:
                            o_r[r] |= live_r[j][r]
                        o_f |= live_f[j]
                    uses, kills, copy, keeps = eff[i]
                    in_r = {r: (o_r[r] & ~kills.get(r, 0) & FULL) | uses.get(r, 0) for r in REGS}
                    if copy:
                        in_r[copy[1]] |= o_r[copy[0]]
                    f_reads, f_kills = feff[i]
                    in_f = f_reads | (o_f - f_kills)
                    if o_r != out_r[i] or o_f != out_f[i] or in_r != live_r[i] or in_f != live_f[i]:
                        out_r[i], out_f[i], live_r[i], live_f[i] = o_r, o_f, in_r, in_f
                        changed = True
            _CACHE.update(key=lines, value=(texts, out_r, out_f))
    return _CACHE['value']


_MUT = {}


def mutants_of(lines, row, kind, n):
    from fl40_mutation_check import mutants
    key = (id(lines), row)
    if _MUT.get('key') != key:
        _MUT.clear()
        _MUT['key'] = key
        _MUT['all'] = mutants('\n'.join(lines), int(row, 16), random.Random(int(row, 16)), 100000)
    return [m[2].split('\n')[n] for m in _MUT['all'] if m[0] == kind and m[1] == n]


RD_WIDTH = re.compile(r'\bRD(8|16|32)\(')


def explain(kind, lines, n, row):
    """a short name of the rule that proves every mutant of (kind, line n) harmless, else None"""
    if row is None:
        return None
    lv = liveness(lines)
    if lv is None:
        return None
    texts, out_r, out_f = lv
    if n not in out_r:
        return None
    t = texts[n]
    mut = [stmt(m) for m in mutants_of(lines, row, kind, n)]
    if not mut:
        return None
    flags_live = out_f[n]
    if FLAG_ONLY.match(t):
        if not flags_live:
            return 'dead flags'
        if kind == 'register' and SWAP_SUB.match(t) and flags_live <= {'zf'} and all(x == SWAP_OPERANDS(t) for x in mut):     # a - b == 0 exactly when b - a == 0
            return 'dead flags'
        return None
    m = BLOCK_DEF.match(t)
    if m:
        if kind != 'drop' and not all(('%s = r_;' % m.group(3)) in x for x in mut):
            return None         # a mutant that moves the destination is not covered by the liveness of this one
        return 'dead register' if out_r[n][m.group(3)] == 0 and not flags_live else None
    uses, kills, copy, keeps = effects(t)
    single = [r for r in kills if r in GP]
    if len(single) == 1 and (PARTIAL.match(t) or (SIMPLE_DEF.match(t) and not re.search(r'\bWR\d+|FL40_', SIMPLE_DEF.match(t).group(2)))):
        reg = single[0]
        live = out_r[n][reg]
        if kind != 'drop' and not all(x.startswith(reg + ' = ') for x in mut):
            return None         # a mutant that writes another register is not covered by the liveness of this one
        if live == 0 or (PARTIAL.match(t) and kind == 'drop' and live & kills[reg] == 0):
            return 'dead register'
        changed = 0
        for x in mut:
            mp = PARTIAL.match(x) if PARTIAL.match(t) else None
            if kind == 'width':
                wo, wm = RD_WIDTH.search(t), RD_WIDTH.search(x)
                if not (wo and wm and x.startswith(reg + ' = ') and RD_WIDTH.sub('', t, 1) != '' and len(RD_WIDTH.findall(t)) == 1 and len(RD_WIDTH.findall(x)) == 1):
                    return None
                lo = min(int(wo.group(1)), int(wm.group(1)))
                changed |= FULL & ~((1 << lo) - 1) & (kills[reg] if PARTIAL.match(t) else FULL)
            elif kind == 'literal' and mp:
                orig = PARTIAL.match(t)
                if mp.group(3) != orig.group(3) or int(mp.group(4), 16) != int(orig.group(4), 16):
                    return None
                changed |= int(mp.group(2), 16) ^ int(orig.group(2), 16)
            else:
                return None
        return 'narrow demand' if live & changed == 0 else None
    if kind == 'register' and PUSH.match(t):
        import fl40_survivors as S
        facts = S.available_copies(lines)
        if facts is None or facts.get(n) is None:
            return None
        a = PUSH.match(t).group(1)
        for x in mut:
            mb = PUSH.match(x)
            if not mb:
                return None
            b = mb.group(1)
            if not any((a, s) in facts[n] and (b, s) in facts[n] for s in {f[1] for f in facts[n]}):
                return None
        return 'equal push'
    return None
