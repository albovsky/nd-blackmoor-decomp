#!/usr/bin/env python3
"""FL-34 (batch a): hand-written mutants (shapes the mechanical tests/fl34a_mutation_check.py does not model: a sign or width change of a compare or of the index, a swapped order of two effects,
a wrong argument, and, for every one of the 21 rows, the table base of the neighbouring row). Each is applied to a scratch copy of src/original_methods_fl34a.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives.

Run from outputs/blackmoor-decomp:  python3 tests/fl34a_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl34a_direct as direct
import fl34a_mutation_check as mc
import fl34a_fixtures as fx

SRC = HERE.parent / 'src'
CMP = 'if (rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta) == 1)'
ST0 = 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta, 0);'
ST1 = 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta, 1);'
FIRST = fx.KEYS[0]
HAND = [
    # the shared body (checked through the first row; every row runs it)
    (FIRST, CMP, 'if (rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta) != 0)'),
    (FIRST, CMP, 'if ((uint16_t)rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta) == 1)'),
    (FIRST, CMP, 'if (rd32(table, (ptrdiff_t)(uint16_t)rd32(self, 0x5c) * 4 + delta) == 1)'),
    (FIRST, CMP, 'if (rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta) & 1)'),
    (FIRST, ST0, 'wr32(table, (ptrdiff_t)(uint16_t)rd32(self, 0x5c) * 4 + delta, 0);'),
    (FIRST, ST1, 'wr32(table, (ptrdiff_t)(uint16_t)rd32(self, 0x5c) * 4 + delta, 1);'),
    (FIRST, ST1, 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta, 2);'),
    (FIRST, ST0, 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta, 0xffffffffu);'),
    (FIRST, ST0, 'wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta + 4, 0);'),
    (FIRST, '* 4 + delta) == 1)', '* 2 + delta) == 1)'),
    (FIRST, '    toggle_dword(self, world->table_5e60da, 0x5e60d6 - 0x5e60da);\n    call0(host, 0x40236a, (uintptr_t)self);',
     '    call0(host, 0x40236a, (uintptr_t)self);\n    toggle_dword(self, world->table_5e60da, 0x5e60d6 - 0x5e60da);'),
    ('402a7e', 'call0(host, 0x40236a, (uintptr_t)self);\n}\n\n/* ---- 0x402ac5', 'call0(host, 0x40236a, 0);\n}\n\n/* ---- 0x402ac5'),
    ('402fc3', 'call0(host, 0x40236a, (uintptr_t)self);\n}\n\n/* FNS-END', 'call0(host, 0x40236a, (uintptr_t)(self + 1));\n}\n\n/* FNS-END'),
    ('402a7e', 'call0(host, 0x40236a, (uintptr_t)self);\n}\n\n/* ---- 0x402ac5', 'call0(host, 0x404be1, (uintptr_t)self);\n}\n\n/* ---- 0x402ac5'),
]
# every row: the table base of the next row (the last row: the previous one) in place of its own
for i, (k, spec) in enumerate(fx.SPECS.items()):
    mine = 'toggle_dword(self, world->table_5e60da, 0x%x - 0x5e60da);' % fx.BASES[k]
    other = fx.BASES[list(fx.SPECS)[i + 1 if i + 1 < len(fx.SPECS) else i - 1]]
    HAND.append((k, '    ' + mine, '    toggle_dword(self, world->table_5e60da, 0x%x - 0x5e60da);' % other))


def main():
    text = (SRC / 'original_methods_fl34a.c').read_text()
    survived = 0
    for key, old, new in HAND:
        # a replacement is applied inside the function of `key`: from its marker to the next marker (the helper is checked through the first row)
        if key == FIRST and 'delta' in old:
            lo, hi = 0, len(text)
        else:
            lo = text.rindex('/* ---- 0x%s ' % key)
            nxt = text.find('/* ---- 0x', lo + 5)
            hi = nxt + 20 if nxt >= 0 else len(text)       # the next marker's own text is included, so that an edit may end at it
        if text.count(old, lo, hi) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        at = text.index(old, lo, hi)
        mutated = text[:at] + new + text[at + len(old):]
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl34a.c').write_text(mutated)
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
