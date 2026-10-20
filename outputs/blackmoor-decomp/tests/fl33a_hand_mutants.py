#!/usr/bin/env python3
"""FL-33 (batch a): hand-written mutants (shapes the mechanical tests/fl33a_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl33a.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives.

Run from outputs/blackmoor-decomp:  python3 tests/fl33a_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl33a_direct as direct
import fl33a_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    ('4dae88', 'call2(host, 0x52a488, 0, x, y)', 'call2(host, 0x52a488, 0, y, x)'),
    ('4dae88', '    wr32(self, 0x18, x);\n    wr32(self, 0x1c, y);\n    return call2(host, 0x52a488, 0, x, y);',
     '    uint32_t r = call2(host, 0x52a488, 0, x, y);\n    wr32(self, 0x18, x);\n    wr32(self, 0x1c, y);\n    return r;'),
    ('4dae88', 'return call2(host, 0x52a488, 0, x, y);', 'call2(host, 0x52a488, 0, x, y);\n    return 0;'),
    ('473117', 'wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);', 'wr32(world->table_5d15a5, (ptrdiff_t)(uint16_t)i * 0x4a, 1);'),
    ('473117', 'if (rd32(self, 0x7a) == 0) return;', 'if (rd16(self, 0x7a) == 0) return;'),
    ('4234dd', '(int32_t)rd32(self, 4) >= 0x80', 'rd32(self, 4) >= 0x80u'),
    ('4234dd', 'wr32(self, (ptrdiff_t)(int32_t)m + 0xc, a);', 'wr32(self, (ptrdiff_t)m + 0xc, a);'),
    ('4234dd', '    wr32(self, (ptrdiff_t)(int32_t)m + 0x10, b);\n    wr32(self, 4, rd32(self, 4) + 1u);', '    wr32(self, 4, rd32(self, 4) + 1u);\n    wr32(self, (ptrdiff_t)(int32_t)m + 0x10, b);'),
    ('4234dd', 'if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);', 'if ((uint8_t)world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);'),
    ('4c7623', '    w &= 0xffff;\n', ''),
    ('4c7623', 'seven[2] = RECT(0); seven[3] = RECT(0xc); seven[4] = RECT(8); seven[5] = RECT(0xc);', 'seven[2] = RECT(0); seven[3] = RECT(8); seven[4] = RECT(0xc); seven[5] = RECT(0xc);'),
    ('4c7623', 'v2 = rd32(desc, 0x24);', 'v2 = rd32(desc, 0x10);'),
    ('4bf3b8', 'if (v > 5) {', 'if ((int32_t)v > 5) {'),
    ('4bf3b8', 'for (i = 4 * n; i < len; i++) dst[i] = src[i];', 'for (i = 4 * n; i + 1 < len; i++) dst[i] = src[i];'),
    ('4bf3b8', 'call3(host, 0x50ca3e, 0, (uintptr_t)text, 0x552540, code);', 'call3(host, 0x50ca3e, 0, (uintptr_t)text, code, 0x552540);'),
    ('4bf3b8', 'uint32_t e = call0(host, 0x52a514, 0);', 'uint32_t e = 0;'),
    ('4db993', '    wr32(self, 0x28, world->value_583106);\n    wr32(self, 0x30, world->value_58310e);\n    wr32(self, 0x24, world->value_583102);\n    wr32(self, 0x2c, world->value_58310a);\n    world->value_583106 = rd32(self, 0x18);',
     '    world->value_583106 = rd32(self, 0x18);\n    wr32(self, 0x28, world->value_583106);\n    wr32(self, 0x30, world->value_58310e);\n    wr32(self, 0x24, world->value_583102);\n    wr32(self, 0x2c, world->value_58310a);'),
    ('4db993', '(int32_t)rd32(self, 0x14) < (int32_t)world->value_5b377c', 'rd32(self, 0x14) < world->value_5b377c'),
    ('4db993', '(int32_t)rd32(self, 0x18) > (int32_t)world->value_5b3788', 'rd32(self, 0x18) > world->value_5b3788'),
    ('4db993', 'p = rp == (uint32_t)(uintptr_t)pair ? (const uint8_t *)pair : res(host, rp);', 'p = res(host, rp);'),
    ('4db993', 'world->value_5b44f4 = 0;', ''),
    ('4db993', '(int32_t)world->word_583a29 == -1', '(uint16_t)world->word_583a29 == 0xffff && 0'),
    ('47d24e', '        callv(host, 0x4c5377, 0x5cf659, a, 5);\n        world->value_61e3c8 = 0;', '        world->value_61e3c8 = 0;\n        callv(host, 0x4c5377, 0x5cf659, a, 5);'),
    ('47d24e', 'i < (int32_t)world->value_61e618', '(uint32_t)i < world->value_61e618'),
    ('47d24e', 'if (world->value_61e3bc == 0) return;', 'if ((uint16_t)world->value_61e3bc == 0) return;'),
    ('47d24e', 'if ((int8_t)*res(host, p + 0x35b) != 0) {', 'if (*(const uint32_t *)res(host, p + 0x35b) != 0) {'),
    ('47d24e', 'rd32(res(host, e + 4), 0) == 1', 'rd32(res(host, e + 4), 0) != 0'),
    ('4c7070', '        for (j = w2 - 1; j >= 0; j--) {', '        for (j = 0; j < w2; j++) {'),
    ('4c7070', '    wr16(d, 0x2b, (uint16_t)w2);\n    wr16(d, 0x2d, (uint16_t)w1);\n    wr16(d, 0x2f, product);\n    wr16(d, 0x31, (uint16_t)w1);\n    call1(host, 0x51dc6c, 0, bufva);',
     '    call1(host, 0x51dc6c, 0, bufva);\n    wr16(d, 0x2b, (uint16_t)w2);\n    wr16(d, 0x2d, (uint16_t)w1);\n    wr16(d, 0x2f, product);\n    wr16(d, 0x31, (uint16_t)w1);'),
    ('4c7070', 'call0(host, 0x4c97b4, (uintptr_t)self);', 'call0(host, 0x4c97b4, (uintptr_t)self + 4);'),
    ('4c7070', 'for (q = 0; q < r; q++) buf[4 * n + q] = image[4 * n + q];', 'for (q = 0; q < r && q < 2; q++) buf[4 * n + q] = image[4 * n + q];'),
    # NOT a mutant: product = (uint16_t)(zero-extended w2 * zero-extended bpp) instead of the sign-extended operands is EQUIVALENT (the low 16 bits of a product depend only on the low 16 bits of the operands)
    ('4c7070', 'product = (uint16_t)((uint32_t)rds16(d, 0x2d) * (uint32_t)(int32_t)world->word_639895);', 'product = (uint16_t)((uint32_t)rds16(d, 0x2b) * (uint32_t)(int32_t)world->word_639895);'),
]


def main():
    text = (SRC / 'original_methods_fl33a.c').read_text()
    survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl33a.c').write_text(mutated)
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
