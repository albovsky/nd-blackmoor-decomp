#!/usr/bin/env python3
"""FL-25 (batch b) mutation check: shows that the direct test and the Unicorn differential detect deliberately broken rules.

Mechanical mutants of src/original_methods_fl25b.c, one at a time, each applied to a copy in a scratch directory:
  literal   a hexadecimal literal (an offset, a selector, a table address, a constant) is raised by one
  compare   `==` and `!=` swapped in a condition
  guard     one `... return;` guard line deleted
  width     rd16 <-> rd32 and rds16 <-> rd16 (a width or signedness slip)
A mutant is detected when the direct test binary fails to build or fails; if the direct test passes, the differential test of the function
that contains the mutated line is run against the original bytes (the shim and port are rebuilt from the mutated copy). Prints the counts
and every survivor (an equivalent mutant is expected only where the changed value cannot reach an observable effect).

Run from outputs/blackmoor-decomp:  python3 tests/fl25b_mutation_check.py [--limit N] [--no-differential] [--lines N,N,...]
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
import test_fl25b_direct as direct
import test_fl_differential as base

SRC = HERE.parent / 'src'
import fl25b_fixtures as fixtures
import test_fl25b_differential as differential
# (the differential test method of each function: test_<va>_<name>; a name that does not exist would make every differential run fail and
# every mutant look detected, so the lookup is strict)
FUNCS = {k: next(n for n in dir(differential.Fl25bDifferential) if n.startswith('test_%s_' % k)) for k in fixtures.KEYS}


def mutants(lines):
    """[(line index, description, new line)] for the code lines (from the first function marker on, comments skipped)."""
    out = []
    start = next(i for i, l in enumerate(lines) if l.startswith('/* ---- 0x'))
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
    ap.add_argument('--lines', default='', help='only the mutants of these source lines (comma separated)')
    args = ap.parse_args()
    lines = (SRC / 'original_methods_fl25b.c').read_text().splitlines(keepends=True)
    muts = mutants(lines)
    if args.lines:
        wanted = {int(x) for x in args.lines.split(',')}
        muts = [m for m in muts if m[0] + 1 in wanted]
    if args.limit:
        muts = muts[::max(1, len(muts) // args.limit)]
    caught_direct = caught_diff = 0
    survivors = []
    for n, (i, what, new) in enumerate(muts):
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            mutated = lines[:i] + [new] + lines[i + 1:]
            (tmp / 'original_methods_fl25b.c').write_text(''.join(mutated))
            shutil.copy(SRC / 'original_methods_fl25b.h', tmp / 'original_methods_fl25b.h')
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
            # (a mutant can crash the shared library: the differential of a survivor runs in its own process; a crash counts as caught)
            code = ("import sys, unittest, pathlib; sys.path.insert(0, %r); import test_fl_differential as base; base.SRC = pathlib.Path(%r); "
                    "import test_fl25b_differential as diff; r = unittest.TextTestRunner(stream=open('/dev/null', 'w')).run("
                    "unittest.TestSuite([diff.Fl25bDifferential(%r)])); sys.exit(0 if r.wasSuccessful() else 3)" % (str(HERE), str(tmp), FUNCS[key]))
            done = subprocess.run([sys.executable, '-c', code], capture_output=True, text=True, timeout=600)
            if done.returncode == 0:
                survivors.append((i + 1, what, '0x' + key))
            elif done.returncode == 3 or done.returncode < 0:      # (3: a failing test; negative: the mutant crashed the process)
                caught_diff += 1
            else:                                                  # (any other exit is a fault of the harness, not a detection)
                raise RuntimeError('differential run of the mutant at line %d failed to run:\n%s' % (i + 1, done.stderr[-2000:]))
    print('mutants %d: caught by the direct test %d, by the differential test only %d, survivors %d' % (len(muts), caught_direct, caught_diff, len(survivors)))
    for line_no, what, where in survivors:
        print('  survivor: line %d (%s) %s' % (line_no, where, what))
    return 0


if __name__ == '__main__':
    sys.exit(main())
