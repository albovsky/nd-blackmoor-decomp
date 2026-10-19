#!/usr/bin/env python3
"""FL-23 (batch b) mutation check: shows that the direct test and the Unicorn differential detect deliberately broken rules.

Mechanical mutants of src/original_methods_fl23b.c, one at a time, each applied to a copy in a scratch directory:
  literal   a hexadecimal literal (an offset, a selector, a table address, a constant) is raised by one
  compare   `==` and `!=` swapped in a condition
  guard     one `... return;` guard line deleted
  width     rd16 <-> rd32 and rds16 <-> rd16 (a width or signedness slip)
A mutant is detected when the direct test binary fails to build or fails; if the direct test passes, the differential test of the function
that contains the mutated line is run against the original bytes (the shim and port are rebuilt from the mutated copy). Prints the counts
and every survivor (an equivalent mutant is expected only where the changed value cannot reach an observable effect).

Run from outputs/blackmoor-decomp:  python3 tests/fl23b_mutation_check.py [--limit N] [--no-differential]
"""
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl23b_direct as direct
import test_fl_differential as base

SRC = HERE.parent / 'src'
FUNCS = {'4a1efd': 'test_4a1efd_click_2760', '4ba4f2': 'test_4ba4f2_click_276a', '46957d': 'test_46957d_click_272e',
         '4b45ed': 'test_4b45ed_click_2739', '473ffc': 'test_473ffc_click_27a1', '48e851': 'test_48e851_click_27b8_27b9',
         '45e587': 'test_45e587_click_27ec_27ef', '48ab49': 'test_48ab49_click_2756_2757', '4ab899': 'test_4ab899_click_27ce_27d0',
         '4574e4': 'test_4574e4_click_27bc_27be', '47a03c': 'test_47a03c_click_279c_279d', '4b2a9e': 'test_4b2a9e_click_2792_2793'}


def mutants(lines):
    """[(line index, description, new line)] for the code lines (from the first function marker on, comments skipped)."""
    out = []
    start = next(i for i, l in enumerate(lines) if l.startswith('/* ---- 0x4a1efd'))
    for i in range(start, len(lines)):
        line = lines[i]
        code = line.split('/*')[0]
        if not code.strip() or line.lstrip().startswith(('*', '/*')):
            continue
        for m in re.finditer(r'0x[0-9a-fA-F]+', code):
            if m.group().lower() in ('0x0',):
                continue
            new = '0x%x' % (int(m.group(), 16) + 1)
            out.append((i, 'literal %s -> %s' % (m.group(), new), line[:m.start()] + new + line[m.end():]))
        if re.search(r'\bif \(.*(==|!=)', code):
            out.append((i, 'compare swapped', re.sub(r'(==|!=)', lambda m: '!=' if m.group() == '==' else '==', code, count=1) + line[len(code):]))
        if re.match(r'\s*if \(.*\) return;\s*$', code):
            out.append((i, 'guard deleted', '\n'))
        for a, b in (('rds16(', 'rd16('), ('rd16(', 'rd32('), ('rd32(', 'rd16(')):
            if a in code and not code.lstrip().startswith('static'):
                out.append((i, 'width %s -> %s' % (a, b), line.replace(a, b, 1)))
    return out


def function_of(lines, i):
    for j in range(i, -1, -1):
        m = re.match(r'/\* ---- 0x([0-9a-f]+) ', lines[j])
        if m:
            return m.group(1)
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--limit', type=int, default=0)
    ap.add_argument('--no-differential', action='store_true')
    args = ap.parse_args()
    lines = (SRC / 'original_methods_fl23b.c').read_text().splitlines(keepends=True)
    muts = mutants(lines)
    if args.limit:
        muts = muts[::max(1, len(muts) // args.limit)]
    caught_direct = caught_diff = 0
    survivors = []
    for n, (i, what, new) in enumerate(muts):
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            mutated = lines[:i] + [new] + lines[i + 1:]
            (tmp / 'original_methods_fl23b.c').write_text(''.join(mutated))
            for name in ('original_methods_fl23b.h', 'original_methods_fl18.h', 'original_methods_fl17.h', 'original_methods_fl16.h'):
                if (SRC / name).exists():
                    shutil.copy(SRC / name, tmp / name)
            for extra in SRC.glob('original_methods_fl1[0-9].h'):
                shutil.copy(extra, tmp / extra.name)
            binary = tmp / 'direct'
            built = direct.build(binary, direct.TEST_C, tmp)
            if built.returncode != 0:
                caught_direct += 1
                continue
            done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60)
            if done.returncode != 0:
                caught_direct += 1
                continue
            if args.no_differential:
                survivors.append((i + 1, what, 'direct only'))
                continue
            key = function_of(lines, i)
            import test_fl23b_differential as diff
            base.SRC = tmp
            suite = unittest.TestSuite([diff.Fl23bDifferential(FUNCS[key])])
            result = unittest.TextTestRunner(stream=open('/dev/null', 'w')).run(suite)
            if result.wasSuccessful():
                survivors.append((i + 1, what, '0x' + key))
            else:
                caught_diff += 1
    print('mutants %d: caught by the direct test %d, by the differential test only %d, survivors %d' % (len(muts), caught_direct, caught_diff, len(survivors)))
    for line_no, what, where in survivors:
        print('  survivor: line %d (%s) %s' % (line_no, where, what))
    return 0


if __name__ == '__main__':
    sys.exit(main())
