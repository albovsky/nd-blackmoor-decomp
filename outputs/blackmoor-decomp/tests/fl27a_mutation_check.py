#!/usr/bin/env python3
"""FL-27 (batch a) mutation check: shows that the direct test and the Unicorn differential detect deliberately broken rules.

Mechanical mutants of src/original_methods_fl27a.c, one at a time, each applied to a copy in a scratch directory:
  literal   a hexadecimal literal (an offset, a selector, a table address, a constant) is raised by one
  compare   `==` and `!=` swapped in a condition
  boundary  one relational operator of an if / for / while condition moved across its boundary (`<` <-> `<=`, `>` <-> `>=`)
  guard     one `... return;` guard line deleted
  width     rd16 <-> rd32 and rds16 <-> rd16 (a width or signedness slip)
A mutant is detected when the direct test binary fails to build or fails; if the direct test passes, the differential test of the function
that contains the mutated line is run against the original bytes (the shim and port are rebuilt from the mutated copy; the run is in a
child process, so that a mutant that crashes the shim counts as detected). Prints the counts
and every survivor (an equivalent mutant is expected only where the changed value cannot reach an observable effect).

Known gap: the mutants are single textual edits of the port, one operator or literal at a time. They do not model a missing statement other
than a one-line `if (...) return;` guard, a reordering of effects, a loop bound written as an expression, or two edits together. The
mutants behind the review fixes of tests/fl27a_fixtures.py (deleted multi-line guards, `if (1)`, a dropped `||` operand, `== 3` -> `>= 3`)
were applied by hand and are listed in tasks/fl27a-handoff.md.

Run from outputs/blackmoor-decomp:  python3 tests/fl27a_mutation_check.py [--limit N] [--no-differential]
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
import test_fl27a_direct as direct

SRC = HERE.parent / 'src'
FUNCS = {'4de1f5': 'test_4de1f5_clear_flags',
         '4de214': 'test_4de214_clear_flags_thunk',
         '4de2d8': 'test_4de2d8_reset_caption',
         '449d90': 'test_449d90_file_exists',
         '44c479': 'test_44c479_wait_state',
         '4bee2c': 'test_4bee2c_get_field',
         '4bef85': 'test_4bef85_bink_wait',
         '4bee5f': 'test_4bee5f_bink_summary',
         '4befc8': 'test_4befc8_bink_do_frame',
         '4bef11': 'test_4bef11_bink_goto',
         '4bf098': 'test_4bf098_bink_copy_to_buffer',
         '4bf10f': 'test_4bf10f_bink_next',
         '4bf315': 'test_4bf315_bink_open',
         '4c2dfb': 'test_4c2dfb_free_pair',
         '4159db': 'test_4159db_dispatch_piece',
         # FUNCS-END
         }


# the differential test of one function against the mutated copy in sys.argv[1], in a child process (exit 0 = passed)
DIFFERENTIAL_CHILD = """
import sys, unittest
from pathlib import Path
sys.dont_write_bytecode = True
sys.path.insert(0, 'tests')
import test_fl_differential as base
import test_fl27a_differential as diff
base.SRC = Path(sys.argv[1])
result = unittest.TextTestRunner(stream=open('/dev/null', 'w')).run(unittest.TestSuite([diff.Fl27aDifferential(sys.argv[2])]))
sys.exit(0 if result.wasSuccessful() else 1)
"""


def mutants(lines):
    """[(line index, description, new line)] for the code lines (from the first function marker on, comments skipped)."""
    out = []
    start = next(i for i, l in enumerate(lines) if l.startswith('/* ---- 0x4de1f5'))
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
        if re.match(r'\s*(if|for|while) \(', code):
            for m in re.finditer(r'(?<![-<>])(<=|>=|<|>)(?![<>])', code):
                new = {'<': '<=', '<=': '<', '>': '>=', '>=': '>'}[m.group()]
                out.append((i, 'boundary %s -> %s' % (m.group(), new), line[:m.start()] + new + line[m.end():]))
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
    lines = (SRC / 'original_methods_fl27a.c').read_text().splitlines(keepends=True)
    muts = mutants(lines)
    if args.limit:
        muts = muts[::max(1, len(muts) // args.limit)]
    caught_direct = caught_diff = 0
    survivors = []
    for n, (i, what, new) in enumerate(muts):
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            mutated = lines[:i] + [new] + lines[i + 1:]
            (tmp / 'original_methods_fl27a.c').write_text(''.join(mutated))
            for name in ('original_methods_fl27a.h', 'original_methods_fl18.h', 'original_methods_fl17.h', 'original_methods_fl16.h'):
                if (SRC / name).exists():
                    shutil.copy(SRC / name, tmp / name)
            for extra in SRC.glob('original_methods_fl1[0-9].h'):
                shutil.copy(extra, tmp / extra.name)
            binary = tmp / 'direct'
            built = direct.build(binary, direct.TEST_C, tmp)
            if built.returncode != 0:
                caught_direct += 1
                continue
            try:
                done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=20)
            except subprocess.TimeoutExpired:      # a mutant that no longer terminates is caught as well
                caught_direct += 1
                continue
            if done.returncode != 0:
                caught_direct += 1
                continue
            if args.no_differential:
                survivors.append((i + 1, what, 'direct only'))
                continue
            key = function_of(lines, i)
            try:
                child = subprocess.run([sys.executable, '-c', DIFFERENTIAL_CHILD, str(tmp), FUNCS[key]], capture_output=True, text=True,
                                       timeout=600, cwd=str(HERE.parent))
            except subprocess.TimeoutExpired:
                caught_diff += 1
                continue
            if child.returncode == 0:
                survivors.append((i + 1, what, '0x' + key))
            else:
                caught_diff += 1
    print('mutants %d: caught by the direct test %d, by the differential test only %d, survivors %d' % (len(muts), caught_direct, caught_diff, len(survivors)))
    for line_no, what, where in survivors:
        print('  survivor: line %d (%s) %s' % (line_no, where, what))
    return 0


if __name__ == '__main__':
    sys.exit(main())
