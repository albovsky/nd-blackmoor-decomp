#!/usr/bin/env python3
"""FL-34 (batch c): hand-written mutants (shapes the mechanical tests/fl34c_mutation_check.py does not model: a changed width, a swapped order of a call and a store, a
read on the wrong side of a call, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl34c.c; the direct test and then the
Unicorn differential test of the function must fail. Prints where each was caught; exits 1 if any survives.

Run from outputs/blackmoor-decomp:  python3 tests/fl34c_hand_mutants.py [--both]
"""
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl34c_direct as direct
import fl34c_mutation_check as mc

SRC = HERE.parent / 'src'
POST_CALL = '    r = callv(host, 0x4c5377, 0x5cf659, a, 5);\n    world->word_5bb1c4 = 2;\n    *clear = 0;\n'
HAND = [
    ('4d0abc', POST_CALL, '    world->word_5bb1c4 = 2;\n    *clear = 0;\n    r = callv(host, 0x4c5377, 0x5cf659, a, 5);\n'),                  # the stores before the call
    ('4d0abc', 'world->word_5bb1c4 = 2;', 'world->word_5bb1c4 = 3;'),
    ('4d0abc', 'world->word_5bb1c4 = 2;', 'wr32((uint8_t *)&world->word_5bb1c4, 0, 2);'),                                                          # a dword store (clears the next word)
    ('4d0abc', '    *clear = 0;\n', '    *clear = 0;\n    world->word_63a97e = 0;\n'),                                                                     # a store into another row's word
    ('4d0abc', 'a[1] = rd32(res(host, 0x5cf665), 0);', 'a[1] = rd32(res(host, 0x5cf669), 0);'),
    ('4d0abc', 'a[3] = rd32(res(host, g3), 0);', 'a[3] = rd16(res(host, g3), 0);'),                                                                 # a word read
    ('4d0abc', 'a[3] = rd32(res(host, g3), 0);\n    a[2] = rd32(res(host, g2), 0);', 'a[3] = rd32(res(host, g2), 0);\n    a[2] = rd32(res(host, g3), 0);'),                    # the two globals swapped
    ('4d0abc', 'return r;', 'return r + 1;'),
    ('4d0abc', 'return post_message(world, &world->word_63a97c, 0x5d2a1f, 0x5d2a23, 0x5d2a27, 0x55a05c, host);',
               'return post_message(world, &world->word_63a97e, 0x5d2a1f, 0x5d2a23, 0x5d2a27, 0x55a05c, host);'),                                   # the next row's word
    ('4d0c17', 'return post_message(world, &world->word_63a97e, 0x5d2bdb, 0x5d2bdf, 0x5d2be3, 0x55a0e8, host);',
               'return post_message(world, &world->word_63a97e, 0x5d2bdb, 0x5d2bdf, 0x5d2be3, 0x55a05c, host);'),                                   # another row's text
    ('4d0c17', 'return post_message(world, &world->word_63a97e, 0x5d2bdb, 0x5d2bdf, 0x5d2be3, 0x55a0e8, host);',
               'return post_message(world, &world->word_63a97c, 0x5d2bdb, 0x5d2bdf, 0x5d2be3, 0x55a0e8, host);'),                                   # another row's word
    ('4e01fb', 'return post_message(world, &world->word_63a9d0, 0x5d2819, 0x5d281d, 0x5d2821, 0x55ba9c, host);',
               'return post_message(world, &world->word_63a9d0, 0x5d2819, 0x5d281d, 0x5d2821, 0x55a0e8, host);'),
    ('4e01fb', 'return post_message(world, &world->word_63a9d0, 0x5d2819, 0x5d281d, 0x5d2821, 0x55ba9c, host);',
               'return post_message(world, &world->word_63a9d0, 0x5d2bdb, 0x5d2bdf, 0x5d2be3, 0x55ba9c, host);'),                                   # another row's globals
    ('4cca9c', '    wr32(rec, 0x14, a2);', '    wr16(rec, 0x14, (uint16_t)a2);'),
    ('4cca9c', '    wr32(rec, 0x28, a3);', '    wr32(rec, 0x28, a2);'),
    ('4cca9c', '    wr32(rec, 0, a1);', '    wr32(rec, 0, a1 + 1);'),
    ('4cca9c', '    return a3;', '    return a2;'),
    ('4cca9c', '    a[0] = (uintptr_t)rec;', '    a[0] = (uintptr_t)self;'),
    ('4cca9c', '    (void)callv(host, 0x4cc962, (uintptr_t)self, a, 1);\n    wr32(rec, 0, a1);\n    wr32(rec, 0x14, a2);\n    wr32(rec, 0x28, a3);\n',
               '    wr32(rec, 0, a1);\n    wr32(rec, 0x14, a2);\n    wr32(rec, 0x28, a3);\n    (void)callv(host, 0x4cc962, (uintptr_t)self, a, 1);\n'),         # the stores before the call
    ('4cca9c', '(void)callv(host, 0x4cc962, (uintptr_t)self, a, 1);', '(void)callv(host, 0x4cc962, (uintptr_t)self + 1, a, 1);'),                          # this off by one
    ('446f77', '    (void)callv(host, 0x51d716, (uintptr_t)self, NULL, 0);\n    wr32(self, 0, 0x52ca58);\n    wr32(self, 0x31, 0);\n    wr32(self, 0x35, 0);\n',
               '    wr32(self, 0, 0x52ca58);\n    wr32(self, 0x31, 0);\n    wr32(self, 0x35, 0);\n    (void)callv(host, 0x51d716, (uintptr_t)self, NULL, 0);\n'),        # the stores before the call
    ('446f77', 'wr32(self, 0x35, 0);', 'wr16(self, 0x35, 0);'),
    ('446f77', 'wr32(self, 0x31, 0);', 'wr16(self, 0x31, 0);'),
    ('446f77', 'wr32(self, 0, 0x52ca58);', 'wr16(self, 0, 0xca58);'),
    ('446f77', '    return self;', '    return NULL;'),
    ('4fce5e', '(uint32_t)((int32_t)index * 0x8d)', '(uint32_t)((int32_t)(uint16_t)index * 0x8d)'),                                                   # zero-extension instead of movsx
    ('4fce5e', '(uint32_t)((int32_t)index * 0x8d)', '(uint32_t)(uint16_t)((int32_t)index * 0x8d)'),                                                   # a 16-bit product
    ('4fce5e', '(uint32_t)((int32_t)index * 0x8d)', '(uint32_t)((int32_t)index * 0x8c)'),
    ('4fce5e', 'a[0] = rd32(res(host, 0x5bb5e5u + offset), 0);', 'a[0] = rd16(res(host, 0x5bb5e5u + offset), 0);'),
    ('4fce5e', 'return callv(host, 0x4f7e93, 0x5cf1eb, a, 1);', 'callv(host, 0x4f7e93, 0x5cf1eb, a, 1);\n    return 0;'),
    ('4fce5e', 'return callv(host, 0x4f7e93, 0x5cf1eb, a, 1);', 'return callv(host, 0x4f7e93, 0x5cf1eb, a, 0);'),
    ('4d3ffe', '    wr32(self, 0x440, 1);\n    r = callv(host, 0x4dad60, 0x5830a6, NULL, 0);\n', '    r = callv(host, 0x4dad60, 0x5830a6, NULL, 0);\n    wr32(self, 0x440, 1);\n'),   # the 1 after the call
    ('4d3ffe', '    r = callv(host, 0x4dad60, 0x5830a6, NULL, 0);\n    wr32(self, 0x462, 0);\n', '    wr32(self, 0x462, 0);\n    r = callv(host, 0x4dad60, 0x5830a6, NULL, 0);\n'),   # the clear before the call
    ('4d3ffe', 'res(host, 0x61c6ae)[0] != 0', 'rd16(res(host, 0x61c6ae), 0) != 0'),
    ('4d3ffe', 'res(host, 0x61c6ae)[0] != 0', 'rd32(res(host, 0x61c6ae), 0) != 0'),
    ('4d3ffe', 'res(host, 0x61c6ae)[0] != 0', '(res(host, 0x61c6ae)[0] & 0x7f) != 0'),
    ('4d3ffe', 'res(host, 0x61c6ae)[0] != 0', '(int8_t)res(host, 0x61c6ae)[0] > 0'),
    ('4d3ffe', '    wr32(self, 0x1c, 0);', '    wr16(self, 0x1c, 0);'),
    ('4d3ffe', '    wr32(self, 0x462, 0);', '    wr16(self, 0x462, 0);'),
    ('4d3ffe', '    wr32(self, 0x440, 1);', '    wr16(self, 0x440, 1);'),
    ('4d3ffe', '    return (uintptr_t)self;', '    return r;'),
    ('4d3ffe', 'if (res(host, 0x61c6ae)[0] != 0) return r;', 'if (res(host, 0x61c6ae)[0] != 0) return r ^ 1;'),
    ('47a3d9', 'if (x != 0) {', 'if ((uint16_t)x != 0) {'),
    ('47a3d9', 'if (x != 0) {', 'if ((int32_t)x > 0) {'),
    ('47a3d9', '        wr32(self, 0x1576, 1);\n        wr32(self, 0x24, 1);', '        wr16(self, 0x1576, 1);\n        wr32(self, 0x24, 1);'),
    ('47a3d9', '        wr32(self, 0x24, 1);', '        wr16(self, 0x24, 1);'),
    ('47a3d9', '    wr32(self, 0x1576, 0);\n    return 0;', '    wr32(self, 0x1576, 0);\n    wr32(self, 0x24, 0);\n    return 0;'),
    ('47a3d9', '    wr32(self, 0x1576, 0);\n    return 0;', '    wr16(self, 0x1576, 0);\n    return 0;'),
    ('47a3d9', '        return (uintptr_t)self;', '        return 0;'),
]


BOTH = '--both' in sys.argv       # also run the Unicorn differential on the mutants that the direct test already caught


def main():
    text = (SRC / 'original_methods_fl34c.c').read_text()
    survived = 0
    diff_survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        m = re.search(r'/\* (?:---- )?0x%s[ ,]' % key, text)
        start = m.start()
        at = text.find(old, start)
        if at < 0:
            raise SystemExit('stale hand mutant (not inside 0x%s): %r' % (key, old))
        mutated = text[:at] + new + text[at + len(old):]
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl34c.c').write_text(mutated)
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
            diff_caught = None
            if where is None or (BOTH and where != 'build'):
                child = subprocess.run([sys.executable, '-c', mc.DIFFERENTIAL_CHILD, str(tmp), mc.FUNCS[key]], capture_output=True, text=True, timeout=600, cwd=str(HERE.parent))
                diff_caught = child.returncode != 0
                if where is None:
                    where = 'differential' if diff_caught else 'SURVIVED'
                else:
                    where += ' + differential' if diff_caught else ' (differential SURVIVED)'
                    diff_survived += not diff_caught
        survived += where == 'SURVIVED'
        print('0x%s %-12s | %s' % (key, where, old[:60].replace('\n', ' ')))
    print('hand mutants %d, survivors %d, caught by the direct test but not by the differential %d' % (len(HAND), survived, diff_survived))
    return 1 if survived or diff_survived else 0


if __name__ == '__main__':
    sys.exit(main())
