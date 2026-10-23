#!/usr/bin/env python3
"""FL-43: directed hardening. For the survivors of tests/fl41_mutation_check.py that no proof explains, look for a scenario that tells the mutant from the original.

A survivor is a mutant that no seed of the row's corpus (and none of the extra and hardening seeds) separates from the original bytes. Random seeds seldom hit the boundary a
mutant of a compare or a load width needs, so this builds scenarios from the corpus seeds on purpose: it runs the original on a corpus scenario, finds the memory cells the run
reads before it writes them (the inputs), and sets one cell at a time (the memory overrides of the scenario format, which both the original and the translation honour) to
  the other operand of a compare it feeds, +-1 (so that a neighbouring jump condition goes the other way), or its negation (so that an add in place of the subtract agrees on zero),
  the value with a high half (`v | 0x10000`, `v ^ 0x80000000`, `v & 0xffff0000 | 0x10000`, `v | 0x100`) so that a narrower read differs.
A scenario counts only if the UNMUTATED translation agrees with the original on it. The scenarios that kill a survivor are appended to the row's seeds in tests/fl41_corpus.json
(the differential test and the oracle then run them), and the check is rerun by the caller.

  fl43_directed.py --log <mutation log> --survivors <fl41_survivors.py output> [--rows 0x4d58eb,...] [--scenarios 400] [--jobs 4]       (run from outputs/blackmoor-decomp)
"""
import argparse
import ctypes
import json
import multiprocessing as mp
import os
from pathlib import Path
import random
import re
import signal
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_world as W
import fl41_mutation_check as M
import fl41_generate as G

SOURCE = PROJECT / 'src/original_methods_fl41.c'
CORPUS = PROJECT / 'tests/fl41_corpus.json'


def cell_variants(rng, cells):
    out = []
    for a, n, v in cells:
        if n == 4:
            for new in (v | 0x10000, v ^ 0x80000000, (v & 0xffff0000) | 0x10000, v | 0x100, (v + 1) & 0xffffffff, (v - 1) & 0xffffffff):
                out.append((a, n, new))
        elif n == 2:
            out.append((a, n, v | 0x100))
            out.append((a, n, v ^ 0x8000))
        else:
            out.append((a, n, v ^ 0x80))
    return out


def scenarios_for(row, seed, overrides, rng, limit):
    o = W.run_original(row, seed, overrides, observe=True)
    if o.fault:
        return []
    first_write = {}
    for k, (a, n, v) in enumerate(o.writes):
        for b in range(a, a + n):
            first_write.setdefault(b, k)
    cells, seen = [], set()
    for a, n, v, wc in o.reads:
        if 0x401000 <= a < W.DATA_START or (a, n) in seen or any(first_write.get(b, 1 << 30) < wc for b in range(a, a + n)):
            continue
        seen.add((a, n))
        cells.append((a, n, v))
    out = [tuple(c) for c in G.children(row, o, overrides, [], rng)]
    for address, bits, a, b, ca, cb, wc in o.events:            # a compare whose operands are memory cells: make the other operand the negation (an add instead of a subtract then agrees on zero)
        mask = (1 << bits) - 1
        for value, other, cell in ((a, b, ca), (b, a, cb)):
            if cell and not any(first_write.get(x, 1 << 30) < wc for x in range(cell[0], cell[0] + cell[1])):
                for new in ((-other) & mask, (-other + 1) & mask, (-other - 1) & mask):
                    if new != value:
                        out.append((cell[0], cell[1], new))
    out += cell_variants(rng, cells)
    rng.shuffle(out)
    return out[:limit]


def work(args):
    key, entry, text, helper, mutants, budget = args
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    rng = random.Random(va)
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        body = text + '\n' + '\n'.join(t for _, _, _, t in mutants)
        src.write_text('#include "original_methods_fl41.h"\n' + helper + body)
        built = subprocess.run(['cc', '-std=c11', '-O0', '-shared', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(Path(tmp) / 'm.so')], capture_output=True, text=True)
        if built.returncode:
            return key, {'error': built.stderr[:300]}
        lib = ctypes.CDLL(str(Path(tmp) / 'm.so'))

        class Shim:
            def __init__(self, name):
                self.name = name

            def __getattr__(self, n):
                return getattr(lib, self.name)

        alive = {i for i in range(len(mutants))}
        found = []          # (seed, overrides, [mutant indexes killed])
        tried = 0
        base = [(sd, [tuple(o) for o in ov]) for sd, ov in entry['seeds']]
        queue = list(base)
        qi = 0
        while alive and tried < budget and qi < 3 * len(queue):
            sd, ov = queue[qi % len(queue)]
            qi += 1
            for cell in scenarios_for(row, sd, ov, rng, 25):
                if not alive or tried >= budget:
                    break
                merged = {(a, n): v for a, n, v in ov}
                merged[(cell[0], cell[1])] = cell[2]
                new = tuple(sorted((a, n, v) for (a, n), v in merged.items()))
                tried += 1
                o = W.run_original(row, sd, new)
                if o.fault:
                    continue
                t = W.run_native(lib, row, sd, new)
                if t.fault or t.digest() != o.digest():
                    continue                      # the unmutated translation differs here: no kill
                ref = o.digest()
                killed = []
                for k in sorted(alive):
                    r_fd, w_fd = os.pipe()
                    pid = os.fork()
                    if pid == 0:
                        try:
                            signal.alarm(20)
                            os.close(r_fd)
                            m = W.run_native(Shim('m%x_mut%d' % (va, k)), row, sd, new)
                            os.write(w_fd, b'1' if (m.fault or m.digest() != ref) else b'0')
                        finally:
                            os._exit(0)
                    os.close(w_fd)
                    data = os.read(r_fd, 4)
                    os.close(r_fd)
                    os.waitpid(pid, 0)
                    if data != b'0':
                        killed.append(k)           # a difference, or a hang or crash of the mutant
                if killed:
                    found.append((sd, [list(c) for c in new], [mutants[k][:3] for k in killed]))
                    alive -= set(killed)
                    queue.append((sd, list(new)))
        return key, {'found': found, 'alive': [mutants[k][:3] for k in sorted(alive)], 'tried': tried}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--survivors', required=True)
    ap.add_argument('--rows')
    ap.add_argument('--scenarios', type=int, default=400)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--out')
    a = ap.parse_args()
    surv = json.loads(Path(a.survivors).read_text())
    corpus = json.loads(CORPUS.read_text())
    funcs = M.split_functions(SOURCE.read_text())
    helper = funcs.get('0x50c920', '')
    jobs = []
    for key in surv['unexplained_rows']:
        if a.rows and key not in a.rows.split(','):
            continue
        # the unexplained survivors of the row, as (kind, line, identity)
        wanted = {(i[0], i[3]) for i in surv['rows_with_survivors'][key] if i[1] is None}
        va = int(key, 16)
        muts = M.mutants(funcs[key], va, random.Random(va), 100000, True)
        picked = [(k, n, M.line_hash(t, n), t) for k, n, t in muts if (k, n) in wanted]
        # the survivors that were not unexplained are not needed; mutant texts carry their own function names
        picked = [(k, n, h, t.replace('m%x_mut' % va, 'm%x_mut' % va)) for k, n, h, t in picked]
        named = []
        for idx, (k, n, h, t) in enumerate(picked):
            named.append((k, n, h, re.sub(r'm%x_mut\d+' % va, 'm%x_mut%d' % (va, idx), t, count=1)))
        jobs.append((key, corpus[key], funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '', named, a.scenarios))
    result = {}
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for key, res in pool.imap_unordered(work, jobs):
            result[key] = res
            if 'error' in res:
                print(key, 'ERROR', res['error'])
                continue
            print('%s tried %d scenarios; killed %d mutants with %d scenarios; %d still alive' % (key, res['tried'], sum(len(f[2]) for f in res['found']), len(res['found']), len(res['alive'])), flush=True)
            if res['found']:
                corpus[key]['seeds'].extend([sd, ov] for sd, ov, _ in res['found'])
                CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    if a.out:
        Path(a.out).write_text(json.dumps(result, indent=1, sort_keys=True) + '\n')


if __name__ == '__main__':
    main()
