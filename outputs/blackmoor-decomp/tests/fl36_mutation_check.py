#!/usr/bin/env python3
"""FL-36 mutation check for the tiny-family batches (b, c, d).  usage (from outputs/blackmoor-decomp): python3 tests/fl36_mutation_check.py <batch letter> [--differential]

Each round applies ONE mutation of one type to EVERY function of the batch at once (the mutations are local to a function body, so the per-function tests tell them apart),
rebuilds, runs tests.test_fl36<x>_direct (and, with --differential, tests.test_fl36<x>_differential) and lists the functions whose test did NOT fail: the survivors.
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
MUTANTS = {
    'get': [('constant ^ 1', r'return 0x([0-9a-f]+)u;', lambda m: 'return 0x%xu;' % (int(m.group(1), 16) ^ 1))],
    'empty': [('writes self[0]', r'\(void\)self;|^$', None)],
    'ctor': [
        ('vtable dword ^ 1', r'wr32\(self, 0, 0x([0-9a-f]+)u\)', lambda m: 'wr32(self, 0, 0x%xu)' % (int(m.group(1), 16) ^ 1)),
        ('callee ^ 1', r'call0\(host, 0x([0-9a-f]+),', lambda m: 'call0(host, 0x%x,' % (int(m.group(1), 16) ^ 1)),
        ('store at [this + 4]', r'wr32\(self, 0,', lambda m: 'wr32(self, 4,'),
        ('result discarded', r'return (call0\(.*\));\n', lambda m: '(void)%s;\n    return 0;\n' % m.group(1)),
    ],
    'ctorret': [
        ('vtable dword ^ 1', r'wr32\(self, 0, 0x([0-9a-f]+)u\)', lambda m: 'wr32(self, 0, 0x%xu)' % (int(m.group(1), 16) ^ 1)),
        ('callee ^ 1', r'call0\(host, 0x([0-9a-f]+),', lambda m: 'call0(host, 0x%x,' % (int(m.group(1), 16) ^ 1)),
        ('returns NULL', r'return self;', lambda m: 'return NULL;'),
        ('store at [this + 4]', r'wr32\(self, 0,', lambda m: 'wr32(self, 4,'),
    ],
    'setg': [
        ('constant ^ 1', r'= 0x([0-9a-f]+)u;\n    return call0', lambda m: '= 0x%xu;\n    return call0' % (int(m.group(1), 16) ^ 1)),
        ('callee ^ 1', r'call0\(host, 0x([0-9a-f]+),', lambda m: 'call0(host, 0x%x,' % (int(m.group(1), 16) ^ 1)),
        ('store after the call', r'(    world->dword_[0-9a-f]+ = 0x[0-9a-f]+u;\n)(    return call0\(host, 0x[0-9a-f]+, \(uintptr_t\)self\);\n)', lambda m: '    { uint32_t r = call0(host, 0x1, 0); (void)r; }\n' + m.group(2).replace('return ', 'return ') + 'XX'),
    ],
    'dtor': [
        ('flag bit 1 instead of 0', r'flags & 1u', lambda m: 'flags & 2u'),
        ('callee ^ 1', r'\(void\)call0\(host, 0x([0-9a-f]+),', lambda m: '(void)call0(host, 0x%x,' % (int(m.group(1), 16) ^ 1)),
        ('delete with this_ptr = self', r'call1\(host, 0x51dc6c, 0,', lambda m: 'call1(host, 0x51dc6c, (uintptr_t)self,'),
        ('delete always', r'if \(\(flags & 1u\) != 0\) ', lambda m: '(void)flags; '),
        ('returns NULL', r'return self;', lambda m: 'return NULL;'),
    ],
}
MUTANTS['empty'] = [('writes self[0]', r'\(void\)self;', lambda m: 'self[0] ^= 1;')]
MUTANTS['setg'] = MUTANTS['setg'][:2] + [('no store', r'    world->dword_[0-9a-f]+ = 0x[0-9a-f]+u;\n', lambda m: '    (void)world;\n')]


def function_blocks(text):
    """[(name, start, end)] of the function bodies of the generated source."""
    return [(m.group(1), m.start(), m.end()) for m in re.finditer(r'/\* 0x[0-9a-f]+ (m[0-9a-f]+_\w+) \*/\n[^\n]+\n\{\n.*?\n\}\n', text, re.S)]


def run_tests(batch, differential):
    mods = ['tests.test_fl36%s_direct' % batch] + (['tests.test_fl36%s_differential' % batch] if differential else [])
    code = ('import unittest,json,sys\nsuite=unittest.defaultTestLoader.loadTestsFromNames(%r)\nres=unittest.TestResult()\nsuite.run(res)\n'
            'print(json.dumps(sorted(set(t.id() for t,_ in res.failures+res.errors))))\n' % mods)
    done = subprocess.run([sys.executable, '-c', code], capture_output=True, text=True, cwd=PROJECT)
    return set(json.loads(done.stdout.strip().splitlines()[-1]))


def main():
    batch = sys.argv[1]
    differential = '--differential' in sys.argv
    src = PROJECT / ('src/original_methods_fl36%s.c' % batch)
    original = src.read_text()
    sys.path.insert(0, str(PROJECT / 'tests'))
    fx = importlib.import_module('fl36%s_fixtures' % batch)
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
                    new, n = re.subn(rx, fn, body, count=1)
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
