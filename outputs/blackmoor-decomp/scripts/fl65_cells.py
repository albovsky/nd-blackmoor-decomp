#!/usr/bin/env python3
"""FL-65: the cell engine of FL-64 (scripts/fl64_cells.py) with the flags before every instruction recorded, and the survivor rules that read them.

  explore(va, size) -> fl64_cells.Facts with an extra `flags` {instruction address: set of (cf, zf, sf, of) before it, each True/False/None}, or None (as fl64_cells.explore)

  `known flags` (rule 4): a conditional jump whose condition, in the original and in the mutant, reads only flags that are KNOWN in every reachable state at that instruction, and the two conditions
                 agree in every one of those states. The exploration forks a jump on an unknown flag and keeps every state otherwise, so the set of flag tuples is exhaustive for the function (the
                 bounded-by-constants property of fl64_cells.explore); the tests/test_fl65_flags.py replay checks it against the corpus seeds on the original bytes.
"""
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl43_equiv as E
import fl64_cells as C


def explore(va, size, max_states=None):
    max_states = max_states or C.MAX_STATES
    try:
        f = E.Function(va, size)
        for i in f.ins:
            if (i.mnemonic.startswith('j') and i.mnemonic != 'jmp' and i.mnemonic not in C.JCC) or i.mnemonic.startswith('loop'):
                raise C.Refused('conditional transfer %s at 0x%x is not followed' % (i.mnemonic, i.address))
            for op in i.operands:
                if op.type == E.MEM_OP and i.mnemonic != 'lea':
                    C.addr_value(i, op, [0] * 6)
    except (E.NoProof, C.Refused) as exc:
        C.LAST['why'] = repr(exc)
        return None
    facts = C.Facts()
    facts.flags = {}
    entry_regs = tuple(('s', 'in_' + r, 0) for r in C.GP)
    args = {op.mem.disp for i in f.ins for op in i.operands if op.type == E.MEM_OP and i.mnemonic != 'lea' and i.reg_name(op.mem.base) == 'ebp' and not op.mem.index and op.mem.disp >= 8 and op.size == 4}
    start = C.State(entry_regs, frozenset((('f', d), 4, ('s', 'arg%d' % d, 0)) for d in args), (None,) * 4)
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
                C.LAST['why'] = 'more than %d states' % max_states
                return None
            facts.states = len(seen)
            ins = f.at[pc]
            reg_view = facts.regs.setdefault(pc, {})
            for n, r in enumerate(C.GP):
                reg_view.setdefault(r, set()).add(st.regs[n])
            facts.flags.setdefault(pc, set()).add(st.flags)
            for nxt_pc, nst in C.step(f, ins, st, facts):
                if nxt_pc is not None and nxt_pc in f.at:
                    work.append((nxt_pc, nst))
    except C.Refused as exc:
        C.LAST['why'] = repr(exc)
        return None
    return facts


JUMP = re.compile(r'if \((.*)\) goto (\w+);')
COND = re.compile(r'==|!=|&&|\|\||[!()]|\b(?:cf|zf|sf|of)\b|\s+')


def cond_of(line):
    t = re.sub(r'\s*/\*.*?\*/', '', line).strip()
    m = JUMP.fullmatch(t)
    if not m or COND.sub('', m.group(1)):
        return None
    return m.group(1), m.group(2)


def flags_known_ok(kind, lines, n, variants, facts):
    """rule 4 `known flags`"""
    if kind != 'jump' or facts is None or not variants:
        return False
    m = re.search(r'/\* (0x[0-9a-f]+): ', lines[n])
    states = facts.flags.get(int(m.group(1), 16)) if m else None
    orig = cond_of(lines[n])
    if not states or orig is None:
        return False
    for mut in variants:
        mc = cond_of(mut)
        if mc is None or mc[1] != orig[1]:
            return False
        for fl in states:
            env = dict(zip(('cf', 'zf', 'sf', 'of'), fl))
            used = set(re.findall(r'cf|zf|sf|of', orig[0] + ' ' + mc[0]))
            if any(env[u] is None for u in used):
                return False
            py = lambda c: eval(c.replace('&&', ' and ').replace('||', ' or ').replace('!=', ' @ ').replace('!', ' not ').replace(' @ ', ' != '), {'__builtins__': {}}, env)
            if bool(py(orig[0])) != bool(py(mc[0])):
                return False
    return True
