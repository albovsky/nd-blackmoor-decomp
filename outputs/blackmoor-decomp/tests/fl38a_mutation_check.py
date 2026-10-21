#!/usr/bin/env python3
"""FL-38 mutation check for batch a.  usage (from outputs/blackmoor-decomp): python3 tests/fl38a_mutation_check.py [--differential]

Each round applies ONE mutation of one type to EVERY function of the batch at once (the mutations are local to a function body, so the per-function tests tell them apart),
rebuilds, runs tests.test_fl38a_direct (and, with --differential, tests.test_fl38a_differential) and lists the functions whose test did NOT fail: the survivors.
The source file is restored afterwards. Mutation types per kind are listed in MUTANTS below.
"""
import importlib
import json
from pathlib import Path
import re
import subprocess
import sys

PROJECT = Path(__file__).resolve().parents[1]

# kind -> [(label, regex, replacement)] applied inside the body of one function (the text between its signature line and the closing brace)
X1 = lambda m: '%x' % (int(m, 16) ^ 1)
A_OFF = lambda m: 'rd32(self, 0x%x)' % (int(m.group(1), 16) + 4)
MUTANTS = {
    'get': [('constant ^ 1', r'return 0x([0-9a-f]+)u;', lambda m: 'return 0x%su;' % X1(m.group(1)))],
    'guard': [
        ('dword offset + 4', r'rd32\(self, 0x([0-9a-f]+)\) != 0', lambda m: 'rd32(self, 0x%x) != 0' % (int(m.group(1), 16) + 4)),
        ('word offset + 2', r'rd16\(self, 0x([0-9a-f]+)\)', lambda m: 'rd16(self, 0x%x)' % (int(m.group(1), 16) + 2)),
        ('dword guard as 16 bits', r'rd32\(self, (0x[0-9a-f]+)\) != 0', lambda m: '(uint16_t)rd32(self, %s) != 0' % m.group(1)),
        ('dword guard dropped', r'rd32\(self, 0x[0-9a-f]+\) != 0 && ', lambda m: ''),
        ('dword guard negated', r'rd32\(self, (0x[0-9a-f]+)\) != 0', lambda m: 'rd32(self, %s) == 0' % m.group(1)),
        ('word guard dropped', r' && \(int16_t\)rd16\(self, 0x[0-9a-f]+\) != -1', lambda m: ''),
        ('word guard on the unsigned word', r'\(int16_t\)rd16\(self, (0x[0-9a-f]+)\) != -1', lambda m: 'rd16(self, %s) != 0xfffe' % m.group(1)),
        ('index unsigned', r'\(ptrdiff_t\)\(int16_t\)rd16', lambda m: '(ptrdiff_t)(uint16_t)rd16'),
        ('stride 0x4b', r'\* 0x4a, 1\)', lambda m: '* 0x4b, 1)'),
        ('stores 2', r'\* 0x4a, 1\)', lambda m: '* 0x4a, 2)'),
        ('stores a byte', r'wr32\((world->table_5d15a5, [^;]*), 1\);', lambda m: 'world->table_5d15a5[%s] = 1;' % m.group(1).split(', ', 1)[1]),
        ('returns NULL', r'return self;', lambda m: 'return NULL;'),
    ],
    'release': [
        ('dword offset + 4', r'rd32\(self, 0x([0-9a-f]+)\) != 0', lambda m: 'rd32(self, 0x%x) != 0' % (int(m.group(1), 16) + 4)),
        ('word offset + 2', r'rd16\(self, 0x([0-9a-f]+)\)', lambda m: 'rd16(self, 0x%x)' % (int(m.group(1), 16) + 2)),
        ('argument self + A + 4', r'\(uintptr_t\)\(self \+ 0x([0-9a-f]+)\)', lambda m: '(uintptr_t)(self + 0x%x)' % (int(m.group(1), 16) + 4)),
        ('dword guard as 16 bits', r'rd32\(self, (0x[0-9a-f]+)\) != 0', lambda m: '(uint16_t)rd32(self, %s) != 0' % m.group(1)),
        ('dword guard dropped', r'if \(rd32\(self, 0x[0-9a-f]+\) != 0\) ', lambda m: ''),
        ('dword guard negated', r'rd32\(self, (0x[0-9a-f]+)\) != 0', lambda m: 'rd32(self, %s) == 0' % m.group(1)),
        ('word guard dropped', r'if \(\(int16_t\)rd16\(self, 0x[0-9a-f]+\) != -1\) ', lambda m: ''),
        ('word guard negated', r'\(int16_t\)rd16\(self, (0x[0-9a-f]+)\) != -1', lambda m: '(int16_t)rd16(self, %s) == -1' % m.group(1)),
        ('first callee ^ 1', r'call1\(host, 0x4c2dfb,', lambda m: 'call1(host, 0x4c2dfa,'),
        ('first ecx ^ 1', r'0x5cf659,', lambda m: '0x5cf658,'),
        ('second callee ^ 1', r'call1\(host, 0x4d3992,', lambda m: 'call1(host, 0x4d3993,'),
        ('second call this = self', r'call1\(host, 0x4d3992, 0,', lambda m: 'call1(host, 0x4d3992, (uintptr_t)self,'),
        ('tail callee ^ 1', r'call0\(host, 0x([0-9a-f]+),', lambda m: 'call0(host, 0x%s,' % X1(m.group(1))),
        ('tail result discarded', r'return (call0\(.*\));\n', lambda m: '(void)%s;\n    return 0;\n' % m.group(1)),
        ('tail first', r'(    if \(rd32.*?\n    if \(\(int16_t\)[^\n]*\n)(    return call0\(host, 0x[0-9a-f]+, \(uintptr_t\)self\);\n)', lambda m: m.group(2).replace('return ', 'uint32_t t = ') + m.group(1) + '    return t;\n'),
    ],
    'nosound': [
        ('string offset + 1', r'memcmp\(self \+ 0x([0-9a-f]+),', lambda m: 'memcmp(self + 0x%x,' % (int(m.group(1), 16) + 1)),
        ('word offset + 2', r'rd16\(self, 0x([0-9a-f]+)\)', lambda m: 'rd16(self, 0x%x)' % (int(m.group(1), 16) + 2)),
        ('compares 8 bytes', r', k, 9\)', lambda m: ', k, 8)'),
        ('compares 1 byte', r', k, 9\)', lambda m: ', k, 1)'),
        ('last string byte 1', r'0x00\};', lambda m: '0x01};'),
        ('string byte 0 lower case', r'0x4e, 0x4f', lambda m: '0x6e, 0x4f'),
        ('equal test negated', r'== 0\) return 0;', lambda m: '!= 0) return 0;'),
        ('callee ^ 1', r'call1\(host, 0x4fb2e3,', lambda m: 'call1(host, 0x4fb2e2,'),
        ('ecx ^ 1', r'0x5c3a67,', lambda m: '0x5c3a66,'),
        ('equal returns 1', r'== 0\) return 0;', lambda m: '== 0) return 1;'),
        ('different returns 0', r'return call1\((.*)\);', lambda m: '(void)call1(%s);\n    return 0;' % m.group(1)),
    ],
}
MUTANTS['releaseclr'] = [m for m in MUTANTS['release'] if m[0] not in ('dword guard dropped', 'tail first')] + [
    ('dword guard dropped', r'if \(rd32\(self, 0x[0-9a-f]+\) != 0\) \{', lambda m: '{'),
    ('clear dropped', r'        wr32\(self, 0x[0-9a-f]+, 0\);\n', lambda m: ''),
    ('clear at A + 4', r'wr32\(self, 0x([0-9a-f]+), 0\)', lambda m: 'wr32(self, 0x%x, 0)' % (int(m.group(1), 16) + 4)),
    ('clear before the call', r'(        \(void\)call1\(host, 0x4c2dfb, [^\n]*\n)(        wr32\(self, 0x[0-9a-f]+, 0\);\n)', lambda m: m.group(2) + m.group(1)),
    ('clear stores 1', r'wr32\(self, (0x[0-9a-f]+), 0\)', lambda m: 'wr32(self, %s, 1)' % m.group(1)),
]


def function_blocks(text):
    """[(name, start, end)] of the function bodies of the generated source."""
    return [(m.group(1), m.start(), m.end()) for m in re.finditer(r'/\* 0x[0-9a-f]+ (m[0-9a-f]+_\w+) \*/\n[^\n]+\n\{\n.*?\n\}\n', text, re.S)]


def run_tests(batch, differential):
    mods = ['tests.test_fl38%s_direct' % batch] + (['tests.test_fl38%s_differential' % batch] if differential else [])
    code = ('import unittest,json,sys\nsuite=unittest.defaultTestLoader.loadTestsFromNames(%r)\nres=unittest.TestResult()\nsuite.run(res)\n'
            'print(json.dumps(sorted(set(t.id() for t,_ in res.failures+res.errors))))\n' % mods)
    done = subprocess.run([sys.executable, '-c', code], capture_output=True, text=True, cwd=PROJECT)
    lines = done.stdout.strip().splitlines()
    if lines:
        return set(json.loads(lines[-1]))
    # the process died (a mutant that writes through a wild index crashes the shim): every test of the modules counts as failed, i.e. the mutant is caught
    listing = ('import unittest,json\ndef walk(t):\n    for x in t:\n        yield from walk(x) if hasattr(x, "__iter__") else [x.id()]\n'
               'print(json.dumps(sorted(walk(unittest.defaultTestLoader.loadTestsFromNames(%r)))))\n' % mods)
    return set(json.loads(subprocess.run([sys.executable, '-c', listing], capture_output=True, text=True, cwd=PROJECT).stdout.strip().splitlines()[-1]))


def main():
    batch = 'a'
    differential = '--differential' in sys.argv
    src = PROJECT / ('src/original_methods_fl38%s.c' % batch)
    original = src.read_text()
    sys.path.insert(0, str(PROJECT / 'tests'))
    fx = importlib.import_module('fl38%s_fixtures' % batch)
    rows = {'m%x_%s' % (int(k, 16), fx.NAMES[k]): fx.ROWS[k][0] for k in fx.KEYS}
    blocks = function_blocks(original)
    total_mut = total_surv = 0
    try:
        for label in sorted({lab for k in MUTANTS for lab, _, _ in MUTANTS[k]}):
            text, mutated = original, {}
            for name, a, b in reversed(blocks):
                kind = rows[name]
                for lab, rx, fn in MUTANTS[kind]:
                    if lab != label:
                        continue
                    body = text[a:b]
                    new, n = re.subn(rx, fn, body, count=1, flags=re.S)
                    if n and new != body:
                        text = text[:a] + new + text[b:]
                        mutated[name] = kind
            if not mutated:
                continue
            src.write_text(text)
            failed = run_tests(batch, differential)
            if any('setUpClass' in f for f in failed):
                print('%-28s BUILD FAILED, mutation not testable' % label)
                total_surv += len(mutated)
                continue
            survivors = []
            for name in mutated:
                va = re.match(r'm([0-9a-f]+)_(\w+)', name)
                short = 'test_%s_%s' % (va.group(1), va.group(2))
                direct = any(f.endswith('Direct.' + short) for f in failed)
                diff = (not differential) or any(f.endswith('Differential.' + short) for f in failed)
                if not (direct and diff):
                    survivors.append((name, 'direct' if not direct else 'differential'))
            total_mut += len(mutated)
            total_surv += len(survivors)
            print('%-28s mutants %3d survivors %d %s' % (label, len(mutated), len(survivors), survivors[:6]))
    finally:
        src.write_text(original)
    print('total mutants %d, survivors %d' % (total_mut, total_surv))


if __name__ == '__main__':
    main()
