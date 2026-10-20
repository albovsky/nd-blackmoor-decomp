#!/usr/bin/env python3
"""FL-31 (batch a): hand-written mutants (shapes the mechanical tests/fl31a_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl31a.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives. (Swapping the two clearing stores of 0x47ba79 is not a mutant: the two stores hit disjoint dwords and the only
aliasing that would show the order, [self+0x1c]+4 == self+0x20, makes the original fault at address 0, so the order is not observable on a valid input.)

Run from outputs/blackmoor-decomp:  python3 tests/fl31a_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl31a_direct as direct
import fl31a_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    ('47ba79', 'host->tick(host->context) <= rd32(self, 0x38)', '(int32_t)host->tick(host->context) <= (int32_t)rd32(self, 0x38)'),
    ('47badf', '(int32_t)rd32(self, 0x290) >= (int32_t)rd32(self, 0x2a0)) {\n        if', '(uint32_t)rd32(self, 0x290) >= (uint32_t)rd32(self, 0x2a0)) {\n        if'),
    ('47b321', 'call1(host, 0x51dc6c, 0, p);\n        wr32(self, 0x14, 0);', 'wr32(self, 0x14, 0);\n        call1(host, 0x51dc6c, 0, p);'),
    ('47b321', '(uintptr_t)(self + 8)', '(uintptr_t)self'),
    ('47b321', 'call1(host, 0x4d3992, 0, rd16(self, 4))', 'call1(host, 0x4d3992, 0, (uint32_t)rds16(self, 4))'),
    ('47b709', '(uint32_t)(int32_t)(int16_t)sel', '(uint16_t)sel'),
    ('47c049', '            wr32(slots, (ptrdiff_t)k * 4, 1);\n', ''),
    ('47c049', 'return r % n;', 'return (int32_t)((uint32_t)r % (uint32_t)n);'),
    ('47b200', 'return self;', 'return NULL;'),
    ('47b200', '    wr32(self, 0, 0x52d568);\n    call0(host, 0x47b23b, (uintptr_t)self);', '    call0(host, 0x47b23b, (uintptr_t)self);\n    wr32(self, 0, 0x52d568);'),
    ('47b23b', '    wr16(self, 6, 0xffff);\n', ''),
    ('47d640', 'if (self[0x57] == 0) return;', 'if (rd32(self, 0x57) == 0) return;'),
    ('47b3bc', 'wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);', 'wr32(world->table_5d15a5, (ptrdiff_t)(uint16_t)i * 0x4a, 1);'),
]


def main():
    text = (SRC / 'original_methods_fl31a.c').read_text()
    survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl31a.c').write_text(mutated)
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
