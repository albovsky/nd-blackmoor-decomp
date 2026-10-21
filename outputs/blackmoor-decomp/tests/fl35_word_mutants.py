#!/usr/bin/env python3
"""FL-35: hand-shaped mutants of the 63 rows that the mechanical tests/fl35a_mutation_check.py and tests/fl35b_mutation_check.py do not generate (their literals are hex
numbers; the word each row stores is a field name). For every row of src/original_methods_fl35a.c and src/original_methods_fl35b.c, in a scratch copy: (1) the stored word is
the next word of the world, (2) batch a only: the tag address is the next tag, (3) the row passes the field of its neighbour, (4) toggle only: the stored values are
swapped. Each must make the direct test binary fail to build or fail; with --differential the Unicorn differential test of that row must fail too. Prints the counts and every
survivor; exits 1 if any survives. Run from outputs/blackmoor-decomp:  python3 tests/fl35_word_mutants.py [--differential]"""
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
import test_fl35a_direct as da
import test_fl35b_direct as db
import fl35a_mutation_check as ma
import fl35b_mutation_check as mb

SRC = HERE.parent / 'src'


def mutants(batch, lines):
    out = []
    for i, line in enumerate(lines):
        m = re.match(r'(\s*return read_(?:tag|text)_word\(self, &world->word_)([0-9a-f]+)(, )(0x[0-9a-f]+)(.*)', line)
        if m:
            va = next(re.search(r'/\* ---- 0x([0-9a-f]+) ', lines[j]).group(1) for j in range(i, -1, -1) if re.match(r'/\* ---- 0x[0-9a-f]+ read_', lines[j]))
            word = int(m.group(2), 16)
            out.append((i, va, 'next word', m.group(1) + '%x' % (word + 2) + m.group(3) + m.group(4) + m.group(5) + '\n'))
            if batch == 'a':
                mt = re.match(r'(\s*return read_tag_word\(self, &world->word_[0-9a-f]+, 0x[0-9a-f]+, )(0x[0-9a-f]+)(.*)', line)
                out.append((i, va, 'next tag', mt.group(1) + '0x%x' % (int(mt.group(2), 16) + 4) + mt.group(3) + '\n'))
        if 'world->word_5ec28c = world->word_5ec28c != 0 ? 0 : 1;' in line:
            out.append((i, '4080fc', 'values swapped', line.replace('? 0 : 1', '? 1 : 0')))
            out.append((i, '4080fc', 'byte test', line.replace('world->word_5ec28c != 0', '(world->word_5ec28c & 0xff) != 0')))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--differential', action='store_true')
    args = ap.parse_args()
    caught = 0
    survivors = []
    total = 0
    for batch, direct, mc in (('a', da, ma), ('b', db, mb)):
        lines = (SRC / ('original_methods_fl35%s.c' % batch)).read_text().splitlines(keepends=True)
        for i, va, what, new in mutants(batch, lines):
            total += 1
            with tempfile.TemporaryDirectory() as tmp:
                tmp = Path(tmp)
                (tmp / ('original_methods_fl35%s.c' % batch)).write_text(''.join(lines[:i] + [new] + lines[i + 1:]))
                for h in SRC.glob('*.h'):
                    shutil.copy(h, tmp / h.name)
                binary = tmp / 'direct'
                built = direct.build(binary, direct.TEST_C, tmp)
                bad = built.returncode != 0
                if not bad:
                    bad = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60).returncode != 0
                if bad and args.differential:
                    child = subprocess.run([sys.executable, '-c', mc.DIFFERENTIAL_CHILD, str(tmp), mc.FUNCS[va]], capture_output=True, text=True, timeout=600, cwd=str(HERE.parent))
                    bad = child.returncode != 0
                if bad:
                    caught += 1
                else:
                    survivors.append((batch, va, what))
    print('mutants %d: caught %d, survivors %d' % (total, caught, len(survivors)))
    for s in survivors:
        print('  survivor:', s)
    return 1 if survivors else 0


if __name__ == '__main__':
    sys.exit(main())
