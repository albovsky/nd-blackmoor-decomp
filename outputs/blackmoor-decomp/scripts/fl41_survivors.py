#!/usr/bin/env python3
"""FL-40: sort the survivors of tests/fl41_mutation_check.py (its log as the argument) into those that are provably equivalent mutants and the rows that stay out.

A survivor is explained only when one of these holds for the mutated statement; everything else leaves its row pending:
  identical code   `cc -O2 -S` of the mutant and of the translation give the same assembly (scripts/fl41_o2_classify.py): a flag nothing reads, a dead store
  same value       a register reload `reg = RD(ebp +- k)` right after the store `WR(ebp +- k, reg)` or the load `reg = RD(ebp +- k)` of the same register, on straight-line code with no call, label, jump or
                   store that could hit the slot in between (a store through another register is assumed not to point into the function's own frame): the register already holds the value, so dropping the reload changes nothing
  cleanup          the bytes a played callee pops after a call (`esp += n`) when the next statement that touches esp is `esp = ebp` on straight-line code
  repeat, dead     (FL-43, scripts/fl43_equiv.py) a dropped instruction that data flow over the original instructions shows to be a no-op: the register already holds the value on every path
                   to it, or every register and flag it writes is overwritten before it is read
  frame            `ebp = esp` / `esp = ebp` where nothing reads ebp between that statement and the next `esp = ebp`, or a `sub esp, N` whose next esp-touching statement is `esp = ebp`
The earlier "local width" class (a narrower read of a frame local that the corpus never shows) is NOT an equivalence and is gone: those rows stay pending.

  fl41_survivors.py <mutation log> [--equiv tasks/fl41-o2-identical.json] [--out tasks/fl41-survivors.json]
"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl43_equiv as E

BARRIER = re.compile(r'FL41_CALL|goto|^L_|^done:|while|switch|case |FL41_EPILOGUE')


def stmt(line):
    return re.sub(r'\s*/\*.*', '', line).strip()


def aliasing_write(t, k):
    """a store in statement `t` that could overwrite the frame slot [ebp + k]: through ebp/esp with an overlapping slot, or with an address that is not register + offset of another register"""
    if not re.search(r'\bWR\d+\(', t):
        return False
    m = re.search(r'\bWR(\d+)\(\(uint32_t\)\((\w+)(?: \+ (0x[0-9a-f]+)u)?\)', t)
    if not m:
        m2 = re.search(r'\bWR(\d+)\((\w+),', t)
        return not (m2 and m2.group(2) == 'esp')            # a push: below the locals
    width, base, off = m.group(1), m.group(2), m.group(3)
    if base == 'ebp':
        a = int(off, 16) if off else 0
        b = int(k, 16)
        sa = a - (1 << 32) if a >= 1 << 31 else a
        sb = b - (1 << 32) if b >= 1 << 31 else b
        return abs(sa - sb) < 4 or abs(sa - sb) < int(width) // 8
    if re.match(r'^0x[0-9a-f]+u$', base):
        return False                                                  # an absolute address of the image: not the stack
    return base not in ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')      # another register + offset: assumed not to point into this function's own frame


def same_value(lines, n):
    """lines[n] is `reg = RD32((uint32_t)(ebp + K));`: the nearest earlier statement that matters is `WR32((uint32_t)(ebp + K), reg);`, with no call, label, jump,
    write to reg or store that could overwrite the slot in between (a store through another register is assumed not to point into the function's own frame)"""
    m = re.match(r'^(e[a-z]{2}) = RD32\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)\);$', stmt(lines[n]))
    if not m:
        return False
    reg, k = m.groups()
    want = 'WR32((uint32_t)(ebp + %su), %s);' % (k, reg)
    for j in range(n - 1, -1, -1):
        t = stmt(lines[j])
        if not t:
            continue
        if t.startswith(want) or t.startswith('%s = RD32((uint32_t)(ebp + %su));' % (reg, k)):
            return True
        if BARRIER.search(t) or t.startswith('{') or re.match(r'^%s\b' % reg, t) or re.search(r'\b%s = ' % reg, t) or aliasing_write(t, k):
            return False
    return False


def forward(lines, n, ok, stop):
    for j in range(n + 1, len(lines)):
        t = stmt(lines[j])
        if not t:
            continue
        if ok(t):
            return True
        if stop(t):
            return False
    return False


def cleanup_ok(lines, n):
    return 'FL41_CALL' in lines[n] and forward(lines, n, lambda t: t.startswith('esp = ebp;'),
                                               lambda t: 'esp' in t or BARRIER.search(t) or re.search(r'\bR?D\d+|\bWR\d+', t) and 'esp' in t)


def frame_ok(lines, n):
    t = stmt(lines[n])
    if not (t.startswith('ebp = esp;') or t.startswith('esp = ebp;')):
        return False
    return forward(lines, n, lambda x: x.startswith('esp = ebp;'), lambda x: 'ebp' in x or BARRIER.search(x))


def esp_adjust_ok(lines, n):
    """`sub esp, N` of a frame allocation in a function whose only other uses of esp are the prologue push, the epilogue (`esp = ebp`, the pop of ebp, the ret
    adjustment) and the pushes/calls of no statement: every return path restores esp from ebp, so the allocated size never shows"""
    if not re.search(r'\besp = r_;', stmt(lines[n])):
        return False
    body = [stmt(l) for l in lines]
    uses = [t for i, t in enumerate(body) if i != n and re.search(r'\besp\b', t) and not (i < n and t.startswith('ebp = esp;'))]
    plain = ('esp -= 4u; WR32(esp, ebp);', 'esp = ebp;', 'ebp = RD32(esp); esp += 4u;')
    for t in uses:
        if t.startswith(plain) or re.match(r'^esp \+= \d+u; goto done;', t):
            continue
        return False
    rets = sum(1 for t in body if 'goto done;' in t)
    return rets > 0 and sum(1 for t in body if t.startswith('esp = ebp;')) >= rets


def instruction_address(lines, n):
    m = re.search(r'/\* (0x[0-9a-f]+): ', lines[n])
    return int(m.group(1), 16) if m else None


def classify(kind, lines, n, equivalent, proofs=None):
    if equivalent:
        return 'identical code'
    if kind == 'drop' and proofs and proofs.get(instruction_address(lines, n)):
        return 'repeat' if proofs[instruction_address(lines, n)].startswith('repeat') else 'dead'
    if kind == 'drop' and same_value(lines, n):
        return 'same value'
    if kind == 'literal' and cleanup_ok(lines, n):
        return 'cleanup'
    if kind == 'register' and frame_ok(lines, n):
        return 'frame'
    if kind in ('alu', 'literal', 'register', 'drop') and esp_adjust_ok(lines, n):
        return 'frame'
    return None


def main():
    log = sys.argv[1]
    equiv = {}
    if '--equiv' in sys.argv:        # scripts/fl41_o2_classify.py: {row: [[kind, line], ...]} for the survivors whose -O2 assembly equals the translation's
        for row, items in json.loads(Path(sys.argv[sys.argv.index('--equiv') + 1]).read_text()).items():
            equiv[row] = {(kind, n, ident): True for kind, n, ident in items}
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    out = {'rows_with_survivors': {}, 'unexplained_rows': []}
    for line in open(log):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if not m:
            continue
        if m.group(1) not in funcs:            # a row already taken out of the translated set (pruned earlier)
            continue
        text = funcs[m.group(1)].split('\n')
        proofs = {}
        try:
            wanted = [a for a in (instruction_address(text, n) for _, n, *_ in eval(m.group(2)[:m.group(2).rindex(']') + 1])) if a]
            proofs = E.prove(int(m.group(1), 16), corpus[m.group(1)]['body'], wanted)
        except E.NoProof:
            pass
        items = []
        for kind, n, why, *rest in eval(m.group(2)[:m.group(2).rindex(']') + 1]):
            if why == 'survives':
                ident = rest[0] if rest else None
                same = equiv.get(m.group(1), {}).get((kind, n, ident), False) or (ident is None and equiv.get(m.group(1), {}).get((kind, n, None), False))
                items.append((kind, classify(kind, text, n, same, proofs), text[n].strip()[:160], n))
        if items:
            out['rows_with_survivors'][m.group(1)] = items
            if any(c is None for _, c, _, _ in items):
                out['unexplained_rows'].append(m.group(1))
    out['unexplained_rows'].sort(key=lambda k: int(k, 16))
    if '--out' in sys.argv:
        Path(sys.argv[sys.argv.index('--out') + 1]).write_text(json.dumps(out, indent=1) + '\n')
    print('rows with a survivor %d, unexplained %d' % (len(out['rows_with_survivors']), len(out['unexplained_rows'])))


if __name__ == '__main__':
    main()
