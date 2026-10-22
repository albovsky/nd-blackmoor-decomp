#!/usr/bin/env python3
"""FL-40: sort the survivors of tests/fl40_mutation_check.py (its log as the argument) into those that are provably equivalent mutants and the rows that stay out.

A survivor is explained only when one of these holds for the mutated statement; everything else leaves its row pending:
  identical code   `cc -O2 -S` of the mutant and of the translation give the same assembly (tests/fl40_equiv_check.py): a flag nothing reads, a dead store
  same value       a register reload `reg = RD(ebp +- k)` right after the store `WR(ebp +- k, reg)` of the same register, on straight-line code with no call, label, jump or
                   store that could hit the slot in between (a store through another register is assumed not to point into the function's own frame): the register already holds the value, so dropping the reload changes nothing
  cleanup          the bytes a played callee pops after a call (`esp += n`) when the next statement that touches esp is `esp = ebp` on straight-line code
  frame            `ebp = esp` / `esp = ebp` where nothing reads ebp between that statement and the next `esp = ebp`
The earlier "local width" class (a narrower read of a frame local that the corpus never shows) is NOT an equivalence and is gone: those rows stay pending.

  fl40_survivors.py <mutation log> [--equiv tasks/fl40-equivalence.json] [--out tasks/fl40-survivors.json]
"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M

BARRIER = re.compile(r'FL40_CALL|goto|^L_|^done:|while|switch|case |FL40_EPILOGUE')


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
        if t.startswith(want):
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
    return 'FL40_CALL' in lines[n] and forward(lines, n, lambda t: t.startswith('esp = ebp;'),
                                               lambda t: 'esp' in t or BARRIER.search(t) or re.search(r'\bR?D\d+|\bWR\d+', t) and 'esp' in t)


def frame_ok(lines, n):
    t = stmt(lines[n])
    if not (t.startswith('ebp = esp;') or t.startswith('esp = ebp;')):
        return False
    return forward(lines, n, lambda x: x.startswith('esp = ebp;'), lambda x: 'ebp' in x or BARRIER.search(x))


def classify(kind, lines, n, equivalent):
    if equivalent:
        return 'identical code'
    if kind == 'drop' and same_value(lines, n):
        return 'same value'
    if kind == 'literal' and cleanup_ok(lines, n):
        return 'cleanup'
    if kind == 'register' and frame_ok(lines, n):
        return 'frame'
    return None


def main():
    log = sys.argv[1]
    equiv = {}
    if '--equiv' in sys.argv:
        for row, items in json.loads(Path(sys.argv[sys.argv.index('--equiv') + 1]).read_text())['rows'].items():
            equiv[row] = {(i['kind'], i['line']): i['equivalent'] for i in items}
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    out = {'rows_with_survivors': {}, 'unexplained_rows': []}
    for line in open(log):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if not m:
            continue
        text = funcs[m.group(1)].split('\n')
        items = []
        for kind, n, why in eval(m.group(2)[:m.group(2).rindex(']') + 1]):
            if why == 'survives':
                items.append((kind, classify(kind, text, n, equiv.get(m.group(1), {}).get((kind, n), False)), text[n].strip()[:160]))
        if items:
            out['rows_with_survivors'][m.group(1)] = items
            if any(c is None for _, c, _ in items):
                out['unexplained_rows'].append(m.group(1))
    out['unexplained_rows'].sort(key=lambda k: int(k, 16))
    if '--out' in sys.argv:
        Path(sys.argv[sys.argv.index('--out') + 1]).write_text(json.dumps(out, indent=1) + '\n')
    print('rows with a survivor %d, unexplained %d' % (len(out['rows_with_survivors']), len(out['unexplained_rows'])))


if __name__ == '__main__':
    main()
