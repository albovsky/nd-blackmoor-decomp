#!/usr/bin/env python3
"""FL-48 scenario lab: build a scenario by hand that tells a surviving mutant from the original, for one row.

  fl48_lab.py ROW SEED --show
        the scenario's initial registers and stack arguments, the cells the ORIGINAL reads before it writes them (the inputs you may override), the callee stubs it calls (index k, target,
        and the eax/ecx/edx each returned), its writes and final registers, and whether it faults
  fl48_lab.py ROW SEED --kill KIND:LINE [--kill ...] [--set ADDR:SIZE:VALUE ...] [--stub K:REG:VALUE ...] [--save]
        runs the scenario (seed + overrides) on the original, the unmutated translation and every mutant of each KIND:LINE (kind and 0-based line number as in the packet); prints for each
        mutant 'KILLED' (its digest differs from the original) or 'same'. The scenario counts only if the original does not fault and the unmutated translation agrees with it.
        --set overrides SIZE (1,2,4) bytes at ADDR with VALUE (numbers may be hex); --stub K:REG:VALUE sets the eax (REG 0), ecx (1) or edx (2) that the K-th callee stub returns.
        --stubwrite K:ADDRESS:VALUE makes the K-th callee stub also store the dword VALUE at ADDRESS (a callee may write any cell, e.g. a loop counter); both sides honour it
        --save appends a scenario that kills something to tasks/fl48-lab-found.json (the same format as scripts/fl45_targeted.py output; scripts/fl48_apply.py adds it to the corpus).
Run from outputs/blackmoor-decomp.   Seeds: any integer (the row's corpus seeds are in tests/fl41_corpus.json; other integers are fine, `this` and the arguments follow from the seed).
"""
import argparse
import ctypes
import json
from pathlib import Path
import random
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_world as W
import fl41_mutation_check as M

import os
FOUND = Path(os.environ.get('FL48_LAB_OUT', str(PROJECT / 'tasks/fl48-lab-found.json')))


def num(x):
    return int(x, 0)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('row')
    ap.add_argument('seed', type=int)
    ap.add_argument('--show', action='store_true')
    ap.add_argument('--kill', action='append', default=[])
    ap.add_argument('--set', action='append', default=[])
    ap.add_argument('--stub', action='append', default=[])
    ap.add_argument('--stubwrite', action='append', default=[], help='K:ADDRESS:VALUE the K-th callee also stores the dword VALUE at ADDRESS')
    ap.add_argument('--save', action='store_true')
    ap.add_argument('--skip', default='', help='comma-separated mutant numbers (as printed) not to run, e.g. a mutant that never terminates and would kill the lab by its alarm')
    a = ap.parse_args()
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    e = corpus[a.row]
    va = int(a.row, 16)
    row = W.row_info(va, e['body'], {int(k, 16): v for k, v in e['callees'].items()}, {int(k, 16): v for k, v in e['imports'].items()}, e['fs'])
    ov = []
    for s in a.set:
        ad, sz, v = s.split(':')
        ov.append((num(ad), num(sz), num(v)))
    for s in a.stub:
        k, r, v = s.split(':')
        ov.append((W.STUB_OVR + 16 * num(k) + 4 * num(r), 4, num(v)))
    for s in a.stubwrite:
        k, ad, v = s.split(':')
        ov.append((W.STUB_WR + 16 * num(k), 4, num(ad)))
        ov.append((W.STUB_WR + 16 * num(k) + 4, 4, num(v)))
    ov = tuple(ov)
    if a.show:
        regs, args, patches = W.initial_state(row, a.seed)
        print('initial regs', {k: hex(v) for k, v in regs.items()})
        print('stack args', [hex(x) for x in args])
        o = W.run_original(row, a.seed, ov, observe=True)
        print('fault:', o.fault)
        first_write = {}
        for k, (ad, n, v) in enumerate(o.writes):
            for b in range(ad, ad + n):
                first_write.setdefault(b, k)
        seen = set()
        print('input cells (address size value), in order of first read:')
        for ad, n, v, w in o.reads:
            if 0x401000 <= ad < W.DATA_START or any(first_write.get(b, 1 << 30) < w for b in range(ad, ad + n)) or (ad, n) in seen:
                continue
            seen.add((ad, n))
            print('  0x%x %d 0x%x' % (ad, n, v))
            if len(seen) >= 80:
                print('  ...')
                break
        print('callee stubs:')
        for k, c in enumerate(o.calls):
            print('  stub %d: %s' % (k, [hex(x) if isinstance(x, int) else x for x in c]))
        print('writes (address size value):', [(hex(x), n, hex(v)) for x, n, v in o.writes][:40])
        print('final regs:', {k: hex(v) for k, v in (o.regs or {}).items()})
    if not a.kill:
        return 0
    wanted = set()
    for k in a.kill:
        kind, line = k.split(':')
        wanted.add((kind, int(line)))
    text = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())[a.row]
    helper = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text()).get('0x50c920', '')
    muts = [m for m in M.mutants(text, va, random.Random(va), 100000, True) if (m[0], m[1]) in wanted]
    named = [(k, n, t.replace('m%x_mut' % va + t.split('m%x_mut' % va)[1].split('(')[0], 'm%x_mut%d' % (va, i), 1)) for i, (k, n, t) in enumerate(muts)]
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        src.write_text('#include "original_methods_fl41.h"\n' + (helper if 'FL41_CALL_LIFTED' in text else '') + text + '\n' + '\n'.join(t for _, _, t in named))
        built = subprocess.run(['cc', '-std=c11', '-O0', '-shared', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(Path(tmp) / 'm.so')], capture_output=True, text=True)
        if built.returncode:
            print('compile error', built.stderr[:500])
            return 1
        lib = ctypes.CDLL(str(Path(tmp) / 'm.so'))
        o = W.run_original(row, a.seed, ov)
        t0 = W.run_native(lib, row, a.seed, ov)
        print('original fault:', o.fault, '| unmutated translation agrees:', (not t0.fault and t0.digest() == o.digest()))
        if o.fault or t0.fault or t0.digest() != o.digest():
            print('scenario unusable')
            return 1
        killed = []
        for i, (kind, n, t) in enumerate(named):
            if str(i) in a.skip.split(','):
                print('skipped #%d %s line %d' % (i, kind, n))
                continue
            class Shim:
                def __getattr__(self, name, i=i):
                    return getattr(lib, 'm%x_mut%d' % (va, i))
            import signal
            signal.alarm(10)
            try:
                m = W.run_native(Shim(), row, a.seed, ov)
                res = 'KILLED' if (m.fault or m.digest() != o.digest()) else 'same'
            except Exception as ex:
                res = 'KILLED(%s)' % type(ex).__name__
            signal.alarm(0)
            print('%-7s #%d %s line %d: %s' % (res, i, kind, n, t.split('\n')[n].strip()[:110]))
            if res.startswith('KILLED'):
                killed.append([kind, n])
        if a.save and killed:
            found = json.loads(FOUND.read_text()) if FOUND.exists() else {}
            found.setdefault(a.row, {'found': [], 'alive': -1, 'tried': 0})['found'].append([a.seed, [list(x) for x in ov], killed])
            FOUND.write_text(json.dumps(found, indent=1, sort_keys=True) + '\n')
            print('saved')
    return 0


if __name__ == '__main__':
    sys.exit(main())
