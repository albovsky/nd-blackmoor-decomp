#!/usr/bin/env python3
"""FL-32 (batch a): hand-written mutants (shapes the mechanical tests/fl32a_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl32a.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives. (The order of the two stores of a flag toggle is not a mutant: both are made before the one call and the two are different globals.)

Run from outputs/blackmoor-decomp:  python3 tests/fl32a_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl32a_direct as direct
import fl32a_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    # 0x40425d family (text field -> word)
    ('40425d', 'call2(host, 0x51d5b2, (uintptr_t)(self + field), (uintptr_t)buffer, 0x13);', 'call2(host, 0x51d5b2, (uintptr_t)(self + field), 0x13, (uintptr_t)buffer);'),
    ('40425d', 'call2(host, 0x51d5b2, (uintptr_t)(self + field), (uintptr_t)buffer, 0x13);', 'call2(host, 0x51d5b2, (uintptr_t)(self + 0 * field), (uintptr_t)buffer, 0x13);'),
    ('40425d', 'call2(host, 0x51d5b2, (uintptr_t)(self + field), (uintptr_t)buffer, 0x13);', 'call2(host, 0x51d5b2, (uintptr_t)(self + field), (uintptr_t)buffer, 0x14);'),
    ('40425d', 'r = call1(host, 0x50cb1b, 0, (uintptr_t)buffer);', 'r = call1(host, 0x50cb1b, (uintptr_t)self, (uintptr_t)buffer);'),
    ('40425d', '    world->word_5ec33e = read_text_word(self, 0xcc, host);\n    call0(host, 0x4033db, (uintptr_t)self);',
     '    call0(host, 0x4033db, (uintptr_t)self);\n    world->word_5ec33e = read_text_word(self, 0xcc, host);'),
    ('40425d', '    world->word_5ec33e = read_text_word(self, 0xcc, host);', '    { uint32_t t_ = read_text_word(self, 0xcc, host); memcpy(&world->word_5ec33e, &t_, 4); }'),
    ('40425d', 'return (uint16_t)r;', 'return (uint16_t)(r >> 1);'),
    ('404298', 'world->word_5ec340 = read_text_word(self, 0x10c, host);', 'world->word_5ec340 = read_text_word(self, 0x1cc, host);'),
    ('4042d3', 'world->word_5e5688 = read_text_word(self, 0x1cc, host);', 'world->word_5e5688 = read_text_word(self, 0xcc, host);'),
    ('4042d3', 'world->word_5e5688 = read_text_word', 'world->word_5ec340 = read_text_word'),
    # 0x4029a9 family (table toggle)
    ('4029a9', ') == 1)\n        wr32(table', ') != 0)\n        wr32(table'),
    ('4029a9', 'if (rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4) == 1)', 'if ((uint16_t)rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4) == 1)'),
    ('4029a9', 'if (rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4) == 1)', 'if (rd32(table, (ptrdiff_t)(uint16_t)rd32(self, 0x5c) * 4) == 1)'),
    ('4029a9', 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4, 0);', 'wr32(table, (ptrdiff_t)(uint16_t)rd32(self, 0x5c) * 4, 0);'),
    ('4029a9', 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4, 1);', 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4, 2);'),
    ('4029a9', '    toggle_dword(self, world->table_5e60da + 0);\n    call0(host, 0x40236a, (uintptr_t)self);', '    call0(host, 0x40236a, (uintptr_t)self);\n    toggle_dword(self, world->table_5e60da + 0);'),
    ('4029f0', 'toggle_dword(self, world->table_5e60da + 4);', 'toggle_dword(self, world->table_5e60da + 0);'),
    ('402a37', 'toggle_dword(self, world->table_5e60da + 8);', 'toggle_dword(self, world->table_5e60da + 4);'),
    ('402a37', 'call0(host, 0x40236a, (uintptr_t)self);\n}\n\n/* ---- 0x4067eb', 'call0(host, 0x40236a, 0);\n}\n\n/* ---- 0x4067eb'),
    # 0x4067eb family (flag toggle)
    ('4067eb', 'if ((int16_t)world->word_5e335e == 1) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 1) world->word_5e335e = 0xffff;'),
    ('4067eb', 'if ((int16_t)world->word_5e335e == 1) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 1) world->word_5e335e = 0;'),
    ('4067eb', 'if (world->dword_5e350e == 1) {', 'if ((world->dword_5e350e & 0xffff) == 1) {'),
    ('4067eb', '        world->dword_5e350e = 1;\n        if ((int16_t)world->word_5e335e == 1)', '        world->dword_5e350e = 1;\n        if ((int16_t)world->word_5e335e == 2)'),
    ('4067eb', '        world->dword_5e350e = 0;\n    } else {', '        world->dword_5e350e = 0;\n        if ((int16_t)world->word_5e335e == 1) world->word_5e335e = 0xffff;\n    } else {'),
    ('406832', 'if ((int16_t)world->word_5e335e == 2)', 'if ((int16_t)world->word_5e335e == 1)'),
    ('406832', 'if (world->dword_5e3512 == 1) {', 'if (world->dword_5e3512 != 0) {'),
    ('406832', 'world->dword_5e3512 = 1;', 'world->dword_5e3516 = 1;'),
    ('406879', 'if (world->dword_5e3516 == 1) {', 'if (world->dword_5e3516 & 1) {'),
    ('406879', 'if ((int16_t)world->word_5e335e == 3) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 3) world->word_5e335e = 0x7fff;'),
    ('406879', 'call0(host, 0x404be1, (uintptr_t)self);\n}\n\n/* FNS-END */', 'call0(host, 0x404be1, (uintptr_t)(self + 1));\n}\n\n/* FNS-END */'),
]


def main():
    text = (SRC / 'original_methods_fl32a.c').read_text()
    survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl32a.c').write_text(mutated)
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
