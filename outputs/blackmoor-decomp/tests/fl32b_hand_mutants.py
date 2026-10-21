#!/usr/bin/env python3
"""FL-32 (batch b): hand-written mutants (shapes the mechanical tests/fl32b_mutation_check.py does not model: a sign change of a compare, a swapped order of two effects,
a dropped store, a wrong argument, a wrong return value). Each is applied to a scratch copy of src/original_methods_fl32b.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives. (Swapping the two clearing stores of 0x47ba79 is not a mutant: the two stores hit disjoint dwords and the only
aliasing that would show the order, [self+0x1c]+4 == self+0x20, makes the original fault at address 0, so the order is not observable on a valid input.)

Run from outputs/blackmoor-decomp:  python3 tests/fl32b_hand_mutants.py [--both]
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl32b_direct as direct
import fl32b_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    ('40a613', 'memcmp(buf, res(host, tag), 4) != 0', 'memcmp(buf, res(host, tag), 3) != 0'),                 # only three bytes compared
    ('40a613', 'memcmp(buf, res(host, tag), 4) != 0', 'memcmp(buf, res(host, tag), 5) != 0'),                 # a fifth byte compared
    ('40a613', 'memcmp(buf, res(host, tag), 4) != 0', 'memcmp(buf + 1, res(host, tag), 3) != 0'),             # the first byte not compared
    ('40a613', '*out = (uint16_t)call1(host, 0x50cb1b, 0, (uintptr_t)buf);', '{ uint32_t x = call1(host, 0x50cb1b, 0, (uintptr_t)buf); memcpy(out, &x, 4); }'),   # a dword store
    ('40a613', '*out = (uint16_t)call1(host, 0x50cb1b, 0, (uintptr_t)buf);', '*out = (uint16_t)(call1(host, 0x50cb1b, 0, (uintptr_t)buf) >> 8);'),
    ('40a613', '    if (memcmp(buf, res(host, tag), 4) != 0) *out = (uint16_t)call1(host, 0x50cb1b, 0, (uintptr_t)buf);\n    return call0(host, 0x4090ab, (uintptr_t)self);',
               '    {\n        uint32_t r = call0(host, 0x4090ab, (uintptr_t)self);\n        if (memcmp(buf, res(host, tag), 4) != 0) *out = (uint16_t)call1(host, 0x50cb1b, 0, (uintptr_t)buf);\n        return r;\n    }'),   # the store after the last call
    ('40a613', 'return call0(host, 0x4090ab, (uintptr_t)self);', 'call0(host, 0x4090ab, (uintptr_t)self);\n    return 0;'),
    ('40a613', '(uintptr_t)self + field', '(uintptr_t)self + field + 1'),
    ('40a613', 'call1(host, 0x50cb1b, 0, (uintptr_t)buf)', 'call1(host, 0x50cb1b, 0, (uintptr_t)buf + 1)'),
    ('40a613', 'return read_tag_word(self, &world->word_5ec2d8, 0xcc, 0x53ec5c, host);', 'return read_tag_word(self, &world->word_5ec2d8, 0xcc, 0x53ec60, host);'),   # the twin's tag
    ('40a665', 'return read_tag_word(self, &world->word_5ec2da, 0x10c, 0x53ec60, host);', 'return read_tag_word(self, &world->word_5ec2d8, 0x10c, 0x53ec60, host);'),   # the twin's word
    ('40a665', 'return read_tag_word(self, &world->word_5ec2da, 0x10c, 0x53ec60, host);', 'return read_tag_word(self, &world->word_5ec2da, 0xcc, 0x53ec60, host);'),    # the twin's field
    ('4a9f27', 'self[0x47] = 0;', 'wr16(self, 0x47, 0);'),      # (a word store at 0x45 would be equivalent: 0x46 is cleared next)
    ('4a9f27', 'return self;', 'return NULL;'),
    ('4b71f7', 'wr16(self, 0x21, 0xffff);\n    wr16(self, 0x2f, 0xffff);', 'wr16(self, 0x21, 0xfffe);\n    wr16(self, 0x2f, 0xffff);'),
    ('4b71f7', 'self[0x3b] = 0;\n', ''),
    ('4781fa', 'wr32(self, 0x157a, 0);', 'wr16(self, 0x157a, 0);'),
    ('4afd3a', 'wr16(self, 0x1c, 0xffff);\n    wr32(self, 0x1515, 0);', 'wr16(self, 0x1c, 0);\n    wr32(self, 0x1515, 0);'),
    ('4e04f3', 'wr32(self, 0xf32, 0xffffffffu);', 'wr32(self, 0xf32, 0);'),
    ('4a638a', 'self[0x8a] = 0;\n', ''),
    ('4a638a', 'wr32(self, 0x86, 0);', 'wr16(self, 0x86, 0);'),
    ('454565', 'return (int32_t)(first - second);', 'return (int32_t)(second - first);'),
    ('454565', '(rd32(b, 0) - rd32(a, 0)) * (rd32(c, 4) - rd32(a, 4))', '(rd32(b, 0) - rd32(a, 0)) * (rd32(b, 4) - rd32(a, 4))'),
    ('454565', '(rd32(c, 0) - rd32(a, 0)) * (rd32(b, 4) - rd32(a, 4))', '(rd32(c, 0) - rd32(b, 0)) * (rd32(b, 4) - rd32(a, 4))'),
    ('454565', 'return (int32_t)(first - second);', 'return (int16_t)(first - second);'),
]


BOTH = '--both' in sys.argv       # also run the Unicorn differential on the mutants that the direct test already caught


def main():
    text = (SRC / 'original_methods_fl32b.c').read_text()
    survived = 0
    diff_survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        start = text.index('/* ---- 0x%s ' % key)
        at = text.find(old, start)
        if at < 0:
            raise SystemExit('stale hand mutant (not inside 0x%s): %r' % (key, old))
        mutated = text[:at] + new + text[at + len(old):]
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl32b.c').write_text(mutated)
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
