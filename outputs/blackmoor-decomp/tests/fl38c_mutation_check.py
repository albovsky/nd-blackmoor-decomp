#!/usr/bin/env python3
"""FL-38 (batch c) mutation check.  usage (from outputs/blackmoor-decomp): python3 tests/fl38c_mutation_check.py [--direct-only]

Each round applies ONE mutation to src/original_methods_fl38c.c (one constant of every row wrapper of a shape at once, or one place of a shared body that the rows of the shape call), rebuilds,
runs tests.test_fl38c_direct and tests.test_fl38c_differential and lists the rows whose direct test or differential test did NOT fail: the survivors. The source file is restored afterwards.
Template: tests/fl38b_mutation_check.py (batch b of FL-38) and tests/fl36_mutation_check.py.
"""
import json
from pathlib import Path
import re
import subprocess
import sys

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src/original_methods_fl38c.c'

X1 = lambda m: '0x%x' % (int(m, 16) ^ 1)
H = '(0x[0-9a-f]+)'
# row wrappers: (shape, regex of the wrapper body whose groups are the constants, [(label, group number to change, how)])
WORD_FIELDS = ['word_5e5684', 'word_5e5686', 'word_5ec284', 'word_5ec286', 'word_5ec288', 'word_5ec2d4', 'word_5ec33a']
NEXT_FIELD = {a: b for a, b in zip(WORD_FIELDS, WORD_FIELDS[1:] + WORD_FIELDS[:1])}
ROW_MUTANTS = [
    ('read_word_setting', r'(return read_word_setting\(self, host, )' + H + r'(, &world->)(word_[0-9a-f]+)(, )' + H + r'(\);)',
     [('row: string offset ^ 1', 2, X1), ('row: target word -> the next one', 4, lambda m: NEXT_FIELD[m]), ('row: final method ^ 1', 6, X1)]),
    ('read_time_setting', r'(return read_time_setting\(self, world, host, )' + H + ', ' + H + ', ' + H + r'(\);)',
     [('row: string offset ^ 1', 2, X1), ('row: table base 0 <-> 0x14', 3, lambda m: '0x14' if int(m, 16) == 0 else '0x0'),
      ('row: stored field 4 -> 8 -> 0xc -> 4', 4, lambda m: {'0x4': '0x8', '0x8': '0xc', '0xc': '0x4'}[m])]),
    ('new_zeroed', r'(new_zeroed\(out, size, world, host, )' + H + r'(\);)', [('row: format string ^ 1', 2, X1)]),
    ('clamp_to_bounds', r'(clamp_to_bounds\(self, world, )' + H + ', ' + H + ', ' + H + ', ' + H + ', ' + H + ', ' + H + r'(\);)',
     [('row: field A ^ 1', 2, X1), ('row: field B ^ 1', 3, X1), ('row: extent 1 ^ 1', 4, X1), ('row: field C ^ 1', 5, X1), ('row: field D ^ 1', 6, X1), ('row: extent 2 ^ 1', 7, X1)]),
]
# (label, shape, old, new): old occurs exactly once in the file
BODY_MUTANTS = [
    ('read: callee 0x51d5b2 ^ 1', 'read', 'callv(host, 0x51d5b2,', 'callv(host, 0x51d5b3,'),
    ('read: this of 0x51d5b2 = self', 'read', 'callv(host, 0x51d5b2, (uintptr_t)(self + off), two, 2);', 'callv(host, 0x51d5b2, (uintptr_t)self, two, 2); (void)off;'),
    ('read: this of 0x51d5b2 off by 4', 'read', '(uintptr_t)(self + off), two, 2)', '(uintptr_t)(self + off + 4), two, 2)'),
    ('read: count 0x13 -> 0x12', 'read', 'two[1] = 0x13;', 'two[1] = 0x12;'),
    ('read: arguments of 0x51d5b2 swapped', 'read', 'two[0] = (uintptr_t)text;', 'two[1] = (uintptr_t)text; two[0] = 0x13;'),
    ('read: 0x51d5b2 argument count 1', 'read', 'two, 2);\n    one[0] = (uintptr_t)text;', 'two, 1);\n    one[0] = (uintptr_t)text;'),
    ('read: callee 0x50cb1b ^ 1', 'read', 'callv(host, 0x50cb1b,', 'callv(host, 0x50cb1a,'),
    ('read: 0x50cb1b given a different buffer', 'read', 'one[0] = (uintptr_t)text;', 'one[0] = (uintptr_t)text + 1;'),
    ('read: this of 0x50cb1b', 'read', 'callv(host, 0x50cb1b, 0,', 'callv(host, 0x50cb1b, 1,'),
    ('read: conversion result dropped', 'read', 'return callv(host, 0x50cb1b, 0, one, 1);', '(void)callv(host, 0x50cb1b, 0, one, 1);\n    return 0;'),
    ('read: 0x50cb1b not called', 'read', 'return callv(host, 0x50cb1b, 0, one, 1);', 'return 5;'),
    ('read: last call this = NULL', 'read', 'return callv(host, callee, (uintptr_t)self, NULL, 0);', '(void)self; return callv(host, callee, 0, NULL, 0);'),
    ('read: last call dropped', 'read', 'return callv(host, callee, (uintptr_t)self, NULL, 0);', '(void)self; (void)host; (void)callee; return 0;'),
    ('read: last call result masked', 'read', 'return callv(host, callee, (uintptr_t)self, NULL, 0);', 'return callv(host, callee, (uintptr_t)self, NULL, 0) & 0xffff;'),
    ('word: stored as the high word', 'word', '*target = (uint16_t)read_and_convert(self, host, off);', '*target = (uint16_t)(read_and_convert(self, host, off) >> 16);'),
    ('word: stored + 1', 'word', '*target = (uint16_t)read_and_convert(self, host, off);', '*target = (uint16_t)(read_and_convert(self, host, off) + 1u);'),
    ('word: store dropped', 'word', '*target = (uint16_t)read_and_convert(self, host, off);', '(void)read_and_convert(self, host, off); (void)target;'),
    ('word: stored after the last call', 'word', '*target = (uint16_t)read_and_convert(self, host, off);\n    return call_on_self(self, host, callee);',
     'const uint32_t v = read_and_convert(self, host, off);\n    const uint32_t r = call_on_self(self, host, callee);\n    *target = (uint16_t)v;\n    return r;'),
    ('time: index scale 0x106 -> 0x105', 'time', 'world->dword_5c3a63 * 0x106u', 'world->dword_5c3a63 * 0x105u'),
    ('time: index offset unsigned', 'time', 'world->table_5e569e + (int32_t)(world->dword_5c3a63 * 0x106u)', 'world->table_5e569e + (uint32_t)(world->dword_5c3a63 * 0x106u)'),
    ('time: index ignored', 'time', 'world->table_5e569e + (int32_t)(world->dword_5c3a63 * 0x106u)', 'world->table_5e569e'),
    ('time: converted value not stored', 'time', 'wr32(entry(world) + base + store, read_and_convert(self, host, off));', '(void)read_and_convert(self, host, off); (void)store;'),
    ('time: converted value stored at +0', 'time', 'wr32(entry(world) + base + store, read_and_convert(self, host, off));', 'wr32(entry(world) + base, read_and_convert(self, host, off)); (void)store;'),
    ('time: converted value stored at +0x10', 'time', 'wr32(entry(world) + base + store, read_and_convert(self, host, off));', 'wr32(entry(world) + base + 0x10, read_and_convert(self, host, off)); (void)store;'),
    ('time: hours multiplier', 'time', '* 0x36ee80u', '* 0x36ee81u'),
    ('time: minutes multiplier', 'time', '* 0xea60u', '* 0xea61u'),
    ('time: seconds multiplier', 'time', '* 0x3e8u', '* 0x3e9u'),
    ('time: hours from +8', 'time', 'rd32(entry(world) + base + 0xc) * 0x36ee80u', 'rd32(entry(world) + base + 8) * 0x36ee80u'),
    ('time: minutes from +4', 'time', 'rd32(entry(world) + base + 8) * 0xea60u', 'rd32(entry(world) + base + 4) * 0xea60u'),
    ('time: seconds from +8', 'time', 'rd32(entry(world) + base + 4) * 0x3e8u', 'rd32(entry(world) + base + 8) * 0x3e8u'),
    ('time: hours and minutes swapped', 'time', 'rd32(entry(world) + base + 0xc) * 0x36ee80u;\n    minutes = rd32(entry(world) + base + 8) * 0xea60u;',
     'rd32(entry(world) + base + 8) * 0x36ee80u;\n    minutes = rd32(entry(world) + base + 0xc) * 0xea60u;'),
    ('time: sum with xor', 'time', 'hours + minutes + seconds', 'hours ^ minutes ^ seconds'),
    ('time: seconds dropped', 'time', 'hours + minutes + seconds', 'hours + minutes + (seconds & 0)'),
    ('time: sum stored at +4', 'time', 'wr32(entry(world) + base, hours + minutes + seconds);', 'wr32(entry(world) + base + 4, hours + minutes + seconds);'),
    ('time: sum stored at base + 0x14', 'time', 'wr32(entry(world) + base, hours + minutes + seconds);', 'wr32(entry(world) + base + 0x14, hours + minutes + seconds);'),
    ('time: last call before the stores', 'time', 'wr32(entry(world) + base, hours + minutes + seconds);\n    return call_on_self(self, host, 0x4033db);', 'const uint32_t sum = hours + minutes + seconds;\n    const uint32_t r = call_on_self(self, host, 0x4033db);\n    wr32(entry(world) + base, sum);\n    return r;'),
    ('time: callee 0x4033db ^ 1', 'time', 'call_on_self(self, host, 0x4033db)', 'call_on_self(self, host, 0x4033da)'),
    ('time: last call dropped', 'time', 'return call_on_self(self, host, 0x4033db);', 'return 0;'),
    ('shift: y shift of +4 from the x global', 'rect', 'wr32(dst + 4, rd32(src + 4) + (uint32_t)world->dword_58318a);', 'wr32(dst + 4, rd32(src + 4) + (uint32_t)world->dword_583186);'),
    ('shift: y shift of +0xc from the x global', 'rect', 'wr32(dst + 0xc, rd32(src + 0xc) + (uint32_t)world->dword_58318a);', 'wr32(dst + 0xc, rd32(src + 0xc) + (uint32_t)world->dword_583186);'),
    ('shift: x shift of +0 from the y global', 'rect', 'wr32(dst, rd32(src) + (uint32_t)world->dword_583186);', 'wr32(dst, rd32(src) + (uint32_t)world->dword_58318a);'),
    ('shift: x shift of +8 from the y global', 'rect', 'wr32(dst + 8, rd32(src + 8) + (uint32_t)world->dword_583186);', 'wr32(dst + 8, rd32(src + 8) + (uint32_t)world->dword_58318a);'),
    ('shift: +4 copied from +0xc', 'rect', 'wr32(dst + 4, rd32(src + 4)', 'wr32(dst + 4, rd32(src + 0xc)'),
    ('shift: +0xc stored at +8', 'rect', 'wr32(dst + 0xc, rd32(src + 0xc)', 'wr32(dst + 8, rd32(src + 0xc)'),
    ('shift: +0 stored at +4', 'rect', 'wr32(dst, rd32(src) +', 'wr32(dst + 4, rd32(src) +'),
    ('shift: +8 read from +0', 'rect', 'wr32(dst + 8, rd32(src + 8)', 'wr32(dst + 8, rd32(src)'),
    ('shift: shift subtracted', 'rect', 'wr32(dst + 8, rd32(src + 8) + (uint32_t)world->dword_583186);', 'wr32(dst + 8, rd32(src + 8) - (uint32_t)world->dword_583186);'),
    ('shift: +4 not shifted', 'rect', 'wr32(dst + 4, rd32(src + 4) + (uint32_t)world->dword_58318a);', 'wr32(dst + 4, rd32(src + 4));'),
    ('shift: x pair stored before the y pair', 'rect', 'wr32(dst + 4, rd32(src + 4) + (uint32_t)world->dword_58318a);\n    wr32(dst + 0xc, rd32(src + 0xc) + (uint32_t)world->dword_58318a);\n    wr32(dst, rd32(src) + (uint32_t)world->dword_583186);\n    wr32(dst + 8, rd32(src + 8) + (uint32_t)world->dword_583186);',
     'wr32(dst, rd32(src) + (uint32_t)world->dword_583186);\n    wr32(dst + 8, rd32(src + 8) + (uint32_t)world->dword_583186);\n    wr32(dst + 4, rd32(src + 4) + (uint32_t)world->dword_58318a);\n    wr32(dst + 0xc, rd32(src + 0xc) + (uint32_t)world->dword_58318a);'),
    ('shift: sources read before any store', 'rect', 'static void shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)\n{\n',
     'static void shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)\n{\n    uint8_t copy[16];\n    memcpy(copy, src, 16);\n    src = copy;\n'),
    ('new: allocator callee ^ 1', 'new', 'callv(host, 0x51dc43,', 'callv(host, 0x51dc42,'),
    ('new: allocator size + 1', 'new', 'one[0] = size;\n    p =', 'one[0] = size + 1u;\n    p ='),
    ('new: allocator this', 'new', 'callv(host, 0x51dc43, 0,', 'callv(host, 0x51dc43, 1,'),
    ('new: *out not stored', 'new', 'wr32(res(host, out), p);', '(void)out;'),
    ('new: *out stored as p + 1', 'new', 'wr32(res(host, out), p);', 'wr32(res(host, out), p + 1u);'),
    ('new: null test inverted', 'new', 'if (p == 0) {', 'if (p != 0) {'),
    ('new: sprintf callee ^ 1', 'new', 'callv(host, 0x50ca3e,', 'callv(host, 0x50ca3f,'),
    ('new: sprintf buffer ^ 1', 'new', 'two[0] = 0x63888b;', 'two[0] = 0x63888a;'),
    ('new: sprintf arguments swapped', 'new', 'two[0] = 0x63888b;\n        two[1] = fmt;', 'two[1] = 0x63888b;\n        two[0] = fmt;'),
    ('new: sprintf argument count 1', 'new', 'callv(host, 0x50ca3e, 0, two, 2);', 'callv(host, 0x50ca3e, 0, two, 1);'),
    ('new: report callee ^ 1', 'new', 'callv(host, 0x4264e8,', 'callv(host, 0x4264e9,'),
    ('new: report this ^ 1', 'new', 'callv(host, 0x4264e8, 0x583979,', 'callv(host, 0x4264e8, 0x583978,'),
    ('new: report buffer ^ 1', 'new', 'one[0] = 0x63888b;\n        callv(host, 0x4264e8', 'one[0] = 0x63888a;\n        callv(host, 0x4264e8'),
    ('new: debug test inverted', 'new', 'world->word_63a4cd != 0', 'world->word_63a4cd == 0'),
    ('new: debug test on the low byte', 'new', 'world->word_63a4cd != 0', '(world->word_63a4cd & 0xff) != 0'),
    ('new: debug test signed positive', 'new', 'world->word_63a4cd != 0', 'world->word_63a4cd > 0'),
    ('new: debug callee ^ 1', 'new', 'callv(host, 0x44a2b7,', 'callv(host, 0x44a2b6,'),
    ('new: debug this', 'new', 'callv(host, 0x44a2b7, 0,', 'callv(host, 0x44a2b7, 1,'),
    ('new: debug message ^ 1', 'new', 'if (world->word_63a4cd != 0) callv(host, 0x44a2b7, 0, one, 1);', 'if (world->word_63a4cd != 0) { one[0] = 0x63888a; callv(host, 0x44a2b7, 0, one, 1); }'),
    ('new: debug call dropped', 'new', 'if (world->word_63a4cd != 0) callv(host, 0x44a2b7, 0, one, 1);', '(void)world;'),
    ('new: fatal callee ^ 1', 'new', 'callv(host, 0x4c97b4,', 'callv(host, 0x4c97b5,'),
    ('new: fatal this ^ 1', 'new', 'callv(host, 0x4c97b4, 0x5cf659,', 'callv(host, 0x4c97b4, 0x5cf658,'),
    ('new: fatal call dropped', 'new', 'callv(host, 0x4c97b4, 0x5cf659, NULL, 0);', '(void)0;'),
    ('new: no return after the failure report (zeroing at 0)', 'new', 'callv(host, 0x4c97b4, 0x5cf659, NULL, 0);\n        return;', 'callv(host, 0x4c97b4, 0x5cf659, NULL, 0);'),
    ('new: zero size - 1', 'new', 'memset(res(host, p), 0, size);', 'memset(res(host, p), 0, size > 0 ? size - 1u : 0);'),
    ('new: zero size + 1', 'new', 'memset(res(host, p), 0, size);', 'memset(res(host, p), 0, size + 1u);'),
    ('new: zero value 0xff', 'new', 'memset(res(host, p), 0, size);', 'memset(res(host, p), 0xff, size);'),
    ('new: zero only whole dwords', 'new', 'memset(res(host, p), 0, size);', 'memset(res(host, p), 0, size & ~3u);'),
    ('new: zero the cell instead of the block', 'new', 'memset(res(host, p), 0, size);', 'memset(res(host, out), 0, size);'),
    ('new: zero starts one byte late', 'new', 'memset(res(host, p), 0, size);', 'memset(res(host, p) + 1, 0, size);'),
    ('clamp: minimum test <=', 'clamp', '(int32_t)rd32(self + lo_field) < lo', '(int32_t)rd32(self + lo_field) <= lo'),
    ('clamp: minimum test unsigned', 'clamp', '(int32_t)rd32(self + lo_field) < lo', 'rd32(self + lo_field) < (uint32_t)lo'),
    ('clamp: maximum test >=', 'clamp', '(int32_t)rd32(self + hi_field) > hi', '(int32_t)rd32(self + hi_field) >= hi'),
    ('clamp: maximum test unsigned', 'clamp', '(int32_t)rd32(self + hi_field) > hi', 'rd32(self + hi_field) > (uint32_t)hi'),
    ('clamp: minimum clamp stores hi', 'clamp', 'wr32(self + lo_field, (uint32_t)lo);', 'wr32(self + lo_field, (uint32_t)hi);'),
    ('clamp: maximum clamp stores lo', 'clamp', 'wr32(self + hi_field, (uint32_t)hi);', 'wr32(self + hi_field, (uint32_t)lo);'),
    ('clamp: minimum clamp moves the maximum by - extent', 'clamp', 'wr32(self + hi_field, rd32(self + lo_field) + (uint32_t)rds16(self + extent));', 'wr32(self + hi_field, rd32(self + lo_field) - (uint32_t)rds16(self + extent));'),
    ('clamp: maximum clamp moves the minimum by + extent', 'clamp', 'wr32(self + lo_field, rd32(self + hi_field) - (uint32_t)rds16(self + extent));', 'wr32(self + lo_field, rd32(self + hi_field) + (uint32_t)rds16(self + extent));'),
    ('clamp: minimum clamp does not move the maximum', 'clamp', '        wr32(self + hi_field, rd32(self + lo_field) + (uint32_t)rds16(self + extent));\n', ''),
    ('clamp: maximum clamp does not move the minimum', 'clamp', '        wr32(self + lo_field, rd32(self + hi_field) - (uint32_t)rds16(self + extent));\n', ''),
    ('clamp: extent unsigned', 'clamp', 'static int32_t rds16(const uint8_t *p)\n{\n    int16_t v;', 'static int32_t rds16(const uint8_t *p)\n{\n    uint16_t v;'),
    ('clamp: extent read 2 bytes later', 'clamp', 'static int32_t rds16(const uint8_t *p)\n{\n    int16_t v;\n    memcpy(&v, p, sizeof v);', 'static int32_t rds16(const uint8_t *p)\n{\n    int16_t v;\n    memcpy(&v, p + 2, sizeof v);'),
    ('clamp: maximum clamp skipped when lo > hi', 'clamp', '    if ((int32_t)rd32(self + hi_field) > hi) {', '    if ((int32_t)rd32(self + hi_field) > hi && lo <= hi) {'),
    ('clamp: x bounds swapped', 'clamp', 'clamp_axis(self, world->dword_58319a, world->dword_5831a2, a, b, w1);', 'clamp_axis(self, world->dword_5831a2, world->dword_58319a, a, b, w1);'),
    ('clamp: x minimum from the y bound', 'clamp', 'clamp_axis(self, world->dword_58319a, world->dword_5831a2, a, b, w1);', 'clamp_axis(self, world->dword_583196, world->dword_5831a2, a, b, w1);'),
    ('clamp: x maximum from the y bound', 'clamp', 'clamp_axis(self, world->dword_58319a, world->dword_5831a2, a, b, w1);', 'clamp_axis(self, world->dword_58319a, world->dword_58319e, a, b, w1);'),
    ('clamp: y bounds swapped', 'clamp', 'clamp_axis(self, world->dword_583196, world->dword_58319e, c, d, w2);', 'clamp_axis(self, world->dword_58319e, world->dword_583196, c, d, w2);'),
    ('clamp: y minimum from the x bound', 'clamp', 'clamp_axis(self, world->dword_583196, world->dword_58319e, c, d, w2);', 'clamp_axis(self, world->dword_58319a, world->dword_58319e, c, d, w2);'),
    ('clamp: y maximum from the x bound', 'clamp', 'clamp_axis(self, world->dword_583196, world->dword_58319e, c, d, w2);', 'clamp_axis(self, world->dword_583196, world->dword_5831a2, c, d, w2);'),
    ('clamp: y axis uses the x extent', 'clamp', 'clamp_axis(self, world->dword_583196, world->dword_58319e, c, d, w2);', 'clamp_axis(self, world->dword_583196, world->dword_58319e, c, d, w1); (void)w2;'),
    ('clamp: x axis uses the y extent', 'clamp', 'clamp_axis(self, world->dword_58319a, world->dword_5831a2, a, b, w1);', 'clamp_axis(self, world->dword_58319a, world->dword_5831a2, a, b, w2); (void)w1;'),
    ('clamp: y axis dropped', 'clamp', '    clamp_axis(self, world->dword_583196, world->dword_58319e, c, d, w2);\n', '    (void)c; (void)d; (void)w2;\n'),
    ('clamp: x axis dropped', 'clamp', '    clamp_axis(self, world->dword_58319a, world->dword_5831a2, a, b, w1);\n', '    (void)a; (void)b; (void)w1;\n'),
]
SHAPES = {'read': ('read_word_setting', 'read_time_setting'), 'word': ('read_word_setting',), 'time': ('read_time_setting',), 'rect': ('shift_rect',), 'new': ('new_zeroed',), 'clamp': ('clamp_to_bounds',)}


def run_tests(direct_only):
    """The ids of the failed tests; a module whose process crashed (the native code ran wild) counts as failed as a whole."""
    failed = set()
    for mod in ['tests.test_fl38c_direct'] + ([] if direct_only else ['tests.test_fl38c_differential']):
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
    rows = re.findall(r'/\* 0x([0-9a-f]+) (m[0-9a-f]+_(\w+)) \*/', original)
    by_shape = {}
    for va, _, shape in rows:
        by_shape.setdefault(shape, []).append(va)
    rounds = []
    for shape, pattern, mutants in ROW_MUTANTS:
        for label, group, how in mutants:
            rounds.append((label, shape, 'row', (pattern, group, how)))
    for label, kind, old, new in BODY_MUTANTS:
        for shape in SHAPES[kind]:
            rounds.append((label, shape, 'body', (old, new)))
    # a body mutant of a helper shared by two shapes is one round on both shapes: merge them by label
    merged = {}
    for label, shape, kind, how in rounds:
        merged.setdefault((label, kind, repr(how)), (label, kind, how, []))[3].append(shape)
    total = survivors_total = 0
    try:
        for label, kind, how, shapes in merged.values():
            rows_here = [va for s in shapes for va in by_shape[s]]
            if kind == 'row':
                pattern, group, fn = how
                count = [0]

                def sub(m, group=group, fn=fn):
                    count[0] += 1
                    return rebuild(m, group, fn)
                text = re.sub(pattern, sub, original)
                assert count[0] == len(rows_here), (label, count[0], len(rows_here))
            else:
                old, new = how
                assert original.count(old) == 1, (label, original.count(old))
                text = original.replace(old, new)
            SRC.write_text(text)
            failed = run_tests(direct_only)
            if any('setUpClass' in f for f in failed):
                print('%-52s BUILD FAILED, mutation not testable' % label)
                survivors_total += len(rows_here)
                total += len(rows_here)
                continue
            survivors = []
            for va in rows_here:
                name = next(n for v, _, n in rows if v == va)
                direct = 'CRASH:tests.test_fl38c_direct' in failed or any(f.endswith('Fl38cDirect.test_%s_%s' % (va, name)) for f in failed)
                diff = direct_only or 'CRASH:tests.test_fl38c_differential' in failed or any(f.endswith('Fl38cDifferential.test_%s_%s' % (va, name)) for f in failed)
                if not (direct and diff):
                    survivors.append((va, 'direct' if not direct else 'differential'))
            total += len(rows_here)
            survivors_total += len(survivors)
            print('%-52s mutants %3d survivors %d %s' % (label, len(rows_here), len(survivors), survivors[:4]), flush=True)
    finally:
        SRC.write_text(original)
    print('total mutants %d, survivors %d' % (total, survivors_total))


def rebuild(m, group, fn):
    """The text of the match `m` with its group number `group` replaced by fn(group)."""
    out, pos = [], m.start()
    for i in range(1, m.lastindex + 1):
        out.append(m.string[pos:m.start(i)])
        out.append(fn(m.group(i)) if i == group else m.group(i))
        pos = m.end(i)
    out.append(m.string[pos:m.end()])
    return ''.join(out)


if __name__ == '__main__':
    main()
