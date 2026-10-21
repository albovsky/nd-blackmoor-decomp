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
    ('4c36b2', 'if ((int32_t)rd32(o, 0x2d) > (int32_t)H || (int32_t)rd32(o, 0x29) > (int32_t)W) return 0;', 'if (rd32(o, 0x2d) > H || (int32_t)rd32(o, 0x29) > (int32_t)W) return 0;'),
    ('4c36b2', 'if ((int32_t)rd32(o, 0x2d) > (int32_t)H || (int32_t)rd32(o, 0x29) > (int32_t)W) return 0;', 'if ((int32_t)rd32(o, 0x2d) > (int32_t)H || rd32(o, 0x29) > W) return 0;'),
    ('4c36b2', 'if ((int32_t)rd32(o, 0x2d) > (int32_t)H || (int32_t)rd32(o, 0x29) > (int32_t)W) return 0;', 'if ((int32_t)rd32(o, 0x2d) > (int32_t)H && (int32_t)rd32(o, 0x29) > (int32_t)W) return 0;'),
    ('4c36b2', 'if (!((int32_t)w2 < (int32_t)W) && (int32_t)h2 >= (int32_t)H) {', 'if (!(w2 < W) && (int32_t)h2 >= (int32_t)H) {'),
    ('4c36b2', 'if (!((int32_t)w2 < (int32_t)W) && (int32_t)h2 >= (int32_t)H) {', 'if (!((int32_t)w2 < (int32_t)W) && h2 >= H) {'),
    ('4c36b2', 'if (!((int32_t)w2 < (int32_t)W) && (int32_t)h2 >= (int32_t)H) {', 'if (!((int32_t)w2 < (int32_t)W) || (int32_t)h2 >= (int32_t)H) {'),
    ('4c36b2', 'for (i = 0; (int32_t)i < (int32_t)h2; i++) {', 'for (i = 0; i < h2; i++) {'),
    ('4c36b2', 'src = buf1 + bpp * (W * rd32(o, 0x25) + rd32(o, 0x21));', 'src = buf1 + bpp * (W * rd32(o, 0x21) + rd32(o, 0x25));'),
    ('4c36b2', '            src += W * bpp;', '            src += w2 * bpp;'),
    ('4c36b2', '            dst += w2 * bpp;', '            dst += W * bpp;'),
    ('4c36b2', 'if (o[0x31] == 0) {', 'if (rd16(o, 0x31) == 0) {'),
    ('4c36b2', '        hdr[2] = 2;', '        hdr[2] = 3;'),
    ('4c36b2', 'wr16(hdr, 0xc, (uint16_t)w2);\n        wr16(hdr, 0xe, (uint16_t)h2);', 'wr16(hdr, 0xc, (uint16_t)h2);\n        wr16(hdr, 0xe, (uint16_t)w2);'),
    ('4c36b2', 'hdr[0x10] = world->byte_639893;', 'hdr[0x10] = (uint8_t)world->word_639895;'),
    ('4c36b2', '    if (buf1 != 0) {\n        call1(host, 0x51dc6c, 0, buf1);\n        buf1 = 0;\n    }\n    if (buf2 != 0) {\n        call1(host, 0x51dc6c, 0, buf2);\n        buf2 = 0;\n    }',
     '    if (buf2 != 0) {\n        call1(host, 0x51dc6c, 0, buf2);\n        buf2 = 0;\n    }\n    if (buf1 != 0) {\n        call1(host, 0x51dc6c, 0, buf1);\n        buf1 = 0;\n    }'),
    ('4c36b2', '    world->value_5839a9 = 0;\n    wr32(res(host, rec + 0x4d), 0, 3);', '    wr32(res(host, rec + 0x4d), 0, 3);'),
    ('4c36b2', '    world->value_5839a9 = 0;\n    wr32(res(host, rec + 0x4d), 0, 3);', '    world->value_5839a9 = 0;\n    wr32(res(host, rec + 0x4d), 0, 2);'),
    ('4c36b2', 'if (state != 2) return 0;', 'if ((uint8_t)state != 2) return 0;'),
    ('4c36b2', 'if (state == 3) {', 'if ((uint16_t)state == 3) {'),
    ('4c36b2', 'call1(host, 0x42ba3a, 0, (uint16_t)index);', 'call1(host, 0x42ba3a, 0, index);'),
    ('4c36b2', 'const int32_t idx = (int16_t)index;', 'const int32_t idx = (uint16_t)index;'),
    ('4c36b2', 'if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x554120);\n        return 1;', 'call1(host, 0x44a2b7, 0, 0x554120);\n        return 1;'),
    ('4c36b2', 'a5[0] = buf1; a5[1] = v2; a5[2] = H; a5[3] = W * bpp; a5[4] = v1;', 'a5[0] = buf1; a5[1] = v2; a5[2] = W; a5[3] = W * bpp; a5[4] = v1;'),
    ('4c36b2', 'call2(host, 0x4c7481, (uintptr_t)self, buf2, size2);', 'call2(host, 0x4c7481, (uintptr_t)self, buf2, size1);'),
    ('4c36b2', 'size2 = w2 * h2 * bpp;', 'size2 = w2 * h2;'),
    ('4c36b2', 'rep_movs(host, buf2, buf1, W * H * bpp);', 'rep_movs(host, buf2, buf1, W * H);'),
    ('4c36b2', '== 0 && world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x554204);', '== 0 || world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x554204);'),
    ('4c36b2', '        if (fp != 0) {', '        if (fp == 0) {'),
    ('4c36b2', '            call1(host, 0x50cee4, 0, fp);', '            call1(host, 0x50cee4, 0, 0);'),
    ('4c36b2', 'call2(host, 0x50d0a9, 0, 0x63888b, 0x554240);', 'call2(host, 0x50d0a9, 0, 0x554240, 0x63888b);'),
    ('4c36b2', '        call0(host, 0x4d36ed, obj);', '        call0(host, 0x4d36ed, rec);'),
    ('4c36b2', '        world->value_5839a9 = 1;\n        call0', '        world->value_5839a9 = 0;\n        call0'),
    # EQUIVALENT (not a mutant): in 0x4f379c `(int32_t)size > 0x56220` -> `size > 0x56220`: a negative size has already returned, so signed and unsigned agree here.
    # EQUIVALENT (not a mutant): in 0x4f379c `rds16(o, 0x10e) != 2` -> `rd16(...) != 2`: only the word 2 equals 2 both ways.
    # EQUIVALENT (not a mutant): in 0x4c36b2 `if (count == 0) return;` of rep_movs deleted: a zero length copy changes nothing.
    # EQUIVALENT (not a mutant): in 0x4c36b2 the local sizes `desc[0x80]` and `hdr[0x12]` (0x81 / 0x13): host scratch sizes; only pointers and the first 0x12 bytes are observed.
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
