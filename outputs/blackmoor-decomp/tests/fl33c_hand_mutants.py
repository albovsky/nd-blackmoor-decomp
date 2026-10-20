#!/usr/bin/env python3
"""FL-33 (batch c): hand-written mutants (shapes the mechanical tests/fl33c_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl33c.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives.

Run from outputs/blackmoor-decomp:  python3 tests/fl33c_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl33c_direct as direct
import fl33c_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    ('4c6929', '(int32_t)r < (int32_t)rows', 'r < rows'),
    ('4c6929', '(int32_t)col < (int32_t)cols', 'col < cols'),
    ('4c6929', 'sstep = (int32_t)rds16(pa, 0x2f) / 2;', 'sstep = (int32_t)rds16(pa, 0x2f) >> 1;'),
    ('4c6929', 'dstep = (int32_t)v1 / 2;', 'dstep = (int32_t)v1 >> 1;'),
    ('4c6929', 'if (a == 0 || b == 0) {', 'if (a == 0 && b == 0) {'),
    ('4c6929', 'if (dx1 != dx2 || dy1 != dy2) {', 'if (dx1 != dx2 && dy1 != dy2) {'),
    ('4c6929', 'report_4c6929(self, 0x555054, d, r1, r2, host);', 'report_4c6929(self, 0x5550e8, d, r1, r2, host);'),
    ('4c6929', 'src = rd32(pa, 0) + rd32(p1, 4) * (uint32_t)rds16(pa, 0x2f)', 'src = rd32(pa, 0) + rd32(p1, 0) * (uint32_t)rds16(pa, 0x2f)'),
    ('4c6929', 'if (*res(host, mask + col) != 0)', 'if ((int8_t)*res(host, mask + col) > 0)'),
    ('4c6929', 'if (world->word_63a4cd != 0) {', 'if ((uint8_t)world->word_63a4cd != 0) {'),
    ('4c6929', '    if (a == 0) return 1;                                  /* the original reads the word at 0x2f here and faults */\n', ''),
    ('4c6929', '    call3(host, 0x4c4202, (uintptr_t)self, b, r2, 0x555164);\n    if (b == rd32(self, 0xc)) call1(host, 0x4c952f, (uintptr_t)self, r2);\n    return 0;',
     '    if (b == rd32(self, 0xc)) call1(host, 0x4c952f, (uintptr_t)self, r2);\n    call3(host, 0x4c4202, (uintptr_t)self, b, r2, 0x555164);\n    return 0;'),
    ('4c6929', 'wr16(res(host, dst + col * 2u), 0, rd16(res(host, src + col * 2u), 0));', 'wr16(res(host, dst + col * 2u), 0, rd16(res(host, src + col * 2u + 2u), 0));'),
    # EQUIVALENT (not a mutant): the 0x120-byte message local and the 0x80-byte descriptor local are only sizes of host scratch; rd16 -> rd32 of the copied word is truncated by wr16
    # HAND-END
]


def main():
    text = (SRC / 'original_methods_fl33c.c').read_text()
    survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl33c.c').write_text(mutated)
            for f in SRC.glob('original_methods_fl*.h'):
                shutil.copy(f, tmp / f.name)
            binary = tmp / 'direct'
            built = direct.build(binary, direct.TEST_C, tmp)
            where = None
            if built.returncode != 0:
                where = 'build'
            else:
                try:
                    done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=20)
                    if done.returncode != 0:
                        where = 'direct'
                except subprocess.TimeoutExpired:
                    where = 'direct (timeout)'
            if where is None:
                child = subprocess.run([sys.executable, '-c', mc.DIFFERENTIAL_CHILD, str(tmp), mc.FUNCS[key]], capture_output=True, text=True, timeout=600, cwd=str(HERE.parent))
                where = 'differential' if child.returncode != 0 else 'SURVIVED'
        survived += where == 'SURVIVED'
        print('0x%s %-12s | %s' % (key, where, old[:60].replace('\n', ' ')))
    print('hand mutants %d, survivors %d' % (len(HAND), survived))
    return 1 if survived else 0


if __name__ == '__main__':
    sys.exit(main())
