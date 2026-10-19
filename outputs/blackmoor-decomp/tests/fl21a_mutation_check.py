"""FL-21 (batch a) mutation check: deliberately breaks one rule of src/original_methods_fl21a.c at a time and reports whether the direct tests
and the Unicorn differential tests (both of which must pass on the unmodified source) detect it.

Usage: python3 tests/fl21a_mutation_check.py [output.json]. The source file is restored after each mutation (and on any error); nothing
else is touched. Exit status 0 when every mutation is detected by the differential suite (the oracle); mutations the hand-derived direct suite misses are listed.
"""
import json
from pathlib import Path
import subprocess
import sys

PROJECT = Path(__file__).resolve().parents[1]
SOURCE = PROJECT / 'src/original_methods_fl21a.c'

MUTATIONS = [
    ('4cb586: state 1 also accepts a state other than 2 and 3 as pending', '        if (s != 2 && s != 3) {', '        if (s != 2) {'),
    ('4cb586: 0x4cb9d1 is called even when the id is unchanged', 'if (rd32(self, 0x12) != 0 && v != rd32(self, 0x14a)) {', 'if (rd32(self, 0x12) != 0) {'),
    ('4cb586: [self+0x14a] := 0 instead of -1', 'wr32(self, 0x14a, 0xffffffffu);', 'wr32(self, 0x14a, 0);'),
    ('4cb586: the name compare does not stop at the first zero pair', '            if (c19 == 0) break;\n', ''),
    ('4cb586: the state-1 stores come after the 0x4c0c2c call',
     '        wr32(self, 8, 0);\n        wr32(self, 0x12, 0);\n        s = call0(host, 0x4c0c2c, 0x637fcf);\n',
     '        s = call0(host, 0x4c0c2c, 0x637fcf);\n        wr32(self, 8, 0);\n        wr32(self, 0x12, 0);\n'),
    ('4cb586: the string copy drops the terminator', 'size_t n = strlen((const char *)src) + 1;', 'size_t n = strlen((const char *)src);'),
    ('42caa8: the lower edge test uses >= instead of >', 'if (y0 > c4) goto done;', 'if (y0 >= c4) goto done;'),
    ('42caa8: the dword pushed for 0x42cecd loses the leftover upper half', '(world->value_5b4e60 & 0xffff0000u) | (uint16_t)index', '(uint16_t)index'),
    ('42caa8: the clipped bottom adds the cut instead of subtracting it', 'rd32(ent, 0xe) - ((uint32_t)y1 - world->value_5b4e34)', 'rd32(ent, 0xe) + ((uint32_t)y1 - world->value_5b4e34)'),
    ('42caa8: the record words take the high half', 'wr16(rec, 0x47, rd16(ent, 0x16));', 'wr16(rec, 0x47, rd16(ent, 0x18));'),
    ('462c39: the quarter rounds down instead of toward zero', 'uint32_t bias = d < 0 ? 3u : 0u;', 'uint32_t bias = 0u;'),
    ('462c39: the down direction reports the up code', 'call1(host, 0x4630a3, (uintptr_t)self, 0x2782);', 'call1(host, 0x4630a3, (uintptr_t)self, 0x2781);'),
    ('462c39: the row is stored in the column word', 'wr16(self, 0x5b, (uint16_t)r);', 'wr16(self, 0x5b, (uint16_t)c);'),
    ('462c39: the outer box includes its right edge plus one', 'if ((int32_t)x > rds32(rec, 0x34f)) return 0;', 'if ((int32_t)x > rds32(rec, 0x34f) + 1) return 0;'),
    ('462c39: the cell word is not stored in [self+0x39]',
     '            wr16(self, 0x39, rd16(cell, 0x26));\n', '            wr16(self, 0x39, 0);\n'),
    ('484f42: the third rectangle word is copied from the wrong place', 'wr32(self, 0xbb9, rd32(rect, 8));', 'wr32(self, 0xbb9, rd32(rect, 0xc));'),
    ('484f42: the word [rec+0x2b] is not cleared', 'if (rec[0x2a] == 0) wr16((uint8_t *)rec, 0x2b, 0);', ''),
    ('484f42: the box 2 right edge is inclusive', 'sx < rds32(rec, 0x600)', 'sx <= rds32(rec, 0x600)'),
    ('484f42: the second slot test ignores the byte +0x23', 'if (slot[0x23] == 0 && ', 'if ('),
    ('48d914: the v = 0 timer test is strict', 'if (tick_now(host) >= rd32(self, 0x39)) {\n                call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x715u);',
     'if (tick_now(host) > rd32(self, 0x39)) {\n                call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x715u);'),
    ('48d914: the state-0 stores come after the 0x4e8d96 call',
     '        wr32(self, 0x20, 0);\n        world->value_5bb1ca = 1;\n        call0(host, 0x4e8d96, 0x571442);\n',
     '        call0(host, 0x4e8d96, 0x571442);\n        wr32(self, 0x20, 0);\n        world->value_5bb1ca = 1;\n'),
    ('48d914: the wait is 100 ms per unit instead of 1000', '(uint32_t)(rds16(rec, 0x75f) * 1000)', '(uint32_t)(rds16(rec, 0x75f) * 100)'),
    ('48d914: the 0x792 group stores 5 instead of 4 in 0x583999', 'world->value_583999 = 4;\n            }\n            if (rds16(rec, 0x7a8)', 'world->value_583999 = 5;\n            }\n            if (rds16(rec, 0x7a8)'),
    ('48d914: -1 is not the no-store marker', 'if (rds16(rec, 0x7a8) != -1)', 'if (rds16(rec, 0x7a8) != 0)'),
    ('48d914: the nine bytes are compared as eight', 'memcmp(rec + 0x761, world->bytes_54e8d4, 9)', 'memcmp(rec + 0x761, world->bytes_54e8d4, 8)'),
    # the test-gap closure of FL-21 (each of these survived the first test set and is killed by the scripted / targeted cases)
    ('42caa8: an inverted clip: y1 against c12 is strict', 'if (y1 >= c12) goto clipped;', 'if (y1 > c12) goto clipped;'),
    ('484f42: slot0 is taken after the 0x484d87 call', 'call0(host, 0x484d87, (uintptr_t)self);',
     'call0(host, 0x484d87, (uintptr_t)self);\n        slot = self + (ptrdiff_t)(rds16(self, 0xa9e) * 0x85) + 0x28;'),
    ('484f42: the byte [rec+0x2a] is tested by its bit 0', 'if (rec[0x2a] == 0)', 'if ((rec[0x2a] & 1) == 0)'),
    ('484f42: the word [rec+0x2b] of the first compare is read unsigned', 'rd32(rec, e + 0xa3) - (uint32_t)rds16(rec, 0x2b)', 'rd32(rec, e + 0xa3) - (uint32_t)rd16(rec, 0x2b)'),
    ('48d914: v = 4 stores the state into the record `index`, not the record of [self+0x1e]',
     'call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x761u);\n                wr32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0x4d, 2);',
     'call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x761u);\n                wr32(record_of(world->records_5bb5e5, index), 0x4d, 2);'),
    ('48d914: the nine bytes are compared as a string', 'memcmp(rec + 0x761, world->bytes_54e8d4, 9)',
     'strncmp((const char *)(rec + 0x761), (const char *)world->bytes_54e8d4, 9)'),
    ('48d914: the byte [self+0x37] is tested by its bit 0', 'if (self[0x37] != 0) {', 'if ((self[0x37] & 1) != 0) {'),
    ('48d914: the 0x270f check looks at the low byte only', 'if (rds16(rec, 0x792) != 0x270f) {', 'if ((rds16(rec, 0x792) & 0xff) != 0x0f) {'),
]


def run_suite(name):
    done = subprocess.run([sys.executable, '-m', 'unittest', name], cwd=PROJECT, capture_output=True, text=True, timeout=900)
    return done.returncode, done.stderr[-300:]


def main():
    only = [a for a in sys.argv[2:]]   # optional substrings: run only the mutations whose label contains one of them
    original = SOURCE.read_text()
    results = []
    try:
        for label, old, new in MUTATIONS:
            if only and not any(o in label for o in only):
                continue
            if original.count(old) < 1:
                results.append({'mutation': label, 'error': 'pattern not found'})
                continue
            SOURCE.write_text(original.replace(old, new, 1))
            direct, _ = run_suite('tests.test_fl21a_direct')
            diff, _ = run_suite('tests.test_fl21a_differential')
            results.append({'mutation': label, 'direct_detects': direct != 0, 'differential_detects': diff != 0})
    finally:
        SOURCE.write_text(original)
    for r in results:
        print(json.dumps(r))
    if len(sys.argv) > 1:
        Path(sys.argv[1]).write_text(json.dumps(results, indent=1) + '\n')
    ok = all(r.get('differential_detects') for r in results)
    direct_only_missed = [r['mutation'] for r in results if r.get('differential_detects') and not r.get('direct_detects')]
    print('every mutation is detected by the original-x86 differential suite' if ok else 'SOME MUTATIONS ESCAPED THE DIFFERENTIAL SUITE')
    print('not detected by the direct (hand-derived) suite: %d' % len(direct_only_missed))
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
