#!/usr/bin/env python3
"""FL-36 (batch a): hand-written mutants (shapes the mechanical tests/fl36a_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl36a.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives.

Run from outputs/blackmoor-decomp:  python3 tests/fl36a_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl36a_direct as direct
import fl36a_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    ('4f379c', 'if ((int32_t)rd32(o, 0x1b2) > (int32_t)rd32(o, 0x1b6)) {', 'if (rd32(o, 0x1b2) > rd32(o, 0x1b6)) {'),
    ('4f379c', 'if ((int32_t)rd32(o, 0x1ba) > (int32_t)rd32(o, 0x1be)) {', 'if (rd32(o, 0x1ba) > rd32(o, 0x1be)) {'),
    ('4f379c', 'if ((int32_t)rd32(o, 0x1c2) > (int32_t)rd32(o, 0x1c6)) {', 'if (rd32(o, 0x1c2) >= rd32(o, 0x1c6)) {'),
    ('4f379c', 'if (!((p != 0 || q != 0) && (int32_t)(q - p) > 0)) {', 'if (!((p != 0 || q != 0) && q > p)) {'),
    ('4f379c', 'if (!((p != 0 || q != 0) && (int32_t)(q - p) > 0)) {', 'if (!((p != 0 && q != 0) && (int32_t)(q - p) > 0)) {'),
    ('4f379c', 'if ((int32_t)rd32(o, 0x1d6) <= 1) wr32(o, 0x1d6, rd32(self, 0x466));', 'if (rd32(o, 0x1d6) <= 1) wr32(o, 0x1d6, rd32(self, 0x466));'),
    ('4f379c', 'if ((int32_t)rd32(o, 0x1da) <= 1) wr32(o, 0x1da, rd32(self, 0x46a));', 'if ((int32_t)rd32(o, 0x1da) <= 1) wr32(o, 0x1da, rd32(self, 0x466));'),
    ('4f379c', 'if ((int32_t)size < 0) {', 'if (size > 0x80000000u) {'),
    ('4f379c', 'rds16(o, 0x126) == 2', 'rd32(o, 0x126) == 2'),
    ('4f379c', '    id &= 0xffffu;\n', ''),
    ('4f379c', 'a[2] = (uintptr_t)local; a[3] = id; a[4] = entry + 4u;\n            callv(host, 0x50ca3e, 0, a, 5);', 'a[2] = (uintptr_t)local; a[3] = id; a[4] = entry + 4u;\n            callv(host, 0x50ca3e, 0, a, 4);'),
    ('4f379c', 'a[0] = 0x63888b; a[1] = 0x55db40; a[2] = id; a[3] = entry + 4u;', 'a[0] = 0x63888b; a[1] = 0x55db40; a[2] = entry + 4u; a[3] = id;'),
    ('4f379c', 'wr16(local, 0, (uint16_t)world->word_63aa14);', 'wr16(local, 0, (uint16_t)world->word_63a4cd);'),
    ('4f379c', 'if (len > sizeof local) return 1;', 'if (len > sizeof local + 1) return 1;'),
    ('4f379c', '    wr32(o, 0x162, 1);\n    wr32(o, 0x152, 0);', '    wr32(o, 0x152, 0);\n    wr32(o, 0x162, 1);\n    wr32(o, 0x152, 1);'),
    ('4f379c', '    wr32(self, 0x3c2, code);\n    wr32(self, 0x3be, 0);', '    wr32(self, 0x3be, 0);\n    wr32(self, 0x3c2, code ^ 1u);'),
    ('4f379c', '        call1(host, 0x4f356e, (uintptr_t)self, id);\n        *result = fail_4f379c(self, 0x3f9);', '        *result = fail_4f379c(self, 0x3f9);\n        call1(host, 0x4f356e, (uintptr_t)self, id);'),
    ('4f379c', 'if (call1(host, 0x4f438f, (uintptr_t)self, id) == 0) {', 'if (call1(host, 0x4f438f, (uintptr_t)self, id) != 0) {'),
    ('4f379c', '    *result = rd32(self, 0x3be);\n    return 0;', '    *result = 1;\n    return 0;'),
    ('4f379c', 'wr32(o, 0x15e, rd32(o, 0x122));', 'wr32(o, 0x15e, rd32(o, 0x126));'),
    ('4f379c', 'memcmp(o + 0x10a, res(host, 0x55dab4), 4) != 0', 'memcmp(o + 0x10a, res(host, 0x55dab4), 3) != 0'),
    # EQUIVALENT (not a mutant): in 0x4f379c `(int32_t)size > 0x56220` -> `size > 0x56220`: a negative size has already returned, so signed and unsigned agree here.
    # EQUIVALENT (not a mutant): in 0x4f379c `rds16(o, 0x10e) != 2` -> `rd16(...) != 2`: only the word 2 equals 2 both ways.
    # HAND-END
]


def main():
    text = (SRC / 'original_methods_fl36a.c').read_text()
    survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl36a.c').write_text(mutated)
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
