#!/usr/bin/env python3
"""FL-38 (batch b) mutation check.  usage (from outputs/blackmoor-decomp): python3 tests/fl38b_mutation_check.py [--direct-only]

Each round applies ONE mutation to src/original_methods_fl38b.c (the four constants of every row wrapper at once, or one place of the shared body that all rows call), rebuilds, runs
tests.test_fl38b_direct and tests.test_fl38b_differential and lists the rows whose direct test or differential test did NOT fail: the survivors. The source file is restored afterwards.
Template: tests/fl36_mutation_check.py (batch f of FL-36).
"""
import json
from pathlib import Path
import re
import subprocess
import sys

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src/original_methods_fl38b.c'

X1 = lambda m: '0x%x' % (int(m, 16) ^ 1)
# constants of a row wrapper: clone_record(out, in2, adv, world, host, SIZE, FMT, MSG, DBG)
ROW = r'(return clone_record\(out, in2, adv, world, host, )(0x[0-9a-f]+), (0x[0-9a-f]+), (0x[0-9a-f]+), (0x[0-9a-f]+)\)'
ROW_MUTANTS = [
    ('row: size ^ 1', lambda m: m.group(1) + X1(m.group(2)) + ', ' + ', '.join(m.group(3, 4, 5)) + ')'),
    ('row: format string ^ 1', lambda m: m.group(1) + m.group(2) + ', ' + X1(m.group(3)) + ', ' + ', '.join(m.group(4, 5)) + ')'),
    ('row: report message ^ 1', lambda m: m.group(1) + ', '.join(m.group(2, 3)) + ', ' + X1(m.group(4)) + ', ' + m.group(5) + ')'),
    ('row: debug message ^ 1', lambda m: m.group(1) + ', '.join(m.group(2, 3, 4)) + ', ' + X1(m.group(5)) + ')'),
]
BODY_MUTANTS = [
    ('allocator callee ^ 1', 'call1(host, 0x51dc43, 0, size)', 'call1(host, 0x51dc42, 0, size)'),
    ('allocator size + 1', 'call1(host, 0x51dc43, 0, size)', 'call1(host, 0x51dc43, 0, size + 1u)'),
    ('allocator this_ptr', 'call1(host, 0x51dc43, 0, size)', 'call1(host, 0x51dc43, 1, size)'),
    ('*out not stored', 'wr32(res(host, out), p);', '(void)out;'),
    ('*out stored as p + 1', 'wr32(res(host, out), p);', 'wr32(res(host, out), p + 1u);'),
    ('null test inverted', 'if (p == 0) {', 'if (p != 0) {'),
    ('sprintf callee ^ 1', 'callv(host, 0x50ca3e, 0, a4, 4)', 'callv(host, 0x50ca3f, 0, a4, 4)'),
    ('sprintf buffer ^ 1', 'a4[0] = 0x63888b;', 'a4[0] = 0x63888a;'),
    ('sprintf args swapped', 'a4[2] = world->dword_5bb57b; a4[3] = (uint32_t)(int32_t)world->word_5c39e3;', 'a4[3] = world->dword_5bb57b; a4[2] = (uint32_t)(int32_t)world->word_5c39e3;'),
    ('sprintf word zero-extended', '(uint32_t)(int32_t)world->word_5c39e3', '(uint16_t)world->word_5c39e3'),
    ('sprintf dword dropped', 'a4[2] = world->dword_5bb57b;', 'a4[2] = 0;'),
    ('sprintf argument count 3', 'callv(host, 0x50ca3e, 0, a4, 4)', 'callv(host, 0x50ca3e, 0, a4, 3)'),
    ('report callee ^ 1', 'callv(host, 0x42639d, 0x583979, a2, 2)', 'callv(host, 0x42639c, 0x583979, a2, 2)'),
    ('report this ^ 1', 'callv(host, 0x42639d, 0x583979, a2, 2)', 'callv(host, 0x42639d, 0x583978, a2, 2)'),
    ('report arguments swapped', 'a2[0] = msg; a2[1] = 0x63888b;', 'a2[1] = msg; a2[0] = 0x63888b;'),
    ('report buffer ^ 1', 'a2[1] = 0x63888b;', 'a2[1] = 0x63888a;'),
    ('fatal callee ^ 1', 'call0(host, 0x4c97b4, 0x5cf659)', 'call0(host, 0x4c97b5, 0x5cf659)'),
    ('fatal this ^ 1', 'call0(host, 0x4c97b4, 0x5cf659)', 'call0(host, 0x4c97b4, 0x5cf658)'),
    ('fatal call dropped', 'call0(host, 0x4c97b4, 0x5cf659);', '(void)call0;'),
    ('stop returns 0', 'return 1;                       /*', 'return 0;                       /*'),
    ('no stop after the fatal call', 'return 1;                       /*', '(void)0;                        /*'),
    ('copy size + 1', 'res(host, rd32(res(host, src))), size);', 'res(host, rd32(res(host, src))), size + 1u);'),
    ('copy size - 1', 'res(host, rd32(res(host, src))), size);', 'res(host, rd32(res(host, src))), size - 1u);'),
    ('copy source from adv', 'res(host, rd32(res(host, src))), size);', 'res(host, rd32(res(host, adv))), size);'),
    ('copy destination from src', 'copy_forward(res(host, rd32(res(host, out))),', 'copy_forward(res(host, rd32(res(host, src))),'),
    ('copy dwords - 1', 'i < size / 4u;', 'i < size / 4u - 1u;'),
    ('copy word tail dropped', '(size & 2u) != 0', '((size & 2u) != 0 && size < 1u)'),
    ('copy byte tail dropped', '(size & 1u) != 0', '((size & 1u) != 0 && size < 1u)'),
    ('copy byte tail wrong', '*dst = *src;', '*dst = (uint8_t)(*src ^ 1u);'),
    ('copy via memmove', 'static void copy_forward(uint8_t *dst, const uint8_t *src, uint32_t size)\n{\n', 'static void copy_forward(uint8_t *dst, const uint8_t *src, uint32_t size)\n{\n    memmove(dst, src, size);\n    return;\n'),
    ('copy dword stride 2', 'src += 4;\n        dst += 4;', 'src += 2;\n        dst += 2;'),
    ('adv not advanced', 'wr32(res(host, adv), rd32(res(host, adv)) + size);', '(void)adv;'),
    ('adv advanced by size + 1', 'wr32(res(host, adv), rd32(res(host, adv)) + size);', 'wr32(res(host, adv), rd32(res(host, adv)) + size + 1u);'),
    ('in2 not advanced', 'wr32(res(host, src), rd32(res(host, src)) + size);', '(void)src;'),
    ('in2 advanced by size - 1', 'wr32(res(host, src), rd32(res(host, src)) + size);', 'wr32(res(host, src), rd32(res(host, src)) + size - 1u);'),
    ('in2 advanced from a stale read', 'wr32(res(host, src), rd32(res(host, src)) + size);', 'wr32(res(host, src), stale_src + size);'),
    ('adv advanced from a stale read', 'wr32(res(host, adv), rd32(res(host, adv)) + size);', 'wr32(res(host, adv), stale_adv + size);'),
    ('debug test on the low byte', 'world->word_63a4cd != 0', '(world->word_63a4cd & 0xff) != 0'),
    ('debug test signed positive', 'world->word_63a4cd != 0', 'world->word_63a4cd > 0'),
    ('debug test inverted', 'world->word_63a4cd != 0', 'world->word_63a4cd == 0'),
    ('debug callee ^ 1', 'call1(host, 0x44a2b7, 0, dbg_msg)', 'call1(host, 0x44a2b6, 0, dbg_msg)'),
    ('debug this_ptr', 'call1(host, 0x44a2b7, 0, dbg_msg)', 'call1(host, 0x44a2b7, 1, dbg_msg)'),
    ('debug call dropped', 'call1(host, 0x44a2b7, 0, dbg_msg);', '(void)dbg_msg;'),
    ('return 1 on success', 'return 0;\n}\n\n/* ----', 'return 1;\n}\n\n/* ----'),
]


def run_tests(direct_only):
    """The ids of the failed tests; a module whose process crashed (the native code ran wild) counts as failed as a whole."""
    failed = set()
    for mod in ['tests.test_fl38b_direct'] + ([] if direct_only else ['tests.test_fl38b_differential']):
        code = ('import unittest,json\nsuite=unittest.defaultTestLoader.loadTestsFromNames(%r)\nres=unittest.TestResult()\nsuite.run(res)\n'
                'print(json.dumps(sorted(set(t.id() for t,_ in res.failures+res.errors))))\n' % [mod])
        done = subprocess.run([sys.executable, '-c', code], capture_output=True, text=True, cwd=PROJECT)
        lines = done.stdout.strip().splitlines()
        if not lines:
            failed.add('CRASH:' + mod)
        else:
            failed.update(json.loads(lines[-1]))
    return failed


def main():
    direct_only = '--direct-only' in sys.argv
    original = SRC.read_text()
    rows = re.findall(r'/\* 0x([0-9a-f]+) m[0-9a-f]+_clone_record \*/', original)
    sizes = {m.group(1): int(m.group(2), 16) for m in re.finditer(r'm([0-9a-f]+)_clone_record\(.*?\n\{\n    return clone_record\(out, in2, adv, world, host, (0x[0-9a-f]+),', original, re.S)}
    total = survivors_total = 0
    rounds = [(label, 'row', fn) for label, fn in ROW_MUTANTS] + [(label, 'body', (old, new)) for label, old, new in BODY_MUTANTS]
    try:
        for label, kind, how in rounds:
            if kind == 'row':
                text, n = re.subn(ROW, how, original)
                assert n == len(rows), (label, n)
            else:
                old, new = how
                if label.endswith('stale read'):                 # the stale values are read at the top of clone_record
                    pass
                assert original.count(old) == 1, (label, original.count(old))
                text = original.replace(old, new)
                if 'stale_' in new:
                    text = text.replace('    const uint32_t p = call1(', '    const uint32_t stale_src = rd32(res(host, src)), stale_adv = rd32(res(host, adv));\n    (void)stale_src; (void)stale_adv;\n    const uint32_t p = call1(', 1)
            SRC.write_text(text)
            failed = run_tests(direct_only)
            if any('setUpClass' in f for f in failed):
                print('%-36s BUILD FAILED, mutation not testable' % label)
                survivors_total += len(rows)
                total += len(rows)
                continue
            survivors = []
            for va in rows:
                if (label.startswith('copy byte tail') and not sizes[va] & 1) or (label.startswith('copy word tail') and not sizes[va] & 2):
                    continue           # the row has no such tail: the mutant is equivalent for it
                direct = 'CRASH:tests.test_fl38b_direct' in failed or any(f.endswith('Fl38bDirect.test_%s_clone_record' % va) for f in failed)
                diff = direct_only or 'CRASH:tests.test_fl38b_differential' in failed or any(f.endswith('Fl38bDifferential.test_%s_clone_record' % va) for f in failed)
                if not (direct and diff):
                    survivors.append((va, 'direct' if not direct else 'differential'))
            total += len(rows)
            survivors_total += len(survivors)
            print('%-36s mutants %3d survivors %d %s' % (label, len(rows), len(survivors), survivors[:4]), flush=True)
    finally:
        SRC.write_text(original)
    print('total mutants %d, survivors %d' % (total, survivors_total))


if __name__ == '__main__':
    main()
