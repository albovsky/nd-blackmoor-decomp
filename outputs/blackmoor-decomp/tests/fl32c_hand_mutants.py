#!/usr/bin/env python3
"""FL-32 (batch c): hand-written mutants (shapes the mechanical tests/fl32c_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl32c.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives. (The dead stores of 0x43edac are not observable from the port, see tasks/fl32c-handoff.md.)

Run from outputs/blackmoor-decomp:  python3 tests/fl32c_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl32c_direct as direct
import fl32c_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    ('44e78e', '    if (rd32(self, 0x20) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));\n    if (rds16(self, 0x1c) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x1c));',
     '    uint16_t w0 = rd16(self, 0x1c);\n    if (rd32(self, 0x20) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));\n    if ((int16_t)w0 != -1) call1(host, 0x4d3992, 0, w0);'),
    ('44e78e', 'call1(host, 0x4d3992, 0, rd16(self, 0x1c))', 'call1(host, 0x4d3992, 0, (uint32_t)rds16(self, 0x1c))'),
    ('44e78e', 'if (rd32(self, 0x20) != 0)', 'if (rd16(self, 0x20) != 0)'),
    ('44e78e', '(uintptr_t)(self + 0x20)', '(uintptr_t)self'),
    ('44e7d7', 'wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);', 'wr32(world->table_5d15a5, (ptrdiff_t)(uint16_t)i * 0x4a, 1);'),
    ('44e7d7', 'if (rd32(self, 0x6b) == 0) return;', 'if (self[0x6b] == 0) return;'),
    ('44e95b', 'wr32(dst, 4, rd32(src, 4) + world->value_58318a);', 'wr32(dst, 4, rd32(src, 4) + world->value_583186);'),
    ('44e95b', '    wr32(dst, 4, rd32(src, 4) + world->value_58318a);\n    wr32(dst, 0xc, rd32(src, 0xc) + world->value_58318a);\n    wr32(dst, 0, rd32(src, 0) + world->value_583186);',
     '    wr32(dst, 0, rd32(src, 0) + world->value_583186);\n    wr32(dst, 4, rd32(src, 4) + world->value_58318a);\n    wr32(dst, 0xc, rd32(src, 0xc) + world->value_58318a);'),
    ('44e95b', '    wr32(dst, 0, rd32(src, 0) + world->value_583186);\n    wr32(dst, 8, rd32(src, 8) + world->value_583186);',
     '    wr32(dst, 8, rd32(src, 8) + world->value_583186);\n    wr32(dst, 0, rd32(src, 0) + world->value_583186);'),
    ('43edac', 'return call0(host, 0x51ab4b, (uintptr_t)self);', 'call0(host, 0x51ab4b, (uintptr_t)self);\n    return 0;'),
    ('43edac', '    args[0] = (uintptr_t)&slots[0];\n    args[1] = (uintptr_t)&slots[1];\n    args[2] = (uintptr_t)&slots[2];',
     '    args[0] = (uintptr_t)&slots[2];\n    args[1] = (uintptr_t)&slots[1];\n    args[2] = (uintptr_t)&slots[0];'),
    ('43edac', '    slots[0] = a8;\n    slots[1] = ac;\n    slots[2] = a10;', '    slots[0] = a8;\n    slots[1] = a10;\n    slots[2] = ac;'),
    ('43ee69', 'if (msg == 0x14) return 1;', 'if ((uint16_t)msg == 0x14) return 1;'),
    ('43ee69', 'if (msg == 0x112) {', 'if ((uint16_t)msg == 0x112) {'),
    ('43ee69', 'uint32_t command = wparam & 0xfff0;', 'uint32_t command = wparam & 0xffff;'),
    ('43ee69', '    args[0] = msg;\n    args[1] = wparam;\n    args[2] = lparam;', '    args[0] = lparam;\n    args[1] = wparam;\n    args[2] = msg;'),
    ('4db090', 'if (world->value_5c39e5 != 0xffffffffu) {', 'if ((uint16_t)world->value_5c39e5 != 0xffffu) {'),
    ('4db090', '    wr32(self, 0xc, 0);\n', ''),
    ('4db090', 'if (rd32(self, 0x10) == 1) wr32(self, 0x10, 2);', 'if (rd32(self, 0x10) >= 1) wr32(self, 0x10, 2);'),
    ('4de53e', 'uint32_t p = call0(host, 0x4ee630, (uintptr_t)self);\n    uintptr_t args[5];\n    if (p == 0) return;\n    args[0] = p;\n    args[1] = world->value_5cf665;',
     'uint32_t g0 = world->value_5cf665;\n    uint32_t p = call0(host, 0x4ee630, (uintptr_t)self);\n    uintptr_t args[5];\n    if (p == 0) return;\n    args[0] = p;\n    args[1] = g0;'),
    ('4de53e', '    args[3] = 0x5b0227;\n    args[4] = 0x55b8d0;', '    args[3] = 0x55b8d0;\n    args[4] = 0x5b0227;'),
    ('4ea229', '    call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x699));\n    world->value_5d1717 = 0;', '    world->value_5d1717 = 0;\n    call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x699));'),
    ('4ea229', 'if (world->word_63a4cd != 0)', 'if ((int8_t)world->word_63a4cd != 0)'),
    ('4fb2a6', 'args[1] = (idx & 0xffff0000u) | (b & 0xffff);', 'args[1] = (b & 0xffff);'),
    ('4fb2a6', 'uint32_t idx = (b & 0xffff) * 0x5bb;', 'uint32_t idx = (b & 0xfffff) * 0x5bb;'),
    ('4fb2a6', 'if (rd16(self, (ptrdiff_t)idx + 0x132) == 0) {', 'if ((uint8_t)rd16(self, (ptrdiff_t)idx + 0x132) == 0) {'),
]


def main():
    text = (SRC / 'original_methods_fl32c.c').read_text()
    survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl32c.c').write_text(mutated)
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
