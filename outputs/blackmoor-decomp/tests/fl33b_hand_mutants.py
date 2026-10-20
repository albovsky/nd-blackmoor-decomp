#!/usr/bin/env python3
"""FL-33 (batch b): hand-written mutants (shapes the mechanical tests/fl33b_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a changed helper, an `&&` for an `||`). Each is applied to a scratch copy of src/original_methods_fl33b.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives.

Run from outputs/blackmoor-decomp:  python3 tests/fl33b_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl33b_direct as direct
import fl33b_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    # 0x47d02d
    ('47d02d', '(r & 0xffff0000u) | rd16(res(host, rec), 0x21)', 'r | rd16(res(host, rec), 0x21)'),
    ('47d02d', 'if (n + 7 > sizeof buf) return 1;', 'if (n + 8 > sizeof buf) return 1;'),
    ('47d02d', 'buf[n + 6] = res(host, 0x54d15e)[0];', 'buf[n + 5] = res(host, 0x54d15e)[0];'),
    ('47d02d', 'memcpy(buf + n + 4, res(host, 0x54d164), 2);', 'memcpy(buf + n + 4, res(host, 0x54d164), 1);'),
    ('47d02d', 'rep_movs(buf, res(host, t), n + 1);', 'rep_movs(buf, res(host, t), n);', 'the NUL copied here is overwritten by the first of the 7 appended bytes'),
    # 0x4c51a5
    ('4c51a5', 'if (!(w1 == w2 && h1 == h2 && a != 0 && b != 0)) {', 'if (!(w1 == w2 && h1 == h2 && (a != 0 || b != 0))) {'),
    ('4c51a5', 'p += (uint32_t)rds16(da, 0x2f);\n            q += (uint32_t)rds16(db, 0x2f);', 'p += (uint32_t)rds16(db, 0x2f);\n            q += (uint32_t)rds16(da, 0x2f);'),
    ('4c51a5', 'rows = (int32_t)(rd32(f, 12) - rd32(f, 4) + 1);', 'rows = (int32_t)(rd32(f, 12) - rd32(f, 4));'),
    ('4c51a5', 'if (rows > 0 && (int32_t)bytes < 0) return 1;', 'if ((int32_t)bytes < 0) return 1;'),
    ('4c51a5', 'uint32_t bpp = (uint32_t)(int32_t)(int16_t)world->word_639895;', 'uint32_t bpp = (uint32_t)(uint16_t)world->word_639895;'),
    ('4c51a5', 'uint32_t w1 = rd32(f, 8) - rd32(f, 0), h1 = rd32(f, 12) - rd32(f, 4);', 'uint32_t w1 = rd32(f, 8) - rd32(f, 4), h1 = rd32(f, 12) - rd32(f, 4);'),
    ('4c51a5', 'for (i = 0; i < (n & 3); i++) dst[4 * (size_t)d + i] = src[4 * (size_t)d + i];', 'for (i = 0; i < (n & 7); i++) dst[4 * (size_t)d + i] = src[4 * (size_t)d + i];'),
    # 0x47df57
    ('47df57', 'if (width < size && world->value_624705 == 0)', 'if ((uint32_t)width < (uint32_t)size && world->value_624705 == 0)'),
    ('47df57', 'pt[2] = (uint32_t)size - 1;', 'pt[2] = (uint32_t)size;'),
    ('47df57', 'r1[1] = world->value_624719 + world->value_58318a;', 'r1[1] = world->value_624719 + world->value_583186;'),
    ('47df57', 'size = (int32_t)world->word_624731 * 2;', 'size = (int32_t)(uint16_t)world->word_624731 * 2;'),
    ('47df57', 'if (height < size && world->value_624709 == 0) pt[1] = (uint32_t)size - (uint32_t)height;', 'if (height < size && world->value_624709 == 0) pt[0] = (uint32_t)size - (uint32_t)height;'),
    # 0x4c2898
    ('4c2898', 'size = (uint32_t)(ws * bpp) * (uint32_t)hs;', 'size = (uint32_t)(ws * bpp);'),
    ('4c2898', 'wr16(rec, 0x2f, (uint16_t)(ws * bpp));', 'wr16(rec, 0x2f, (uint16_t)size);'),
    ('4c2898', 'wr32(rec, 0x3d, (uint32_t)(ws - 1));', 'wr32(rec, 0x3d, (uint32_t)ws);'),
    ('4c2898', 'int32_t ws = (int16_t)w, hs = (int16_t)h, bpp = world->word_639895;', 'int32_t ws = (uint16_t)w, hs = (int16_t)h, bpp = world->word_639895;'),
    ('4c2898', '    rep_stos(res(host, rd32(res(host, pp), 0)), 0, 0x59);\n', ''),
    ('4c2898', 'rep_movs(rec + 8, res(host, name), n);', 'rep_movs(rec + 8, res(host, name), n - 1);', 'the record was cleared just before: the NUL of the name is already there'),
    # 0x4f594d
    ('4f594d', 'S[6] = (len == rd32(res(host, rec), 0x15e) && buf == 0) ? 2 : 0;', 'S[6] = (len == rd32(res(host, rec), 0x15e) || buf == 0) ? 2 : 0;'),
    ('4f594d', '} else if (n < (int32_t)len) {', '} else if ((uint32_t)n < len) {'),
    ('4f594d', 'uint32_t fill = rd16(res(host, rec), 0x2ed) == 8 ? 0x80808080u : 0;', 'uint32_t fill = rd16(res(host, rec), 0x2ed) == 8 ? 0x80u : 0;'),
    ('4f594d', '            len = len - (uint32_t)n;\n', ''),
    ('4f594d', 'if (S[3] != len || S[4] != 0) {', 'if (S[3] != len) {'),
    ('4f594d', 'wr32(res(host, item), 0xc, 1);', 'wr32(res(host, item), 0x10, 1);'),
    # 0x41e3c0
    ('41e3c0', 'memcpy(buf + e, res(host, 0x54388c), 4);', 'memcpy(buf + e, res(host, 0x54388c), 3);'),
    ('41e3c0', 'off = (int16_t)(off + (int16_t)c_strlen(res(host, 0x543890)));', 'off = (int16_t)(off + (int16_t)c_strlen(res(host, 0x543898)));'),
    ('41e3c0', 'rep_movs(buf + e, text, n + 1);', 'rep_movs(buf + e, text, n);'),
    ('41e3c0', 'if (n == sizeof text) return 1;', 'if (n > sizeof text) return 1;'),
    ('41e3c0', 'rep_movs(buf + off, res(host, a), n);', 'rep_movs(buf + off, res(host, a), n + 1);'),
    ('41e3c0', 'int16_t off = 0, i;', 'int16_t off = 0;\n    int32_t i;', 'the counter stays below the signed word count (at most 0x7fff): a 16-bit wrap cannot happen'),
    ('41e3c0', 'item = res(host, rd32(world->records_5bb5e5, (ptrdiff_t)(int16_t)idx * 0x8d));', 'item = res(host, rd32(world->records_5bb5e5, (ptrdiff_t)(uint16_t)idx * 0x8d));'),
    ('41e3c0', 'if (pos < 0 || pos >= F33_BUF) return -1;', 'if (pos > F33_BUF) return -1;', 'the scan loop below does not run for pos >= F33_BUF and returns -1 itself: the upper bound test is redundant'),
    # 0x4f5b50
    ('4f5b50', 'if (go < 0 || flag != 0) {', 'if (go < 0 && flag != 0) {'),
    ('4f5b50', 'if ((fl & 0x20) != 0 || (fl & 0x10) == 0) {', 'if ((fl & 0x30) == 0) {'),
    ('4f5b50', 'while (pos < (int32_t)len && go != 0) {', 'while ((uint32_t)pos < len && go != 0) {'),
    ('4f5b50', 'if (world->word_63a4cd == 2) {', 'if (world->word_63a4cd != 0) {'),
    ('4f5b50', '    wr32(self, 0x3c2, 0x3e8);\n', ''),
    ('4f5b50', 'if (rd16(res(host, rec), 0x2ed) == 8) {', 'if (rds16(res(host, rec), 0x2ed) == 8) {', 'a word equals 8 as unsigned exactly when it equals 8 as signed'),
    ('4f5b50', 'if (go == 0) call3(host, 0x4fdc70, 0, s, 0, 0);\n            pos += go;', 'pos += go;\n            if (go == 0) call3(host, 0x4fdc70, 0, s, 0, 0);', 'pos is a local that the callee cannot see'),
    # 0x41db40
    ('41db40', 'if (rds16(e, 0) > 0 && rd32(e, 2) != 0) {', 'if (rds16(e, 0) >= 0 && rd32(e, 2) != 0) {'),
    ('41db40', 'call1(host, 0x51dc6c, 0, q);\n            wr32(pr, T[k].ptr, 0);', 'wr32(pr, T[k].ptr, 0);\n            call1(host, 0x51dc6c, 0, q);'),
    ('41db40', 'if (rds16(pr, T[k].cnt) > 0 && rd32(pr, T[k].ptr) != 0) {', 'if (rds16(pr, T[k].cnt) > 0) {'),
    ('41db40', 'call1(host, 0x51dc6c, 0, q);\n    wr32(world->records_5bb5e5, (ptrdiff_t)(int16_t)idx * 0x8d, 0);', 'wr32(world->records_5bb5e5, (ptrdiff_t)(int16_t)idx * 0x8d, 0);\n    call1(host, 0x51dc6c, 0, q);'),
    ('41db40', 'const uint8_t *e = res(host, rd32(pr, T[k].ptr) + (uint32_t)((int32_t)i * (int32_t)T[k].stride));', 'const uint8_t *e = res(host, rd32(pr, T[k].ptr) + (uint32_t)((uint16_t)i * (int32_t)T[k].stride));', 'i is never negative (it counts up from 0 below a positive word)'),
]


def main():
    text = (SRC / 'original_methods_fl33b.c').read_text()
    survived = 0
    for key, old, new, *why in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl33b.c').write_text(mutated)
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
        if where == 'SURVIVED' and why:
            where = 'equivalent'
        survived += where == 'SURVIVED'
        print('0x%s %-12s | %s%s' % (key, where, old[:60].replace('\n', ' '), ' | ' + why[0] if where == 'equivalent' else ''))
    print('hand mutants %d, survivors %d' % (len(HAND), survived))
    return 1 if survived else 0


if __name__ == '__main__':
    sys.exit(main())
