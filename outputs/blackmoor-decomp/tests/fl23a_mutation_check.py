#!/usr/bin/env python3
"""FL-23 (batch a) mutation check: shows that the direct test and the Unicorn differential detect deliberately broken rules.

Mechanical mutants of src/original_methods_fl23a.c, one at a time, each applied to a copy in a scratch directory:
  literal   a hexadecimal literal (an offset, a selector, a table address, a constant) is raised by one
  compare   `==` and `!=` swapped in a condition
  guard     one `... return;` guard line deleted
  width     rd16 <-> rd32 and rds16 <-> rd16 (a width or signedness slip); with --index-only, only the eight record-index reads
            (`rds16(self, 0x1c | 0x1e | 0x21)`: movsx of the index word before imul 0x8d) are mutated to rd16
A mutant is detected when the direct test binary fails to build, fails, or hangs; if the direct test passes, the differential test of the
function that contains the mutated line (all of them for a line of the shared helpers) is run against the original bytes in a child process
(the shim and the port are rebuilt from the mutated copy; a crash counts as detected). Prints the counts and every survivor (an equivalent
mutant is expected only where the changed value cannot reach an observable effect).

With --index-only the differential test is run for every index mutant even when the direct test already caught it, and each line is
reported as `direct=<caught|survived> differential=<caught|survived>`.

Run from outputs/blackmoor-decomp:  python3 tests/fl23a_mutation_check.py [--limit N] [--no-differential] [--index-only]
"""
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl23a_direct as direct

SRC = HERE.parent / 'src'
SOURCE = 'original_methods_fl23a.c'
INDEX_READ = re.compile(r'rds16\(self, 0x(1c|1e|21)\)')

CHILD = r'''
import os, sys, unittest
from pathlib import Path
sys.dont_write_bytecode = True
sys.path.insert(0, sys.argv[1])
import test_fl_differential as base
import test_fl23a_differential as diff
base.SRC = Path(sys.argv[2])
names = [n for n in dir(diff.Fl23aDifferential) if any(n.startswith('test_%s_' % k) for k in sys.argv[3].split(','))]
suite = unittest.TestSuite([diff.Fl23aDifferential(n) for n in names])
result = unittest.TextTestRunner(stream=open(os.devnull, 'w')).run(suite)
if result.errors or not names or result.testsRun != len(names):
    sys.exit(3)   # a harness problem (the copy did not build, a test did not run): never counted as a detection
sys.exit(0 if result.wasSuccessful() else 1)
'''


def mutants(lines, index_only):
    """[(line index, description, new line)] for the code lines (from the shared helpers on, comments skipped)."""
    out = []
    start = next(i for i, l in enumerate(lines) if l.startswith('static uint32_t record_va'))
    for i in range(start, len(lines)):
        line = lines[i]
        code = line.split('/*')[0]
        if not code.strip() or line.lstrip().startswith(('*', '/*')):
            continue
        if index_only:
            if INDEX_READ.search(code):
                out.append((i, 'rds16 -> rd16 (record index word)', INDEX_READ.sub(lambda m: 'rd16(self, 0x%s)' % m.group(1), line, count=1)))
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


def run_direct(tmp):
    """True when the direct test (built from the mutated copy in tmp) passes."""
    binary = tmp / 'direct'
    built = direct.build(binary, direct.TEST_C, tmp)
    if built.returncode != 0:
        return False
    try:
        return subprocess.run([str(binary)], capture_output=True, text=True, timeout=60).returncode == 0
    except subprocess.TimeoutExpired:
        return False


def run_differential(tmp, keys):
    """True when the differential tests of the functions `keys` pass; False for a failed comparison, a crash or a hang. A harness problem
    (the child exits with 3) raises: it must never be mistaken for a detection."""
    try:
        child = subprocess.run([sys.executable, '-c', CHILD, str(HERE), str(tmp), keys], capture_output=True, timeout=900)
    except subprocess.TimeoutExpired:
        return False
    if child.returncode == 3:
        raise RuntimeError('differential harness error: ' + child.stderr.decode(errors='replace')[-600:])
    return child.returncode == 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--limit', type=int, default=0)
    ap.add_argument('--no-differential', action='store_true')
    ap.add_argument('--index-only', action='store_true')
    args = ap.parse_args()
    lines = (SRC / SOURCE).read_text().splitlines(keepends=True)
    all_keys = ','.join(re.findall(r'/\* ---- 0x([0-9a-f]+) ', ''.join(lines)))
    muts = mutants(lines, args.index_only)
    if args.limit:
        muts = muts[::max(1, len(muts) // args.limit)]
    caught_direct = caught_diff = 0
    survivors = []
    for i, what, new in muts:
        key = function_of(lines, i)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / SOURCE).write_text(''.join(lines[:i] + [new] + lines[i + 1:]))
            for header in SRC.glob('original_methods_*.h'):
                shutil.copy(header, tmp / header.name)
            direct_ok = run_direct(tmp)
            if args.index_only:
                diff_ok = run_differential(tmp, key)
                print('  line %d (0x%s) %s: direct=%s differential=%s' % (i + 1, key, what, 'survived' if direct_ok else 'caught',
                                                                         'survived' if diff_ok else 'caught'))
                caught_direct += not direct_ok
                caught_diff += not diff_ok
                if direct_ok or diff_ok:
                    survivors.append((i + 1, what, '0x' + key))
                continue
            if not direct_ok:
                caught_direct += 1
                continue
            if args.no_differential:
                survivors.append((i + 1, what, 'direct only'))
                continue
            if run_differential(tmp, key or all_keys):
                survivors.append((i + 1, what, '0x' + key if key else 'helpers'))
            else:
                caught_diff += 1
    if args.index_only:
        print('index mutants %d: caught by the direct test %d, by the differential test %d, survivors %d' % (len(muts), caught_direct, caught_diff, len(survivors)))
    else:
        print('mutants %d: caught by the direct test %d, by the differential test only %d, survivors %d' % (len(muts), caught_direct, caught_diff, len(survivors)))
    for line_no, what, where in survivors:
        print('  survivor: line %d (%s) %s' % (line_no, where, what))
    return 0


if __name__ == '__main__':
    sys.exit(main())
