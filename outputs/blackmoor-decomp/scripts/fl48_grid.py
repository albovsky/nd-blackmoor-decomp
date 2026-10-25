#!/usr/bin/env python3
"""FL-48: a grid search for scenarios that tell the surviving mutants of a row from the original. scripts/fl45_targeted.py starts from the corpus seeds that reach the mutated instruction; a corpus
seed whose run faults in the original (an unmapped stack argument, say) is useless there, although one callee result or one cell changed would make it a good scenario. This one starts from
EVERY seed in a range (the original must not fault on the scenario, the unmutated translation must agree with it) and tries, one at a time:
  - each callee stub's eax, ecx, edx set to a value of VALS (a bit above 16 bits, a high bit, 1, -1, ...)
  - each of the first CELLS input cells (memory read before written) set to variants of its value
Every scenario that kills an alive mutant is recorded (seed, overrides, killed (kind, line)); fl48_apply.py puts them into the corpus.

  fl48_grid.py --survivors SURV.json [--rows 0x...,..] [--seeds 0:120] [--jobs 3] [--seconds 600] --out FILE        (run from outputs/blackmoor-decomp)
"""
import argparse
import ctypes
import json
import multiprocessing as mp
import os
from pathlib import Path
import random
import signal
import subprocess
import sys
import tempfile
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_world as W
import fl41_mutation_check as M

VALS = (0x10000, 0x10001, 0x100, 0x80000000, 0xffffffff, 1, 0, 0x8000, 0xff, 0x7fffffff, 0x12345678)


def cell_variants(v, n):
    mask = (1 << (8 * n)) - 1
    out = {0, 1, mask, (v + 1) & mask, (v - 1) & mask, v ^ 1, v | 0x100, v | 0x10000, v | 0x80000000, v ^ 0x80000000, v | 0x8000, v ^ 0x80, 2, 0xff, 0x7fffffff}
    return sorted(x & mask for x in out if (x & mask) != v)


def inputs_of(o):
    first_write = {}
    for k, (a, n, v) in enumerate(o.writes):
        for b in range(a, a + n):
            first_write.setdefault(b, k)
    seen, cells = set(), []
    for a, n, v, w in o.reads:
        if 0x401000 <= a < W.DATA_START or any(first_write.get(b, 1 << 30) < w for b in range(a, a + n)) or (a, n) in seen:
            continue
        seen.add((a, n))
        cells.append((a, n, v))
    return cells


def work(args):
    key, entry, text, helper, wanted, seeds, seconds, cells_cap = args
    deadline = time.time() + seconds
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    muts = [m for m in M.mutants(text, va, random.Random(va), 100000, True) if (m[0], m[1]) in wanted]
    if not muts:
        return key, {'found': [], 'alive': 0, 'tried': 0}
    named = [(k, n, t.replace('m%x_mut%d' % (va, [i for i, mm in enumerate(M.mutants(text, va, random.Random(va), 100000, True)) if mm[2] == t][0]), 'm%x_mut%d' % (va, j), 1)) for j, (k, n, t) in enumerate(muts)]
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        src.write_text('#include "original_methods_fl41.h"\n' + helper + text + '\n' + '\n'.join(t for _, _, t in named))
        built = subprocess.run(['cc', '-std=c11', '-O0', '-shared', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(Path(tmp) / 'm.so')], capture_output=True, text=True)
        if built.returncode:
            return key, {'error': built.stderr[:300], 'found': [], 'alive': -1, 'tried': 0}
        lib = ctypes.CDLL(str(Path(tmp) / 'm.so'))

        class Shim:
            def __init__(self, name):
                self.name = name

            def __getattr__(self, n):
                return getattr(lib, self.name)

        alive = set(range(len(named)))
        found, tried = [], 0

        def scenario(sd, ov):
            nonlocal tried
            tried += 1
            try:
                o = W.run_original(row, sd, ov)
                if o.fault:
                    return
                t = W.run_native(lib, row, sd, ov)
            except Exception:
                return
            if t.fault or t.digest() != o.digest():
                return
            ref = o.digest()
            killed = []
            for k in sorted(alive):
                r_fd, w_fd = os.pipe()
                pid = os.fork()
                if pid == 0:
                    try:
                        signal.alarm(3)
                        os.close(r_fd)
                        m = W.run_native(Shim('m%x_mut%d' % (va, k)), row, sd, ov)
                        os.write(w_fd, b'1' if (m.fault or m.digest() != ref) else b'0')
                    finally:
                        os._exit(0)
                os.close(w_fd)
                data = os.read(r_fd, 4)
                os.close(r_fd)
                os.waitpid(pid, 0)
                if data == b'1':                      # a hang or a crash is NOT counted here: the mutation check decides those under the step budget
                    killed.append(k)
            if killed:
                found.append((sd, [list(c) for c in ov], [named[k][:2] for k in killed]))
                alive.difference_update(killed)

        for sd in seeds:
            if not alive or time.time() > deadline:
                break
            try:
                o = W.run_original(row, sd, (), observe=True)
            except Exception:
                continue
            ncalls = len(o.calls)
            cells = inputs_of(o)[:cells_cap]
            for k in range(min(ncalls, 6)):
                for r in range(3):
                    for v in VALS:
                        if not alive or time.time() > deadline:
                            break
                        scenario(sd, ((W.STUB_OVR + 16 * k + 4 * r, 4, v),))
            if o.fault:
                continue
            for a, n, v in cells:
                for nv in cell_variants(v, n):
                    if not alive or time.time() > deadline:
                        break
                    scenario(sd, ((a, n, nv),))
        return key, {'found': found, 'alive': len(alive), 'tried': tried}


def safe_work(args):
    try:
        return work(args)
    except Exception as ex:
        return args[0], {'error': '%s: %s' % (type(ex).__name__, str(ex)[:200]), 'found': [], 'alive': -1, 'tried': 0}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--survivors', required=True)
    ap.add_argument('--rows')
    ap.add_argument('--seeds', default='0:120')
    ap.add_argument('--jobs', type=int, default=3)
    ap.add_argument('--seconds', type=int, default=600)
    ap.add_argument('--cells', type=int, default=16)
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    lo, hi = a.seeds.split(':')
    seeds = list(range(int(lo), int(hi)))
    surv = json.loads(Path(a.survivors).read_text())
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    helper = funcs.get('0x50c920', '')
    jobs = []
    for key in surv['unexplained_rows']:
        if a.rows and key not in a.rows.split(','):
            continue
        wanted = {(i[0], i[3]) for i in surv['rows_with_survivors'][key] if i[1] is None}
        jobs.append((key, corpus[key], funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '', wanted, seeds, a.seconds, a.cells))
    result = {}
    if Path(a.out).exists():
        result = {k: v for k, v in json.loads(Path(a.out).read_text()).items() if v.get('alive', -1) >= 0}
        jobs = [j for j in jobs if j[0] not in result]
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for key, res in pool.imap_unordered(safe_work, jobs):
            result[key] = res
            if 'error' in res:
                print(key, 'ERROR', res['error'], flush=True)
            else:
                print('%s tried %d scenarios; %d scenarios kill %d mutants; %d still alive' % (key, res['tried'], len(res['found']), sum(len(f[2]) for f in res['found']), res['alive']), flush=True)
            Path(a.out).write_text(json.dumps(result, indent=1, sort_keys=True) + '\n')


if __name__ == '__main__':
    main()
