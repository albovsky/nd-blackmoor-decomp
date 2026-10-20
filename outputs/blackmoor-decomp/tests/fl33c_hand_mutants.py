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
    ('416af3', 'if (flag == 0) rep_movs(host, out, base, size);', 'if ((uint16_t)flag == 0) rep_movs(host, out, base, size);'),
    ('416af3', 'while ((int32_t)idx < (int32_t)count) {', 'while (idx < count) {'),
    ('416af3', 'idx = idx + rdb(host, p + 1) * 2u;', 'idx = idx + rdw(host, p + 1) * 2u;'),
    ('416af3', '                idx = idx + rdd(host, p + 5) * 2u;', '                idx = idx + rdd(host, p + 5);'),
    ('416af3', '                rep_movs(host, out + rdd(host, p + 1) * 2u, stream + idx, rdd(host, p + 5) << 1);\n                call2(host, 0x4c7314, 0x5cf659, out + rdd(host, p + 1) * 2u, rdd(host, p + 5) << 1);',
     '                call2(host, 0x4c7314, 0x5cf659, out + rdd(host, p + 1) * 2u, rdd(host, p + 5) << 1);\n                rep_movs(host, out + rdd(host, p + 1) * 2u, stream + idx, rdd(host, p + 5) << 1);'),
    ('416af3', 'call3(host, 0x43ef77, 0x5d2f2d, out + rdd(host, p + 3) * 2u, rdw(host, p + 1), rdd(host, p + 7));\n                call2', 'call3(host, 0x43ef77, 0x5d2f2d, out + rdd(host, p + 3) * 2u, rdd(host, p + 1), rdd(host, p + 7));\n                call2'),
    ('416af3', '                return 1;                                  /* the original jumps to the loop head again and again */', '                break;'),
    ('416af3', 'call2(host, 0x4c7314, 0x5cf659, out, size);', 'call2(host, 0x4c7314, 0x5cf659, size, out);'),
    ('416af3', '} else if (kind == 2) {', '} else if (kind == 3) {'),
    ('416af3', 'for (k = 0; (int32_t)k < (int32_t)rdd(host, p + 2); k++) {\n                    off = rdd(host, stream + idx);\n                    rep_movs(host, out + off * 2u, data, rdb(host, p + 1) * 2u);',
     'for (k = 0; k < rdd(host, p + 2); k++) {\n                    off = rdd(host, stream + idx);\n                    rep_movs(host, out + off * 2u, data, rdb(host, p + 1) * 2u);'),
    ('416af3', 'rep_movs(host, out + off * 2u, data, m * 2u);', 'rep_movs(host, out + off * 2u, data, (uint32_t)(int8_t)m * 2u);'),
    ('4db38a', 'if ((int32_t)rd32(self, 0x94) > (int32_t)world->word_5d2f0d) {', 'if (rd32(self, 0x94) > (uint32_t)(int32_t)world->word_5d2f0d) {'),
    ('4db38a', 'if ((int32_t)(rd32(self, 0x14) - rd32(self, 0x34)) > 0) wr32', 'if ((int32_t)(rd32(self, 0x14) - rd32(self, 0x34)) >= 0) wr32'),
    ('4db38a', 'else wr32(self, 0x14, rd32(self, 0x34) - (uint32_t)(int32_t)world->word_5d2f0d);', 'else wr32(self, 0x14, rd32(self, 0x34) + (uint32_t)(int32_t)world->word_5d2f0d);'),
    ('4db38a', 'wr32(self, 0x18, rd32(self, 0x38) + (uint32_t)(int32_t)world->word_5d2f0f);', 'wr32(self, 0x18, rd32(self, 0x38) + (uint32_t)(int32_t)world->word_5d2f0d);'),
    ('4db38a', '    if (v > 3) {', '    if ((int32_t)v > 3) {'),
    ('4db38a', '            world->value_5d1683 = 1;\n', ''),
    ('4db38a', 'e = (world->value_5b44f4 << 2) + world->value_5b44f0 * 8u;\n    wr32(self, 0x40', 'e = (world->value_5b44f4 << 3) + world->value_5b44f0 * 8u;\n    wr32(self, 0x40'),
    ('4db38a', 'f = (world->value_5b44f0 << 4) + world->value_5b44f4 * 8u;\n    wr32(self, 0x9c', 'f = (world->value_5b44f0 << 3) + world->value_5b44f4 * 8u;\n    wr32(self, 0x9c'),
    ('4db38a', 'wr32(self, 0x48, rd32(self, 0x38) - world->value_58318a);', 'wr32(self, 0x48, rd32(self, 0x38) - world->value_583186);'),
    ('4db38a', '} else if (world->word_63a4cd != 0) {', '} else if ((uint8_t)world->word_63a4cd != 0) {'),
    ('4db38a', 'p = rp == (uint32_t)(uintptr_t)pair ? (const uint8_t *)pair : res(host, rp);\n    x = rd32(p, 0);\n    y = rd32(p, 4);\n    wr32(self, 0x14', 'p = res(host, rp);\n    x = rd32(p, 0);\n    y = rd32(p, 4);\n    wr32(self, 0x14'),
    ('4db38a', '    call0(host, 0x4dbb13, (uintptr_t)self);\n    v = world->value_583204 - 2u;', '    v = world->value_583204 - 2u;'),
    ('4db38a', '    wr32(self, 0x1c, rd32(self, 0x14));\n    wr32(self, 0x20, rd32(self, 0x18));', '    wr32(self, 0x20, rd32(self, 0x18));\n    wr32(self, 0x1c, rd32(self, 0x14));\n    wr32(self, 0x1c, rd32(self, 0x1c) ^ 1u);'),
    # EQUIVALENT (not a mutant): in 0x4db38a `>` -> `>=` of |dx| against the word: when they are equal the clamped coordinate equals x0 + dx
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
