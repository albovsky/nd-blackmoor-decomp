#!/usr/bin/env python3
"""FL-40: which survivors of tests/fl40_mutation_check.py are equivalent mutants?

A mutant is equivalent when it cannot change what the function does. This script proves that for the cases a compiler can see: the translation and the mutant are
compiled with `cc -O2 -S`, and when the two functions come out as identical assembly (names and local labels renumbered) the mutated statement had no effect, for
example a flag that nothing reads, a register that is overwritten before it is used, or a reload of a value the register already holds. Survivors whose assembly
differs are NOT equivalent as far as this script can tell; they are listed so that they get a written reason or the row stays pending.

  fl40_equiv_check.py <mutation log> [--out tasks/fl40-equivalence.json] [--rows 0x401000,...]      (run from outputs/blackmoor-decomp)

The log is that of `fl40_mutation_check.py --per-row N`; the mutants are regenerated with the same random seed and the same N (--per-row, default 60), so a survivor
(kind, line) names the same mutants. When one (kind, line) names several mutants (a statement with two width variants), the survivor is equivalent only if all of them are.
"""
import ast
import json
import random
import re
import subprocess
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fl40_mutation_check as M

PROJECT = M.PROJECT


def asm_of(source, tmp):
    src = Path(tmp) / 'f.c'
    src.write_text(source)
    out = subprocess.run(['cc', '-std=c11', '-O2', '-S', '-w', '-fno-asynchronous-unwind-tables', '-I%s' % (PROJECT / 'src'), str(src), '-o', '-'], capture_output=True, text=True)
    if out.returncode != 0:
        return None
    labels = {}
    lines = []
    for line in out.stdout.split('\n'):
        if line.lstrip().startswith(('.file', '.ident', '.section\t.note', '.size', '.type', '.globl', '.text', '.p2align')):
            continue
        line = re.sub(r'm[0-9a-f]+_(lifted|mut\d+)', 'FN', line)
        line = re.sub(r'\.L\d+', lambda m: labels.setdefault(m.group(0), '.L%d' % len(labels)), line)
        lines.append(line.rstrip())
    return '\n'.join(lines)


def main():
    argv = sys.argv[1:]
    log = argv[0]
    per_row = int(argv[argv.index('--per-row') + 1]) if '--per-row' in argv else 60
    only = set(argv[argv.index('--rows') + 1].split(',')) if '--rows' in argv else None
    funcs = M.split_functions(M.SOURCE.read_text())
    helper = funcs.get('0x50c920', '')
    result = {}
    for line in open(log):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if not m or (only and m.group(1) not in only):
            continue
        key = m.group(1)
        hard = [(k, n) for k, n, why in ast.literal_eval(m.group(2)[:m.group(2).rindex(']') + 1]) if why == 'survives']
        if not hard:
            continue
        va = int(key, 16)
        text = funcs[key]
        pre = '#include "original_methods_fl40.h"\n' + (helper if 'FL40_CALL_LIFTED' in text else '')
        muts = M.mutants(text, va, random.Random(va), per_row)
        with tempfile.TemporaryDirectory() as tmp:
            base = asm_of(pre + text, tmp)
            items = []
            for kind, n in hard:
                same = [mu for mu in muts if mu[0] == kind and mu[1] == n]
                equal = bool(same) and base is not None
                for mu in same:
                    if asm_of(pre + mu[2], tmp) != base:
                        equal = False
                        break
                items.append({'kind': kind, 'line': n, 'statement': text.split('\n')[n].strip()[:160], 'equivalent': equal, 'mutants': len(same)})
        result[key] = items
    out = {'rows': result,
           'rows_all_equivalent': sorted((k for k, v in result.items() if all(i['equivalent'] for i in v)), key=lambda k: int(k, 16)),
           'rows_with_open_survivor': sorted((k for k, v in result.items() if not all(i['equivalent'] for i in v)), key=lambda k: int(k, 16))}
    if '--out' in argv:
        Path(argv[argv.index('--out') + 1]).write_text(json.dumps(out, indent=1) + '\n')
    tot = sum(len(v) for v in result.values())
    eq = sum(1 for v in result.values() for i in v if i['equivalent'])
    print('survivors %d, identical -O2 code %d, open %d; rows all equivalent %d, rows with an open survivor %d' % (tot, eq, tot - eq, len(out['rows_all_equivalent']), len(out['rows_with_open_survivor'])))


if __name__ == '__main__':
    main()
